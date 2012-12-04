YELP_API = YAML.load_file("#{::Rails.root}/config/yelp.yml")[::Rails.env]
