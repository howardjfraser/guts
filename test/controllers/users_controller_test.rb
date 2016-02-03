require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @brent = users(:brent)
    @gareth = users(:gareth)
    @tim = users(:tim)
    @michael = users(:michael)
  end

  # TODO split up access tests?

  test "should redirect users who are not logged in" do
    check_login_redirect { get :index }
    check_login_redirect { get :show, id: @brent }
    check_login_redirect { get :new }
    check_login_redirect { post :create, user: { name: "name", email: "new@company.com" } }
    check_login_redirect { get :edit, id: @brent }
    check_login_redirect { patch :update, id: @brent, user: { name: @brent.name, email: @brent.email } }
    check_login_redirect { delete :destroy, id: @tim }
  end

  test "user access" do
    log_in_as(@gareth)
    get :new
    assert_response :forbidden

    assert_no_difference 'User.count' do
      patch :create, user: { name: "name", email: "new@company.com" }
    end
    assert_response :forbidden

    get :edit, id: @gareth
    assert_response :forbidden

    patch :update, id: @brent, user: { name: @brent.name, email: @brent.email }
    assert_response :forbidden

    assert_no_difference 'User.count' do
      delete :destroy, id: @tim
    end
    assert_response :forbidden
  end

  test "admin access" do
    log_in_as(@brent)
    get :new
    assert_response :success

    assert_difference 'User.count', 1 do
      patch :create, user: { name: "name", email: "new@company.com", password: "password" }
    end
    assert_redirected_to users_url

    get :edit, id: @brent
    assert_response :success

    patch :update, id: @brent, user: { name: "new", email: @brent.email }
    assert_redirected_to user_path @brent

    assert_difference 'User.count', -1 do
      delete :destroy, id: @tim
    end
    assert_redirected_to users_url
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

  def check_login_redirect
    yield
    assert_not flash.empty?
    assert_redirected_to login_url
  end

end
