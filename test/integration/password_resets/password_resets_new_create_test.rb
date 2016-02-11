require 'test_helper'

class PasswordResetsNewCreateTest < ActionDispatch::IntegrationTest

  def setup
    super
    ActionMailer::Base.deliveries.clear
  end

  test "new" do
    get new_password_reset_path
    assert_template 'password_resets/new'
  end

  test "invalid email"  do
    post password_resets_path, password_reset: { email: "" }
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end

  test "root user" do
    post password_resets_path, password_reset: { email: @howard.email }
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end

  test "valid reset request" do
    post password_resets_path, password_reset: { email: @brent.email }
    assert_not_equal @brent.reset_digest, @brent.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

end
