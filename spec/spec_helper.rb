require 'rubygems'
require 'spork'
require 'database_cleaner'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAIL_ENV"] ||= 'test'
  unless defined?(Rails)
    require File.dirname(__FILE__) + "/../config/environment"
  end
  require 'rspec/rails'
  # Requires supporting files with custom matchers and macros, etc,
  # in ./suuport/ and its subdirectories.
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
  
  RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false #true  #changed to false for DatabaseCleaners #Also change to false if running selinium
  
  #Added this for database_cleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation #:transaction  #Changed from 'transaction' to 'truncation'...also change to 'truncation' if using selinium
    #DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  
  ###Part of a Spork hack.  See http://bit.ly/arY19y
  #Emulate initializer set_clear_dependencies_hook in
  #railties/lib/rails/application/bootstrap.rb
  ActiveSupport::Dependencies.clear
  
  #Note: This test_sign_in method does not work for integration tests, there is a way to create a helper method that would work for integration tests (exercise in the book)
  def test_sign_in(user)
    #controller.current_user = user #This worked fine, but for some reason we could not use "current_user = nil" without "self" in the sign_out method in sessions_helper
    #A fix was to reuse the method signin in the session_controller as follows
    controller.sign_in(user)  #see sessions_helper comments in sign_out on how this helped fix the problem with the use of "current_user= nil" instead of "self.current_user = nil"
  end
    
  end
end

Spork.each_run do
end

