require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "error flash only displays once for login fail" do
    get "/login"
    assert_template "sessions/new"
    post login_path, session: { email: "", password: "" }
    assert_template "sessions/new"
    assert flash.any?
    get root_path
    assert flash.empty?
  end

  test "login then logout" do
    log_in
    log_out
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end

  test "login with friendly forwarding" do
    get edit_user_path(@user)
    assert_equal edit_user_url(@user), session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    assert_nil session[:forwarding_url]
  end

  private

  def log_in
    get "/login"
    assert_template "sessions/new"
    post login_path, session: { email: "michael@example.com", password: "password" }
    follow_redirect!
    assert_template "users/index"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert is_logged_in?

    # simulate a user clicking logout in a second window.
    delete logout_path

  end

  def log_out
    delete logout_path
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    refute is_logged_in?
  end

end
