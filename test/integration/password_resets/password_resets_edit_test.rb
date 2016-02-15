require 'test_helper'

class PasswordResetsEditTest < ActionDispatch::IntegrationTest

  def setup
    super
    ActionMailer::Base.deliveries.clear
  end

  test "email not found" do
    get edit_password_reset_path(@keith.reset_token, email: "")
    assert_redirected_to new_password_reset_url
  end

  test "token not found" do
    get edit_password_reset_path('wrong token', email: @keith.email)
    assert_redirected_to new_password_reset_url
  end

  test "valid token and email" do
    get edit_password_reset_path(@keith.reset_token, email: @keith.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", @keith.email
  end

  test "inactive user" do
    @keith.toggle!(:activated)
    get edit_password_reset_path(@keith.reset_token, email: @keith.email)
    assert_redirected_to new_password_reset_url
    @keith.toggle!(:activated)
  end

  # TODO root user

end
