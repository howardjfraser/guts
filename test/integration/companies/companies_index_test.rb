require 'test_helper'

class CompaniesIndexTest < ActionDispatch::IntegrationTest
  test 'access' do
    check_redirect(new_session_url) { get companies_path }
    check_access(:forbidden, @gareth, @brent) { get companies_path }
    check_access(:success, @howard) { get companies_path }
  end
end
