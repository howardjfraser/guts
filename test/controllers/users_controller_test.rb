require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @brent = users(:brent)
    @gareth = users(:gareth)
    @tim = users(:tim)
  end

  test "should redirect non-logged in users" do
    check_login_redirect { get :index }
    check_login_redirect { get :show, id: @brent }
    check_login_redirect { get :new }
    check_login_redirect { post :create, user: { name: "name", email: "new@company.com" } }
    check_login_redirect { get :edit, id: @brent }
    check_login_redirect { patch :update, id: @brent, user: { name: @brent.name, email: @brent.email } }
    check_login_redirect { delete :destroy, id: @tim }
  end

  test "should redirect new when logged in as non-admin" do
    log_in_as(@gareth)
    get :new
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect create when logged in as non-admin" do
    log_in_as(@gareth)
    patch :create, user: { name: "name", email: "new@company.com" }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect edit when logged in as non-admin" do
    log_in_as(@gareth)
    check_edit_redirect @gareth
    check_edit_redirect @brent
  end

  test "should redirect update when logged in as non-admin" do
    log_in_as(@gareth)
    patch :update, id: @brent, user: { name: @brent.name, email: @brent.email }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@gareth)
    assert_no_difference 'User.count' do
      delete :destroy, id: @tim
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when trying to delete self as admin" do
    log_in_as(@brent)
    assert_no_difference 'User.count' do
      delete :destroy, id: @brent
    end
    assert_redirected_to users_url
  end

  private

  def check_edit_redirect user
    get :edit, id: user
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  def check_login_redirect
    yield
    assert_not flash.empty?
    assert_redirected_to login_url
  end

end
