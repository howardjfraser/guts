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

  private

  def log_in
    get "/login"
    assert_template "sessions/new"
    post login_path, session: { email: "michael@example.com", password: "password" }
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
  end

  def log_out
    delete logout_path
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
  end

end
