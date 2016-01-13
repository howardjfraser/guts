require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @other = users(:lana)
  end

  test "should redirect non-logged in users" do
    get :index
    assert_not flash.empty?
    assert_redirected_to login_url

    get :show, id: @admin
    assert_not flash.empty?
    assert_redirected_to login_url

    get :new
    assert_not flash.empty?
    assert_redirected_to login_url

    assert_no_difference 'User.count' do
      patch :create, user: { name: "name", email: "new@company.com" }
    end
    assert_not flash.empty?
    assert_redirected_to login_url

    get :edit, id: @admin
    assert_not flash.empty?
    assert_redirected_to login_url

    patch :update, id: @admin, user: { name: @admin.name, email: @admin.email }
    assert_not flash.empty?
    assert_redirected_to login_url

    assert_no_difference 'User.count' do
      delete :destroy, id: @other
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect new when logged in as non-admin" do
    log_in_as(@non_admin)
    get :new
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect create when logged in as non-admin" do
    log_in_as(@non_admin)
    patch :create, user: { name: "name", email: "new@company.com" }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect edit when logged in as non-admin" do
    log_in_as(@non_admin)
    check_edit_redirect @non_admin
    check_edit_redirect @admin
  end

  test "should redirect update when logged in as non-admin" do
    log_in_as(@non_admin)
    patch :update, id: @admin, user: { name: @admin.name, email: @admin.email }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@non_admin)
    assert_no_difference 'User.count' do
      delete :destroy, id: @other
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when trying to delete self as admin" do
    log_in_as(@admin)
    assert_no_difference 'User.count' do
      delete :destroy, id: @admin
    end
    assert_redirected_to users_url
  end

  test "should prevent admin attribute being edited via the web" do
    log_in_as(@admin)
    assert_not @non_admin.admin?
    patch :update, id: @non_admin, user: { password: "", password_confirmation: "", admin: true }
    assert_redirected_to user_path(@non_admin)
    assert_not @non_admin.reload.admin?
  end

  private

  def check_edit_redirect user
    get :edit, id: user
    assert_not flash.empty?
    assert_redirected_to root_url
  end

end
