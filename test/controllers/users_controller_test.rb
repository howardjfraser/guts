require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @admin = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect new when not logged in" do
    get :new
    assert_not flash.empty?
    assert_redirected_to login_url
    log_in_as(@admin)
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @admin
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when not admin" do
    get :edit, id: @other_user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect show when not logged in" do
    get :show, id: @admin
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @admin, user: { name: @admin.name, email: @admin.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get :edit, id: @admin
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @admin
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @admin
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when trying to delete self" do
    log_in_as(@admin)
    assert_no_difference 'User.count' do
      delete :destroy, id: @admin
    end
    assert_redirected_to users_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch :update, id: @admin, user: { name: @admin.name, email: @admin.email }
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@admin)
    assert_not @other_user.admin?
    patch :update, id: @other_user, user: { password: "", password_confirmation: "", admin: true }
    assert_redirected_to user_path(@other_user)
    assert_not @other_user.reload.admin?
  end
end
