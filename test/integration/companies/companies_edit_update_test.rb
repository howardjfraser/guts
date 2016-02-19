require 'test_helper'

class CompaniesEditUpdateTest < ActionDispatch::IntegrationTest
  test "edit access" do
    check_redirect(login_url) { get edit_company_path @brent.company }
    check_access(:forbidden, @gareth) { get edit_company_path @gareth.company }
    check_access(:success, @brent) { get edit_company_path @brent.company }
    check_access(:forbidden, @brent) { get edit_company_path @michael.company }
    check_access(:success, @howard) { get edit_company_path @brent.company }
    check_access(:success, @howard) { get edit_company_path @michael.company }
  end

  test "update access" do
    check_redirect(login_url) { patch company_path @brent.company, company: { name: "new name" } }
    check_access(:forbidden, @gareth) { patch company_path @gareth.company, company: { name: "new name" } }

    check_redirect(company_path(@brent.company), @brent) {
      patch company_path @brent.company, company: { name: "new name" } }

    check_access(:forbidden, @brent) { patch company_path @michael.company, company: { name: "new name" } }

    check_redirect(company_path(@brent.company), @howard) {
      patch company_path @brent.company, company: { name: "new name" } }

    check_redirect(company_path(@michael.company), @howard) {
      patch company_path @michael.company, company: { name: "new name" } }
  end

  test "valid edit & update" do
    log_in_as @brent
    get edit_company_path @brent.company
    patch company_path(@brent.company), company: { name: "NewCo" }
    follow_redirect!
    assert_template "companies/show"
    assert !flash.empty?
    assert @brent.reload.company.name == "NewCo"
  end

  test "invalid edit & update" do
    log_in_as @brent
    get edit_company_path @brent.company
    patch company_path(@brent.company), company: { name: "" }
    assert_template "companies/edit"
    assert @brent.reload.company.name != "NewCo"
  end
end
