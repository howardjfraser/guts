require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @brent = users(:brent)
    @gareth = users(:gareth)
    @tim = users(:tim)
    @michael = users(:michael)
  end

  test "can't delete self as admin" do
    check_access(:redirect) do
      assert_no_difference 'User.count' do
        delete :destroy, id: @brent
      end
    end
  end

  test 'can’t view user from a different company' do
    check_access(:forbidden) { get :show, id: @michael }
  end

  test 'user list does not include other companies' do
    log_in_as @brent
    get :index
    users = assigns[:users]
    users.each { |u| assert @brent.company == u.company }
  end

  test 'can’t edit users from a different company' do
    check_access(:forbidden) { get :edit, id: @michael }
  end

  test 'can’t update users from a different company' do
    check_access(:forbidden) { patch :update, id: @michael, user: { email: "new@email.com" } }
  end

  test 'can’t delete users from a different company' do
    check_access (:forbidden) do
      assert_no_difference "User.count" do
        delete :destroy, id: @michael
      end
    end
  end

  private

  def check_login_redirect
    yield
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  def check_access response, user=@brent
    log_in_as user
    yield
    assert_response response
  end

end
