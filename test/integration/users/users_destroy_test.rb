require 'test_helper'

class UsersDestroyTest < ActionDispatch::IntegrationTest
  def setup
    super
    @root = users(:root)
  end

  test 'access' do
    check_redirect(login_url) { delete user_path @brent }
    check_access(:forbidden, @gareth) { delete user_path @gareth }
    check_redirect(users_path, @brent) { delete user_path @gareth }
  end

  test 'admin can delete other users' do
    log_in_as(@brent)

    assert_difference 'User.count', -1 do
      delete user_path(@gareth)
    end

    assert_not flash.empty?
    follow_redirect!
    assert_template 'users/index'
  end

  test "can't delete self as admin" do
    log_in_as @brent
    assert_no_difference 'User.count' do
      delete user_path @brent
    end
    assert_redirected_to users_path
    assert !flash.empty?
  end

  test "can't delete root users" do
    log_in_as @howard
    assert_no_difference 'User.count' do
      delete user_path @root
    end
    assert_response :forbidden
  end

  test 'can’t delete users from a different company' do
    check_access(:forbidden, @brent) do
      assert_no_difference 'User.count' do
        delete user_path @michael
      end
    end
  end

  test "root can't delete last admin" do
    assert @brent.last_admin?
    log_in_as @howard
    assert_no_difference 'User.count' do
      delete user_path @brent
    end
  end

  test 'dependent status updates are destroyed' do
    log_in_as(@brent)
    update_count = @gareth.status_updates.count
    assert update_count > 0
    assert_difference 'StatusUpdate.all.count', -update_count do
      delete user_path @gareth
    end
  end
end
