ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
#require 'rails/test_help'
require 'test/unit/rails/test_help'
require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
Capybara.current_driver = :poltergeist

FileUtils.rm_rf("app/assets/images/tmp")
Tori.config.backend = Tori::Backend::FileSystem.new(Pathname("app/assets/images/tmp"))
Tori.config.filename_callback do |model|
  "testfile.jpg"
end
FileUtils.cp("app/assets/images/testfile.jpg", "app/assets/images/tmp")

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

require_relative "./test_helper/extends"
class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  include TestHelper::Extends
end
