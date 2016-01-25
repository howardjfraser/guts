require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:brent)
    @non_admin = users(:gareth)
    @other = users(:tim)
  end

  test "show self as non-admin has no links" do
    log_in_as(@non_admin)
    get user_path @non_admin
    assert_template 'users/show'
    assert_select 'a[href=?]', edit_user_path(@non_admin), text: 'edit', count: 0
    assert_select 'a[href=?]', user_path(@non_admin), text: 'delete', count: 0
  end

  test "show other as non-admin has no links" do
    log_in_as(@non_admin)
    get user_path @other
    assert_template 'users/show'
    assert_select 'a[href=?]', edit_user_path(@other), text: 'edit', count: 0
    assert_select 'a[href=?]', user_path(@other), text: 'delete', count: 0
  end

  test "show self as admin has edit link only" do
    log_in_as(@admin)
    get user_path @admin
    assert_template 'users/show'
    assert_select 'a[href=?]', edit_user_path(@admin), text: 'edit'
    assert_select 'a[href=?]', user_path(@admin), text: 'delete', count: 0
  end

  test "show other as admin has edit and delete links" do
    log_in_as(@admin)
    get user_path @non_admin
    assert_template 'users/show'
    assert_select 'a[href=?]', edit_user_path(@non_admin), text: 'edit'
    assert_select 'a[href=?]', user_path(@non_admin), text: 'delete'
  end

end
