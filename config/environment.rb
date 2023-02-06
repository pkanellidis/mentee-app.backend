# Load the Rails application.
require_relative "application"

Rails.application.config.deployment_environment = ENV['ENVIRONMENT']

# Initialize the Rails application.
Rails.application.initialize!
