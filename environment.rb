# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.

if defined?(APP_CONFIG).nil?
  if File.exists?("./config/config.yml")
    APP_CONFIG = YAML.load_file("./config/config.yml")['staging'].symbolize_keys
  else
    APP_CONFIG = {staging: {}}
  end
end