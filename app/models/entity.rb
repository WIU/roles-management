class Entity < ActiveRecord::Base
  using_access_control

  has_many :role_assignments, :foreign_key => "entity_id", :dependent => :destroy
  has_many :roles, :through => :role_assignments, :source => :role, :dependent => :destroy
  has_many :application_ownerships, :foreign_key => "entity_id", :dependent => :destroy
  has_many :application_operatorships, :foreign_key => "entity_id", :dependent => :destroy
  belongs_to :ou

  # We need to be able to assign :type when creating an entity using the Entity super-class
  def self.attributes_protected_by_default
    # default is ["id","type"]
    ["id"]
  end
end
