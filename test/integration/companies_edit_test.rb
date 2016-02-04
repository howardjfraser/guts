require 'test_helper'

class CompaniesEditTest < ActionDispatch::IntegrationTest

  def setup
    @howard = users(:howard)
    @brent = users(:brent)
    @gareth = users(:gareth)
  end

  test "valid edit" do
    log_in_as @brent
    get edit_company_path @brent.company
    patch company_path(@brent.company), company: { name: "NewCo" }
    follow_redirect!
    assert_template "companies/show"
    assert !flash.empty?
    assert @brent.reload.company.name == "NewCo"
  end

  test "invalid edit" do
    log_in_as @brent
    get edit_company_path @brent.company
    patch company_path(@brent.company), company: { name: "" }
    assert_template "companies/edit"
    assert @brent.reload.company.name != "NewCo"
  end

end
