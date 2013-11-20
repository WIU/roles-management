json.cache! ['v1', @cache_key] do
  json.array!(@role_assignments) do |assignment|
    json.extract! assignment, :parent_id, :id
    json.entity do
      json.id assignment.entity.id
      json.name assignment.entity.name
      json.type assignment.entity.type
    end
    json.role do
      json.id assignment.role.id
      json.name assignment.role.name
    end
    json.application do
      json.id assignment.role.application.id
      json.name assignment.role.application.name
    end
  end
end
