require 'test_helper'

class CompaniesIndexTest < ActionDispatch::IntegrationTest

  def setup
    @howard = users(:howard)
    @brent = users(:brent)
  end

  test "as root, nav has companies link" do
    log_in_as @howard
    follow_redirect!
    assert_template 'users/index'
    assert_select 'a[href=?]', users_path
    get companies_path
    assert_select "h1", "Companies"
  end

  test "as admin, nav doesn’t have companies link" do
    log_in_as @brent
    follow_redirect!
    assert_template 'users/index'
    assert_select 'a[href=?]', companies_path, count: 0
  end

end
