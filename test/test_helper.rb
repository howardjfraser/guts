ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/reporters'
reporter_options = { color: true, slow_count: 5 }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

require 'simplecov'
SimpleCov.start 'rails'
SimpleCov.minimum_coverage 100.0

module ActiveSupport
  class TestCase
    fixtures :all

    def setup
      @howard = users(:howard)
      @brent = users(:brent)
      @michael = users(:michael)
      @gareth = users(:gareth)
      @tim = users(:tim)
      @ricky = users(:ricky)
      @keith = users(:keith)
      @keith.create_reset_digest
      @hogg = companies(:wernham_hogg)
      @mifflin = companies(:dunder_mifflin)
    end

    def user_logged_in?
      !session[:user_id].nil?
    end

    def logged_in_as?(user)
      session[:user_id] == user.id
    end

    def log_in_as(user, options = {})
      password = options[:password] || 'password'
      remember_me = options[:remember_me] || '1'
      if integration_test?
        post_via_redirect session_path, session: { email: user.email, password: password, remember_me: remember_me }
      else
        session[:user_id] = user.id
      end
    end

    def assert_errors_present
      assert_select 'div.field_with_errors'
    end

    private

    def integration_test?
      defined?(post_via_redirect)
    end

    def check_access(expected, *users)
      if users.empty?
        yield
        assert_response expected
      else
        users.each do |u|
          log_in_as u
          yield
          assert_response expected
        end
      end
    end

    def check_redirect(expected, user = nil)
      log_in_as user unless user.nil?
      yield
      assert_redirected_to expected
    end
  end
end
