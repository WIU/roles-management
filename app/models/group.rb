# Group shares many attributes with entity.
class Group < Entity
  using_access_control

  has_many :memberships, :class_name => "GroupMembership", :dependent => :destroy
  has_many :members, :through => :memberships, :source => :entity
  has_many :role_assignments, :foreign_key => "entity_id", :dependent => :destroy
  has_many :roles, :through => :role_assignments, :dependent => :destroy
  has_many :group_ownerships, :dependent => :destroy
  has_many :owners, :through => :group_ownerships, :source => "entity", :dependent => :destroy
  has_many :application_ownerships, :foreign_key => "entity_id", :dependent => :destroy
  has_many :application_operatorships, :foreign_key => "entity_id", :dependent => :destroy
  has_many :group_operatorships, :dependent => :destroy
  has_many :operators, :through => :group_operatorships, :source => "entity", :dependent => :destroy
  has_many :rules, :foreign_key => 'group_id', :class_name => "GroupRule", :dependent => :destroy

  validates_presence_of :name

  attr_accessible :name, :description, :type, :owner_ids, :operator_ids, :rules_attributes, :memberships_attributes

  accepts_nested_attributes_for :rules, :allow_destroy => true
  accepts_nested_attributes_for :memberships, :allow_destroy => true

  def as_json(options={})
    { :id => self.id, :name => self.name, :type => 'Group', :description => self.description,
      :owners => self.owners.map{ |o| { id: o.id, loginid: o.loginid, name: o.name } },
      :operators => self.operators.map{ |o| { id: o.id, loginid: o.loginid, name: o.name } },
      :memberships => self.memberships.includes(:entity).map{ |m| { id: m.id, entity_id: m.entity.id, name: m.entity.name, loginid: m.entity.loginid, calculated: m.calculated } },
      :rules => self.rules.map{ |r| { id: r.id, column: r.column, condition: r.condition, value: r.value } } }
  end

  # Returns identifying string for logging purposes. Other classes implement this too.
  # Format: (Class name:id,identifying fields)
  def log_identifier
    "(Group:#{id},#{name})"
  end

  # Returns all members, both explicitly assigned and calculated via rules.
  # Recurses groups all the way down to return a list of _only_people_.
  def flattened_members
    results = []

    members.all.each do |e|
      if e.type == "Group"
        e.flattened_members.each do |m|
          results << m
        end
      else
        results << e
      end
    end

    # Only return a unique list
    results.uniq{ |x| x.id }
  end

  # Calculates (and resets) all group_members based on rules.
  # Will delete any *_member_assignment flagged as calculated and rebuild
  # from rules.
  # This algorithm starts with an empty set, then runs all 'is'
  # rules, intersecting those sets, then makes a second pass and
  # removes anyone who fails a 'is not' rule.
  def recalculate_members!
    Rails.logger.tagged "Group #{id}" do
      results = []

      recalculate_start = Time.now

      logger.debug "Reassembling group members using rule result cache ..."

      # Step One: Build groups out of each 'is' rule,
      #           groupping rules of similar type together via OR
      #           Note: we ignore the 'loginid' column as it is calculated separately
      Rails.logger.tagged "Step One" do
        rules.select{ |r| r.condition == "is" and GroupRule.valid_columns.reject{|x| x == "loginid"}.include? r.column }.group_by(&:column).each do |ruleset|
          ruleset_results = []

          ruleset[1].each do |rule|
            logger.debug "Rule (#{rule.id}, #{rule.column} #{rule.condition} #{rule.value}) has #{rule.results.length} result(s)"
            ruleset_results << rule.results.map{ |r| r.entity_id }
          end

          reduced_results = ruleset_results.reduce(:+)
          logger.debug "Adding #{reduced_results.length} results to the total"
          results << reduced_results
        end
        
        logger.debug "Ending step one with #{results.length} results"
      end

      # Step Two: AND all groups from step one together
      Rails.logger.tagged "Step Two" do
        results = results.inject(results.first) { |sum,n| sum &= n }
        results = [] unless results # reduce/inject may return nil
        logger.debug "ANDing all results together yields #{results.length} results"
      end

      # Step Three: Pass over the result from step two and
      # remove anybody who violates an 'is not' rule
      Rails.logger.tagged "Step Three" do
        results = results.find_all{ |member|
          keep = true
          rules.select{ |r| r.condition == "is not" }.each do |rule|
            keep &= rule.matches(member)
          end
          keep
        }
        logger.debug "Removing any 'is not' violates yielded #{results.length} results"
      end

      # Step Four: Process any 'loginid is' rules
      Rails.logger.tagged "Step Four" do
        rules.select{ |r| r.condition == "is" and r.column == "loginid" }.each do |rule|
          logger.debug "Processing loginid is rule #{rule.value}..."
          results << rule.results.map{ |r| r.entity_id }
        end
        
        logger.debug "'Login ID is' additions yields #{results.length} results"
      end

      results.flatten!
      logger.debug "Results flattened, count now at #{results.length} results"

      # Ensure the mass GroupMembership creation (and subsequent mass RoleAssignment creation)
      # doesn't trigger a flurry of trigger_sync - we can intelligently do this group's roles
      # after the new RoleAssignments are created.
      Thread.current[:will_sync_role] = [] unless Thread.current[:will_sync_role]
      roles.each do |r|
        Thread.current[:will_sync_role] << r.id
        logger.debug "Locking role #{r.id} against syncing - we will call trigger_sync! after recalculation."
      end

      # Look for memberships which need to be removed
      GroupMembership.where(:group_id => self.id, :calculated => true).each do |membership|
        # Note: Array.delete returns nil iff result is not in array
        if results.delete(membership.entity_id) == nil
          GroupMembership.destroying_calculated_group_membership do
            GroupMembership.recalculating_membership do
              membership.destroy
            end
          end
        end
      end

      # Look for memberships to add
      # Whatever's left in results are memberships which don't already exist
      # and need to be created.
      results.each do |r|
        GroupMembership.recalculating_membership do
          memberships << GroupMembership.new(:entity_id => r, :calculated => true)
        end
      end

      logger.debug "Calculated #{results.length} results. Membership now at #{memberships.length} members. Took #{Time.now - recalculate_start}s."
      #diary "Membership recalculated to #{memberships.length} members"
      
      # As promised, now that all the GroupMembership and RoleAssignment objects are created,
      # we will sync roles in one sweep instead of allowing the flurry of activity to create
      # chaotic redundancies with trigger_sync.
      roles.each do |r|
        Thread.current[:will_sync_role].delete(r.id)
        logger.debug "Unlocking role #{r.id} for syncing and calling trigger_sync!."
        r.trigger_sync!
      end

      logger.debug "Completed recalculate_members!, including role trigger syncs. Total elapsed time was #{Time.now - recalculate_start}s."
    end
  end
  
  # Records all IDs found while traversing up the parent graph.
  # Algorithm ends either when a duplicate ID is found (indicates a loop)
  # or no more parents exist (indicates no loops).
  def no_loops_in_group_membership_graph(seen_ids = [])
    return false if seen_ids.include?(id)

    seen_ids << id

    memberships.each do |membership|
      if membership.group.no_loops_in_group_membership_graph(seen_ids.dup) == false
        errors[:base] << "Group membership cannot be cyclical"
        return false
      end
    end
    
    return true
  end

  def trigger_sync
    logger.info "Group #{id}: trigger_sync called, calling trigger_sync on #{roles.count} roles"
    #diary "Triggering all #{roles.count} roles to sync."
    roles.all.each { |role| role.trigger_sync! }
  end
end
