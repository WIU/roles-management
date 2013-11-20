collection @people
cache ['api_v1_people_index', Digest::MD5.hexdigest(@people.map(&:cache_key).to_s)]

attributes :id, :loginid, :name
