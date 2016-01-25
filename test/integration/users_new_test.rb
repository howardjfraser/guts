require 'test_helper'

class UsersNewTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:brent)
  end

  test "invalid new user" do
    log_in_as(@user)
    get new_user_path

    assert_no_difference 'User.count' do
      post users_path, user: { name:  "", email: "user@invalid", password: "foo" }
    end
    assert_template 'users/new'
    assert_select 'div.errors'
  end

  test "valid new user plus account activation" do
    log_in_as(@user)

    get new_user_path

    assert_difference 'User.count', 1 do
      post users_path, user:
        { name:  "Example User", email: "user@example.com", password: "password" }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size

    user = assigns(:user)

    follow_redirect!
    assert_template 'users/index'
    assert_not flash.empty?

    check_not_activated user
    check_no_login_before_activation user
    check_invalid_token user
    check_wrong_email user
    check_valid_token_and_email user
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
    get edit_activation_path("invalid token")
    assert_not is_logged_in_as? user
  end

  def check_wrong_email user
    get edit_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in_as? user
  end

  def check_valid_token_and_email user
    get edit_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in_as? user
    assert_not user.admin?
  end

end
