require 'test_helper'

class ActivationsUpdateTest < ActionDispatch::IntegrationTest
  def setup
    super
    ActionMailer::Base.deliveries.clear
  end

  test 'successful account activation' do
    create_new_user
    patch_via_redirect activation_path(@user.activation_token), email: @user.email, user: { password: 'new password' }
    assert @user.reload.activated?
    assert_template 'users/show'
    assert logged_in_as? @user
    assert_not @user.admin?
  end

  test 'invalid account activation - bad token' do
    create_new_user
    patch activation_path('bad token'), email: @user.email, user: { password: 'new password' }
    assert_redirected_to root_url
  end

  test 'invalid account activation - invalid pw' do
    create_new_user
    patch activation_path(@user.activation_token), email: @user.email, user: { password: 'zz' }
    assert_select 'div.errors'
    assert_template 'activations/edit'
  end

  test 'invalid account activation - empty pw' do
    create_new_user
    patch activation_path(@user.activation_token), email: @user.email, user: { password: '' }
    assert_select 'div.errors'
    assert_template 'activations/edit'
  end

  private

  def create_new_user
    log_in_as(@brent)
    post users_path, user: { name:  'Example User', email: 'user@example.com' }
    @user = assigns[:user]
  end
end
