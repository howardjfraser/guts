require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  test "pre-login" do
    get root_path
    assert_template 'sessions/new'
    check_links [1, 1, 1, 0, 0, 0, 0, 0, 0]
  end

  test "logged in" do
    log_in_as @gareth
    assert_template 'users/index'
    check_links @gareth, [0, 0, 0, 1, 2, 0, 0, 0, 1]
  end

  test "logged in as admin" do
    log_in_as @brent
    assert_template 'users/index'
    check_links @brent, [0, 0, 0, 1, 2, 1, 1, 0, 1]
  end

  test "logged in as root" do
    log_in_as @howard
    assert_template 'users/index'
    check_links @howard, [0, 0, 0, 1, 0, 1, 1, 1, 1]
  end

  private

  def check_links user=nil, expected
    assert_select "a[href=?]", new_signup_path, count: expected[0]
    assert_select "a[href=?]", login_path, count: expected[1]
    assert_select "a[href=?]", new_password_reset_path, count: expected[2]
    assert_select "a[href=?]", users_path, count: expected[3]
    assert_select "a[href=?]", user_path(user), count: expected[4] if user
    assert_select "a[href=?]", new_user_path, count: expected[5]
    assert_select "a[href=?]", company_path(user.company), count: expected[6] if user
    assert_select 'a[href=?]', companies_path, count: expected[7]
    assert_select "a[href=?]", logout_path, count: expected[8]
  end
end
