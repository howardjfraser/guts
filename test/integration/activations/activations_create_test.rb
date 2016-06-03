require 'test_helper'

class ActivationsCreateTest < ActionDispatch::IntegrationTest
  def setup
    super
    ActionMailer::Base.deliveries.clear
  end

  test 'successful account activation' do
    create_new_user
    post_via_redirect user_activation_path(@user, token: @user.activation_token, user: { password: 'new password' })
    assert @user.reload.active?
    assert_template 'users/show'
    assert logged_in_as? @user
    assert_not @user.admin?
  end

  test 'invalid account activation - bad token' do
    create_new_user
    post user_activation_path(@user, token: 'bad token', user: { password: 'new password' })
    assert_redirected_to root_url
  end

  test 'invalid account activation - invalid pw' do
    create_new_user
    post user_activation_path(@user, token: @user.activation_token, user: { password: 'zz' })
    assert_errors_present
    assert_template 'activations/new'
  end

  test 'invalid account activation - empty pw' do
    create_new_user
    post user_activation_path(@user, token: @user.activation_token, user: { password: '' })
    assert_errors_present
    assert_template 'activations/new'
  end

  private

  def create_new_user
    log_in_as(@brent)
    post users_path, user: { name:  'Example User', email: 'user@example.com' }
    @user = assigns[:user]
  end
end
