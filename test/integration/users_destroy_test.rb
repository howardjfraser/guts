require 'test_helper'

class UsersDestroyTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:brent)
    @non_admin = users(:gareth)
  end

  test "admin can delete other users" do
    log_in_as(@admin)
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
    assert_not flash.empty?
    follow_redirect!
    assert_template "users/index"
  end

end
