json.cache! ['api_v1_entities_index', @cache_key] do
  json.array!(@entities) do |entity|
    json.extract! entity, :id, :loginid, :name, :type
  end
end
