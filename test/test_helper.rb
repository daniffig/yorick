ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# Disable Chewy (Elasticsearch) in test environment
Chewy.strategy(:bypass)

# Suppress specific deprecation warnings for Rails 7.2 compatibility
ActiveSupport::Deprecation.behavior = :silence

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
