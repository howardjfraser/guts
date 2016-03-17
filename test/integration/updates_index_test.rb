require 'test_helper'

class UpdatesIndexTest < ActionDispatch::IntegrationTest
  test 'access' do
    check_redirect(login_url) { get updates_path }
    check_access_zz(:success, [@gareth, @brent, @howard]) { get updates_path }
  end

  test 'updates do not include root user' do
    log_in_as @brent
    get updates_path
    users = assigns[:users]
    users.each { |u| assert u.role != 'root' }
  end
end
