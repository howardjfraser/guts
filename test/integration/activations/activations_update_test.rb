require 'test_helper'

class ActivationsUpdateTest < ActionDispatch::IntegrationTest

  def setup
    super
    ActionMailer::Base.deliveries.clear
  end

  test "successful account activation" do
    user = create_new_user
    patch_via_redirect activation_path(user.activation_token), email: user.email
    assert user.reload.activated?
    assert_template 'users/show'
    assert is_logged_in_as? user
    assert_not user.admin?
  end

  test "invalid account activation" do
    user = create_new_user
    patch activation_path("bad token"), email: user.email
    assert_redirected_to root_url
  end

  private

  def create_new_user
    log_in_as(@brent)
    post users_path, user: { name:  "Example User", email: "user@example.com", password: "password" }
    assigns(:user)
  end

end
