require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid sign up" do
    get signup_path

    assert_no_difference 'User.count' do
      post users_path, user: { name:  "", email: "user@invalid", password: "foo", password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert_select 'div.errors'
  end


  test "valid signup information with account activation" do
    get signup_path

    assert_difference 'User.count', 1 do
      post users_path, user:
        { name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)

    check_not_activated user
    check_login_before_activation user
    check_invalid_token user
    check_wrong_email user
    check_valid_token_and_email user
  end

  private

  def check_not_activated user
    assert_not user.activated?
  end

  def check_login_before_activation user
    log_in_as(user)
    assert_not is_logged_in?
  end

  def check_invalid_token user
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
  end

  def check_wrong_email user
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
  end

  def check_valid_token_and_email user
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end
