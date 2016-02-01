require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @brent = users(:brent)
    @gareth = users(:gareth)
    @tim = users(:tim)
    @michael = users(:michael)
  end

  # TODO split into is logged in, is admin and same company? add activated test?

  test "should redirect users who are not logged in" do
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
    assert_response :forbidden
  end

  test "should redirect create when logged in as non-admin" do
    log_in_as(@gareth)
    patch :create, user: { name: "name", email: "new@company.com" }
    assert_response :forbidden
  end

  test "should redirect edit when logged in as non-admin" do
    log_in_as(@gareth)
    check_edit_redirect @gareth
    check_edit_redirect @brent
  end

  test "should redirect update when logged in as non-admin" do
    log_in_as(@gareth)
    patch :update, id: @brent, user: { name: @brent.name, email: @brent.email }
    assert_response :forbidden
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@gareth)
    assert_no_difference 'User.count' do
      delete :destroy, id: @tim
    end
    assert_response :forbidden
  end

  test "should redirect destroy when trying to delete self as admin" do
    log_in_as(@brent)
    assert_no_difference 'User.count' do
      delete :destroy, id: @brent
    end
    assert_redirected_to users_url
  end

  test 'can’t view user from a different company' do
    log_in_as(@brent)
    get :show, id: @michael
    assert_response :forbidden
  end

  test 'user list does not include other companies' do
    log_in_as(@brent)
    get :index
    users = assigns[:users]
    users.each { |u| assert @brent.company == u.company }
  end

  test 'can’t edit users from a different company' do
    log_in_as(@brent)
    get :edit, id: @michael
    assert_response :forbidden
  end

  test 'can’t update users from a different company' do
    log_in_as(@brent)
    patch :update, id: @michael, user: { email: "new@email.com" }
    assert_response :forbidden
  end

  test 'can’t delete users from a different company' do
    log_in_as(@brent)
    delete :destroy, id: @michael
    assert_response :forbidden
  end

  private

  def check_edit_redirect user
    get :edit, id: user
    assert_response :forbidden
  end

  def check_login_redirect
    yield
    assert_not flash.empty?
    assert_redirected_to login_url
  end

end
