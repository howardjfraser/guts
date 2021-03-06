require 'test_helper'

class SessionsNewCreateTest < ActionDispatch::IntegrationTest
  test 'login fail - unknown user' do
    get '/session/new'
    assert_template 'sessions/new'
    post_via_redirect session_path, session: { email: '', password: '' }
    assert_template 'sessions/new'
    assert flash.any?
  end

  test 'login fail - pre-activation user' do
    get '/session/new'
    assert_template 'sessions/new'
    post_via_redirect session_path, session: { email: @ricky.email, password: '' }
    assert_template 'sessions/new'
    assert flash.any?
  end

  test 'login fail - wrong pw' do
    get '/session/new'
    assert_template 'sessions/new'
    post_via_redirect session_path, session: { email: @brent.email, password: 'wrong' }
    assert_template 'sessions/new'
    assert flash.any?
  end

  test 'login' do
    get '/session/new'
    assert_template 'sessions/new'
    post_via_redirect session_path, session: { email: 'david@office.com', password: 'password' }
    assert_template 'users/index'
    assert_select 'a[href=?]', new_session_path, count: 0
    assert_select 'a[href=?]', session_path
    assert user_logged_in?
  end

  test 'login with remembering' do
    post session_path, session: { email: 'david@office.com', password: 'password', remember_me: 1 }
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test 'login without remembering' do
    post session_path, session: { email: 'david@office.com', password: 'password', remember_me: 0 }
    assert_nil cookies['remember_token']
  end

  test 'login with friendly forwarding' do
    get edit_user_path(@brent)
    assert_equal edit_user_url(@brent), session[:forwarding_url]
    post session_path, session: { email: 'david@office.com', password: 'password', remember_me: 0 }
    assert_redirected_to edit_user_path(@brent)
    assert_nil session[:forwarding_url]
  end

  test 'login redirect if already logged in' do
    post_via_redirect session_path, session: { email: 'david@office.com', password: 'password' }
    get new_session_path
    assert_redirected_to users_url
  end
end
