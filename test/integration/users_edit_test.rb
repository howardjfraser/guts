require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other = users(:archer)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "", email: "foo@invalid", password: "foo" }
    check_fail
  end

  test "successful edit" do
    log_in_as(@user)
    patch user_path(@user), user: { name: "dave",email: "dave@dave.com", password: "" }
    check_success @user, true
  end

  test "add admin rights" do
    log_in_as(@user)
    make_archer_admin
  end

  test "prevent removal of last admin" do
    log_in_as(@user)
    patch user_path(@user), user: { admin: "false" }
    check_fail
    assert @user.reload.admin?
  end

  test "allow removal of admin when multiple admins" do
    log_in_as(@user)
    make_archer_admin # create multiple admins
    patch user_path(@user), user: { admin: "false" }
    check_success @user, false
  end

  private

  def make_archer_admin
    assert_not @other.admin?
    patch user_path(@other), user: { admin: "true" }
    check_success @other, true
  end

  def check_success user, is_admin
    follow_redirect!
    assert_template 'users/show'
    assert flash.any?
    assert user.reload.admin? == is_admin
  end

  def check_fail
    # TODO check there are validation errors
    assert_template 'users/edit'
  end

end
