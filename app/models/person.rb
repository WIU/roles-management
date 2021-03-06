# Person shares many attributes with entity.
# Note that the 'name' field is simply self.first + " " + self.last
# and is thus read-only. The same does not apply for groups.
class Person < Entity
  using_access_control
  include RmBuiltinRoles

  has_many :affiliation_assignments, :dependent => :destroy
  has_many :affiliations, :through => :affiliation_assignments, :uniq => true
  has_many :group_memberships, :foreign_key => "entity_id", :dependent => :destroy
  has_many :groups, :through => :group_memberships, :source => :group
  has_many :role_assignments, :foreign_key => "entity_id", :dependent => :destroy
  has_many :roles, :through => :role_assignments, :source => :role, :dependent => :destroy
  has_many :favorite_relationships, :class_name => "PersonFavoriteAssignment", :foreign_key => "owner_id", :dependent => :destroy
  has_many :favorites, :through => :favorite_relationships, :source => :entity
  has_many :favored_by_relationships, :class_name => "PersonFavoriteAssignment", :foreign_key => "entity_id", :dependent => :destroy # This relationship exists solely so we can remove favorite assignments when a person is deleted.
  has_many :application_ownerships, :foreign_key => "entity_id", :dependent => :destroy
  has_many :application_operatorships, :foreign_key => "entity_id", :dependent => :destroy
  has_many :group_operatorships, :foreign_key => "entity_id", :dependent => :destroy
  has_many :group_ownerships, :foreign_key => "entity_id", :dependent => :destroy
  has_one :student
  belongs_to :title
  belongs_to :major

  accepts_nested_attributes_for :group_ownerships, :allow_destroy => true
  accepts_nested_attributes_for :group_operatorships, :allow_destroy => true
  accepts_nested_attributes_for :group_memberships, :allow_destroy => true
  accepts_nested_attributes_for :role_assignments, :allow_destroy => true

  validates :loginid, :presence => true, :uniqueness => true

  attr_accessible :first, :last, :loginid, :email, :phone, :address, :type, :favorite_ids, :group_memberships_attributes, :group_ownerships_attributes, :group_operatorships_attributes, :role_assignments_attributes, :active

  before_save  :set_name_if_blank
  after_save   :recalculate_group_rule_membership
  after_save   :touch_caches_as_needed
  after_create  { |person| ActivityLog.info!("Created person #{person.name}.", ["person_#{person.id}", 'system']) }
  after_destroy { |person| ActivityLog.info!("Deleted person #{person.name}.", ["person_#{person.id}", 'system']) }

  def as_json(options={})
    { :id => self.id, :name => self.name, :type => 'Person', :email => self.email, :loginid => self.loginid, :first => self.first, :last => self.last, :email => self.email, :phone => self.phone, :address => self.address, :byline => self.byline, :active => self.active, :role_assignments => self.role_assignments.includes(:role).map{ |a| { id: a.id, calculated: a.parent_id?, entity_id: a.entity_id, role_id: a.role.id, token: a.role.token, application_name: a.role.application.name, application_id: a.role.application_id, name: a.role.name, description: a.role.description } }, :favorites => self.favorites.map{ |f| { id: f.id, name: f.name, type: f.type } }, :group_memberships => self.group_memberships.includes(:group).map{ |m| { id: m.id, group_id: m.group.id, name: m.group.name, calculated: m.calculated } }, :group_ownerships => self.group_ownerships.includes(:group).map{ |o| { id: o.id, group_id: o.group.id, name: o.group.name } }, :group_operatorships => self.group_operatorships.includes(:group).map{ |o| { id: o.id, group_id: o.group.id, name: o.group.name } }, :organizations => self.organizations.map{ |o| { id: o.id, name: o.name } }
    }
  end

  # For CSV export
  def self.csv_header
    "ID,Login ID, Email, First, Last".split(',')
  end

  def to_csv
    [id, loginid, email, first, last]
  end

  # Returns identifying string for logging purposes. Other classes implement this too.
  # Format: (Class name:id,identifying fields)
  def log_identifier
    "(Person:#{id},#{loginid},#{name})"
  end

  # Calculates 'byline' for a Person, e.g. "PROGRAMMER V (staff:career)"
  def byline
    if title and title.name
      byline = title.name
    else
      byline = ""
    end
    byline += " (" + affiliations.map{ |x| x.name }.join(", ") + ")" if affiliations.count > 0
    byline
  end

  # Compute their classifications based on their title
  def classifications
    title.classifications
  end

  # Returns a list of symbols as required by the authorization layer (declarative_authorization gem).
  # Currently only have :access and :admin. Note that an :admin user will have both due to :admin
  # being merely an extension on top of permissions already granted via :access.
  def role_symbols
    roles.select{ |r| rm_roles_ids.include? r.id }.map{ |r| r.token.underscore.to_sym }.uniq
  end

  # Returns all applications visible to a user
  # WARNING: This is incredibly slow (due to the .with_permissions_to ?)
  def accessible_applications
    begin
      Application.with_permissions_to(:read).includes(:roles)
    rescue Authorization::NotAuthorized
      []
    end
  end
  
  # Returns all applications the user has an ownership or operatorship on
  def manageable_applications
    if role_symbols.include? :admin
      Application.all
    else
      application_ownerships.map{ |o| o.application } + application_operatorships.map{ |o| o.application }
    end
  end

  def trigger_sync
    logger.info "Person #{id}: trigger_sync called, calling trigger_sync on #{roles.length} roles"
    roles.all.each { |role| role.trigger_sync! }
  end

  def recalculate_group_rule_membership
    if changed.include? "title_id"
      GroupRule.resolve_target!(:title, id)
      GroupRule.resolve_target!(:classification, id)
    end
    if changed.include? "major_id"
      GroupRule.resolve_target!(:major, id)
    end
    if changed.include? "loginid"
      GroupRule.resolve_target!(:loginid, id)
    end
  end
  
  private
  
  # has_many does not have a :touch attribute.
  # If a person goes from inactive to active, we need to ensure
  # any role_assignment or group views are touched correctly.
  def touch_caches_as_needed
    if changed.include? "active"
      role_assignments.each { |ra| ra.touch }
      group_memberships.each { |gm| gm.touch }
      organizations.each { |org| org.touch }
    end
  end

  # If name is unset, construct it from first + last.
  # If that fails, use loginid.
  def set_name_if_blank
    if self.name.blank?
      unless self.first.blank?
        self.name = "#{self.first}"
        self.name = self.name + " " + self.last unless self.last.nil?
      else
        self.name = self.loginid
      end
    end
  end
end
