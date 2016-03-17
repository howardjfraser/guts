require 'test_helper'

class CompaniesSelectTest < ActionDispatch::IntegrationTest
  test 'access' do
    check_redirect(login_url) { post select_company_path @hogg }
    check_access(:forbidden, @gareth, @brent) { post select_company_path @hogg }
    check_redirect(users_path, @howard) { post select_company_path @hogg }
  end

  test 'as root, can change company' do
    log_in_as @howard
    assert @howard.company = @hogg
    post select_company_path @mifflin
    assert @howard.company = @mifflin
  end

  test "as admin, can't see select link" do
    log_in_as @brent
    get company_path @hogg
    assert_select 'a[href=?]', select_company_path(@hogg), count: 0
  end
end
