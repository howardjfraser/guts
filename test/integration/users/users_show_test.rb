require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest

  test "access" do
    check_redirect(login_url) { get user_path @brent }
    check_access(:success, @brent) { get user_path @brent}
  end

  test "can’t view user from a different company" do
    check_access(:forbidden, @brent) { get user_path @michael }
  end

  test "can’t view root user" do
    check_access(:forbidden, @howard) { get user_path @howard }
  end

  test "show self as non-admin has no links" do
    log_in_as(@gareth)
    get user_path @gareth
    assert_template 'users/show'
    assert_select 'a[href=?]', edit_user_path(@gareth), text: 'edit', count: 0
    assert_select 'a[href=?]', user_path(@gareth), text: 'delete', count: 0
  end

  test "show other as non-admin has no links" do
    log_in_as(@gareth)
    get user_path @tim
    assert_template 'users/show'
    assert_select 'a[href=?]', edit_user_path(@tim), text: 'edit', count: 0
    assert_select 'a[href=?]', user_path(@tim), text: 'delete', count: 0
  end

  test "show self as admin has edit link only" do
    log_in_as(@brent)
    get user_path @brent
    assert_template 'users/show'
    assert_select 'a[href=?]', edit_user_path(@brent), text: 'edit'
    assert_select 'a[href=?]', user_path(@brent), text: 'delete', count: 0
  end

  test "show other as admin has edit and delete links" do
    log_in_as(@brent)
    get user_path @gareth
    assert_template 'users/show'
    assert_select 'a[href=?]', edit_user_path(@gareth), text: 'edit'
    assert_select 'a[href=?]', user_path(@gareth), text: 'delete'
  end

end
