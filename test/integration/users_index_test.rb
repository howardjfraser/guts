require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin has pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin doesn't have delete links" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "index only includes activated users" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'Michael Example', count: 1
    @admin.toggle!(:activated)
    get users_path
    assert_select 'a', text: 'Michael Example', count: 0

    # redirect for unactivated users
    get user_path @admin
    assert_redirected_to root_path
  end
end
