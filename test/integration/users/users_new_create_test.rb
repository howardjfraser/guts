require 'test_helper'

class UsersNewCreateTest < ActionDispatch::IntegrationTest
  def setup
    super
    ActionMailer::Base.deliveries.clear
  end

  test 'access' do
    check_redirect(new_session_url) { get new_user_path }
    check_redirect(new_session_url) { post users_path, user: { name: 'name', email: 'new@company.com' } }

    check_access(:forbidden, @gareth) { get new_user_path }
    check_access(:forbidden, @gareth) { post users_path, user: { name: 'name', email: 'new@company.com' } }

    check_redirect(users_path, @brent) do
      post users_path, user: { name: 'name', email: 'new@company.com' }
    end
  end

  test 'invalid new user' do
    log_in_as @brent

    get new_user_path
    assert_template 'users/new'

    assert_no_difference 'User.count' do
      post users_path, user: { name:  '', email: 'user@invalid' }
    end

    assert_template 'users/new'
    assert_errors_present
  end

  test 'valid new user' do
    log_in_as @brent

    assert_difference 'User.count', 1 do
      post users_path, user: { name:  'Example User', email: 'user@example.com', send_invitation: '1' }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)

    follow_redirect!
    assert_template 'users/index'
    assert user.invited?
  end

  test 'valid new user no invite' do
    log_in_as @brent

    assert_difference 'User.count', 1 do
      post users_path, user: { name:  'Example User', email: 'user@example.com', send_invitation: '0' }
    end

    assert_equal 0, ActionMailer::Base.deliveries.size
    user = assigns(:user)

    follow_redirect!
    assert_template 'users/index'
    assert user.new?
  end

  test 'ajax invalid user' do
    log_in_as @brent
    assert_no_difference 'User.count' do
      xhr :post, users_path(user: { name: '', email: '' })
    end
    assert_template 'users/fail'
    assert_not flash.empty? # js redirects
  end

  test 'ajax valid new user' do
    log_in_as @brent
    assert_difference 'User.count', 1 do
      xhr :post, users_path(user: { name: 'example', email: 'user@example.com' })
    end
    assert_template 'users/create'
  end
end
