json.cache! ['api_v1_people_index', @cache_key] do
  json.array!(@people) do |person|
    json.extract! person, :id, :loginid, :name
  end
end
