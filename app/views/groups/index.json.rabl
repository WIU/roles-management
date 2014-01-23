object @groups

@groups.each do |group|
  attributes :id, :name, :description

  child group.members.select{ |m| m.status == true } => :members do |member|
    attributes :id, :name, :type
  end

  # child group.operators.select{ |o| o.status == true } => :operators do |operatorship|
  #   attributes :id, :name
  # end
  # 
  # child group.owners.select{ |o| o.status == true } => :owners do |owner|
  #   attributes :id, :name
  # end
end
