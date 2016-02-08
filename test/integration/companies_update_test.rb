require 'test_helper'

class CompaniesUpdateTest < ActionDispatch::IntegrationTest

  def setup
    @howard = users(:howard)
    @brent = users(:brent)
    @michael = users(:michael)
    @gareth = users(:gareth)
  end

  test "access" do
    check_redirect(login_url) { patch company_path @brent.company, company: { name: "NewCo" } }
    check_access(:forbidden, @gareth) { patch company_path @gareth.company, company: { name: "NewCo" } }
    check_access(:redirect, @brent) { patch company_path @brent.company, company: { name: "NewCo" } }
    check_access(:forbidden, @brent) { patch company_path @michael.company, company: { name: "NewCo" } }
    check_access(:redirect, @howard) { patch company_path @brent.company, company: { name: "NewCo" } }
    check_access(:redirect, @howard) { patch company_path @michael.company, company: { name: "NewCo" } }
  end

end
