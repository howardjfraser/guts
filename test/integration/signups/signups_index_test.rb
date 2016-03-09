require 'test_helper'

class SignupsNewCreateTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'failed form submit, refresh url should redirect to new)' do
    check_redirect(new_signup_url) { get signups_path }
  end
end
