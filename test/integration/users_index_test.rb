require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin has new and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'a[href=?]', new_user_path, text: 'Add User'

    User.all.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin doesn't have new and delete links" do
    log_in_as(@non_admin)
    get users_path
    assert_select "a[href=?]", new_user_path, test: 'Add User', count: 0
    assert_select 'a', text: 'delete', count: 0
  end

end
