require 'test_helper'

class IndexTest < ActionDispatch::IntegrationTest

  def setup
    @brent = users(:brent)
    @gareth = users(:gareth)
  end

  test "index as admin has new user link" do
    log_in_as(@brent)
    get users_path
    assert_template 'users/index'
    assert_select 'a[href=?]', new_user_path, text: 'Add User'
  end

  test "index as non-admin doesn't have new user link" do
    log_in_as(@gareth)
    get users_path
    assert_select "a[href=?]", new_user_path, test: 'Add User', count: 0
  end

end
