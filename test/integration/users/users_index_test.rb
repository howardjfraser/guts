require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  test "access" do
    check_redirect(login_url) { get users_path }
  end

  test 'user list does not include other companies' do
    log_in_as @brent
    get users_path
    users = assigns[:users]
    users.each { |u| assert @brent.company == u.company }
  end

  test 'user list does not include root users' do
    log_in_as @brent
    get users_path
    users = assigns[:users]
    users.each { |u| assert u.role != "root" }
  end

end
