require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @brent = users(:brent)
    @gareth = users(:gareth)
  end

  test "unsuccessful edit" do
    log_in_as(@brent)
    get edit_user_path(@brent)
    assert_template 'users/edit'
    patch user_path(@brent), user: { name: "", email: "foo@invalid", password: "foo" }
    check_fail
  end

  test "successful edit" do
    log_in_as(@brent)
    patch user_path(@brent), user: { name: "dave",email: "dave@dave.com", password: "" }
    check_success @brent, true
  end

  test "add admin rights" do
    log_in_as(@brent)
    make_gareth_admin
  end

  test "prevent removal of last admin" do
    log_in_as(@brent)
    patch user_path(@brent), user: { role: "user" }
    check_fail
    assert @brent.reload.admin?
  end

  test "allow removal of admin when multiple admins" do
    log_in_as(@brent)
    make_gareth_admin # create multiple admins
    patch user_path(@brent), user: { role: "user" }
    check_success @brent, false
  end

  test "prevent root user being created" do
    log_in_as(@brent)
    patch user_path(@gareth), user: { role: "root" }
    check_fail
    assert @brent.reload.admin?
  end

  private

  def make_gareth_admin
    assert_not @gareth.admin?
    patch user_path(@gareth), user: { role: "admin" }
    check_success @gareth, true
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
