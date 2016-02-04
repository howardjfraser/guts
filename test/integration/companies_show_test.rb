require 'test_helper'

class CompaniesShowTest < ActionDispatch::IntegrationTest

  def setup
    @howard = users(:howard)
    @brent = users(:brent)
    @gareth = users(:gareth)
  end

  test "as admin, edit link is shown" do
    log_in_as @brent
    get company_path @brent.company
    assert_select 'a[href=?]', edit_company_path(@brent.company), count: 1
  end

  test "as user, edit link is not shown" do
    log_in_as @gareth
    get company_path @gareth.company
    assert_select 'a[href=?]', edit_company_path(@gareth.company), count: 0
  end

end
