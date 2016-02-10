require 'test_helper'

class ActivationsTest < ActionDispatch::IntegrationTest

  def setup
    super
    ActionMailer::Base.deliveries.clear
  end

  test "access" do
    # TODO how does id / email look up fit in with auth?
  end

  test "account activation" do
    log_in_as(@brent)

    assert_difference 'User.count', 1 do
      post users_path, user:
        { name:  "Example User", email: "user@example.com", password: "password" }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size

    user = assigns(:user)
    check_not_activated user
    check_no_login_before_activation user
    check_invalid_token user
    check_wrong_email user
    check_successful_activation user
  end

  private

  def check_not_activated user
    assert_not user.activated?
  end

  def check_no_login_before_activation user
    log_in_as(user)
    assert_not is_logged_in_as? user
  end

  def check_invalid_token user
    get edit_activation_path("invalid token", email: user.email)
    assert_not is_logged_in_as? user
  end

  def check_wrong_email user
    get edit_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in_as? user
  end

  def check_successful_activation user
    get edit_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in_as? user
    assert_not user.admin?
  end

end