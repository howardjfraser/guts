require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "",email: "foo@invalid", password: "foo" }
    # TODO check there are validation errors
    assert_template 'users/edit'
  end

  test "successful edit " do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    patch user_path(@user), user: { name: "dave",email: "dave@dave.com", password: "" }
    follow_redirect!
    assert_template "users/show"
    assert flash.any?
  end

end
