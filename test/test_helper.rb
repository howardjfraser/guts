ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/reporters"
Minitest::Reporters.use!

require 'simplecov'
SimpleCov.start 'rails'

class ActiveSupport::TestCase
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

  def is_logged_in?
    !session[:user_id].nil?
  end

  def is_logged_in_as? user
    session[:user_id] == user.id
  end

  def log_in_as(user, options = {})
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post_via_redirect login_path, session: { email: user.email,password: password, remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

  private

    def integration_test?
      defined?(post_via_redirect)
    end

    def check_access expected, user=nil
      log_in_as user unless user.nil?
      yield
      assert_response expected
    end

    def check_redirect expected, user=nil
      log_in_as user unless user.nil?
      yield
      assert_redirected_to expected
    end
end
