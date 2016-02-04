require 'test_helper'

class CompaniesSelectTest < ActionDispatch::IntegrationTest

  def setup
    @howard = users(:howard)
    @brent = users(:brent)
    @hogg = companies(:wernham_hogg)
    @mifflin = companies(:dunder_mifflin)
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
