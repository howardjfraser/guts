require 'test_helper'

class CompaniesSelectTest < ActionDispatch::IntegrationTest

  def setup
    @howard = users(:howard)
    @brent = users(:brent)
    @gareth = users(:gareth)

    @hogg = companies(:wernham_hogg)
    @mifflin = companies(:dunder_mifflin)
  end

  test "access" do
    check_access(:forbidden, @gareth) { post select_company_path @hogg }
    check_access(:forbidden, @brent) { post select_company_path @hogg }
    check_redirect(users_path, @howard) { post select_company_path @hogg }
  end

  test "as root, can change company" do
    log_in_as @howard
    assert @howard.company = @hogg
    post select_company_path @mifflin
    assert @howard.company = @mifflin
  end

  test "as admin, can't see select link" do
    log_in_as @brent
    get company_path @hogg
    assert_select "a[href=?]", select_company_path(@hogg), count: 0
  end

end
