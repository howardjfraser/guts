require 'test_helper'

class DestroyTest < ActionDispatch::IntegrationTest

  def setup
    @brent = users(:brent)
    @gareth = users(:gareth)
  end

  test "access" do
    check_redirect(login_url) { delete user_path @brent }
    check_access(:forbidden, @gareth) { delete user_path @gareth }
    check_redirect(users_path, @brent) { delete user_path @gareth }
  end

  test "admin can delete other users" do
    log_in_as(@brent)

    assert_difference 'User.count', -1 do
      delete user_path(@gareth)
    end

    assert_not flash.empty?
    follow_redirect!
    assert_template "users/index"
  end

end
