require 'test_helper'

class RootUsersUpdateTest < ActionDispatch::IntegrationTest
  test 'access' do
    check_redirect(new_session_url) { patch root_user_path @hogg }
    check_access(:forbidden, @gareth, @brent) { patch root_user_path @hogg }
    check_redirect(users_path, @howard) { patch root_user_path @hogg }
  end

  test 'as root, can change company' do
    log_in_as @howard
    assert @howard.company = @hogg
    patch root_user_path @mifflin
    assert @howard.company = @mifflin
  end

  test 'as root, can see companies link' do
    log_in_as @howard
    assert_select 'a[href=?]', companies_path
  end

  test "as admin, can't see companies link" do
    log_in_as @brent
    assert_select 'a[href=?]', companies_path, count: 0
  end
end
