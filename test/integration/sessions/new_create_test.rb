require 'test_helper'

class NewCreateTest < ActionDispatch::IntegrationTest

  def setup
    @brent = users(:brent)
  end

  test "login fail" do
    get "/login"
    assert_template "sessions/new"
    post login_path, session: { email: "", password: "" }
    follow_redirect!
    assert_template "sessions/new"
    assert flash.any?
  end

  test "login" do
    get "/login"
    assert_template "sessions/new"
    post login_path, session: { email: "david@office.com", password: "password" }
    follow_redirect!
    assert_template "users/index"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert is_logged_in?
  end

  test "login with remembering" do
    log_in_as(@brent, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    log_in_as(@brent, remember_me: '0')
    assert_nil cookies['remember_token']
  end

  test "login with friendly forwarding" do
    get edit_user_path(@brent)
    assert_equal edit_user_url(@brent), session[:forwarding_url]
    log_in_as(@brent)
    assert_redirected_to edit_user_path(@brent)
    assert_nil session[:forwarding_url]
  end

end
