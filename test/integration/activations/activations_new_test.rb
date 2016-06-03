require 'test_helper'

class ActivationsNewTest < ActionDispatch::IntegrationTest
  def setup
    super
    ActionMailer::Base.deliveries.clear
  end

  test 'account activation' do
    log_in_as(@brent)

    assert_difference 'User.count', 1 do
      post users_path, user: { name:  'Example User', email: 'user@example.com', send_invitation: '1' }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)

    check_not_active user
    check_no_login_before_activation user
    check_invalid_token user
    # check_wrong_email user
    check_valid_credentials user
  end

  private

  def check_not_active(user)
    assert_not user.active?
  end

  def check_no_login_before_activation(user)
    log_in_as(user)
    assert_not logged_in_as? user
  end

  def check_invalid_token(user)
    get new_user_activation_path(user, token: 'invalid token')
    assert_not logged_in_as? user
  end

  # def check_wrong_email(user)
  #   get new_user_activation_path(user, token.activation_token, email: 'wrong')
  #   assert_not logged_in_as? user
  # end

  def check_valid_credentials(user)
    get new_user_activation_path(user, token: user.activation_token)
    assert_template 'activations/new'
  end
end
