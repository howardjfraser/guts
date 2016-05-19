require 'test_helper'

class CompaniesDestroyTest < ActionDispatch::IntegrationTest
  test 'access' do
    check_redirect(new_session_url) { delete company_path @gareth.company }
    check_access(:forbidden, @gareth) { delete company_path @gareth.company }
    check_access(:forbidden, @brent) { delete company_path @brent.company }
    check_access(:forbidden, @brent) { delete company_path @michael.company }
    check_redirect(companies_path, @howard) { delete company_path @brent.company }
  end

  test 'as root, delete links are shown' do
    log_in_as @howard
    get company_path @howard.company
    assert_select 'a[href=?]', company_path(@howard.company), text: 'delete', count: 1
    get company_path @michael.company
    assert_select 'a[href=?]', company_path(@michael.company), text: 'delete', count: 1
  end

  test 'as admin, delete link is not shown' do
    log_in_as @brent
    get company_path @brent.company
    assert_select 'a[href=?]', company_path(@brent.company), text: 'delete', count: 0
  end

  test "as root, can't delete currently selected company" do
    log_in_as @howard
    assert_difference 'Company.count', 0 do
      delete company_path(@howard.company)
    end
    assert_redirected_to companies_url
  end

  test 'as root, can delete other company' do
    log_in_as @howard
    assert_difference 'Company.count', -1 do
      delete company_path(@michael.company)
    end
    assert_redirected_to companies_url
    User.all.select { |u| assert !u.company.nil? && u.company != @michael.company }
  end

  test 'deleting company deletes users' do
    log_in_as @howard
    user_count = @michael.company.users.count
    assert user_count > 0

    assert_difference 'User.count', -user_count do
      delete company_path @michael.company
    end
  end
end
