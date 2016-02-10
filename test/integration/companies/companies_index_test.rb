require 'test_helper'

class CompaniesIndexTest < ActionDispatch::IntegrationTest

  test "access" do
    check_redirect(login_url) { get companies_path }
    check_access(:forbidden, @gareth) { get companies_path }
    check_access(:forbidden, @brent) { get companies_path }
    check_access(:success, @howard) { get companies_path }
  end

  test "as root, nav has companies link" do
    log_in_as @howard
    follow_redirect!
    assert_template 'users/index'
    assert_select 'a[href=?]', users_path
    get companies_path
    assert_select "h1", "Companies"
  end

  test "as admin, nav doesn’t have companies link" do
    log_in_as @brent
    follow_redirect!
    assert_template 'users/index'
    assert_select 'a[href=?]', companies_path, count: 0
  end

end
