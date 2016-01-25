require 'test_helper'

class NavTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:brent)
    @non_admin = users(:gareth)
  end

  test "pre-login nav" do
    get root_path
    assert_template 'static_pages/welcome'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", user_path(@admin), count: 0
    assert_select "a[href=?]", logout_path, count: 0
  end

  test "post-login nav as admin" do
    log_in_as @admin
    follow_redirect!
    check_logged_in_links
    assert_select "a[href=?]", new_user_path
  end

  test "post-login nav as non-admin" do
    log_in_as @non_admin
    follow_redirect!
    check_logged_in_links
    assert_select "a[href=?]", new_user_path, count: 0
  end

  private

  def check_logged_in_links
    assert_template 'users/index'
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@admin)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", root_path, count: 0
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", login_path, count: 0
  end

end
