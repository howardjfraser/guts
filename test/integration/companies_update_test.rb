require 'test_helper'

class CompaniesUpdateTest < ActionDispatch::IntegrationTest

  def setup
    @howard = users(:howard)
    @brent = users(:brent)
    @michael = users(:michael)
    @gareth = users(:gareth)
  end

  test "access" do
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

end
