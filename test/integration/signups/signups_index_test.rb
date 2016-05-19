require 'test_helper'

class SignupsIndexTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'failed form submit, manual url refresh should redirect to new)' do
    check_redirect(new_signup_url) { get signups_path }
  end
end
