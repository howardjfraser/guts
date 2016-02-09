require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @brent = users(:brent)
    @gareth = users(:gareth)
  end

  test "access" do
    check_redirect(login_url) { get users_path }
  end

  test 'user list does not include other companies' do
    log_in_as @brent
    get users_path
    users = assigns[:users]
    users.each { |u| assert @brent.company == u.company }
  end

  # TODO user list does not include root

  test "index as admin has new user link" do
    log_in_as(@brent)
    get users_path
    assert_template 'users/index'
    assert_select 'a[href=?]', new_user_path, text: 'Add User'
  end

  test "index as non-admin doesn't have new user link" do
    log_in_as(@gareth)
    get users_path
    assert_select "a[href=?]", new_user_path, test: 'Add User', count: 0
  end

end
