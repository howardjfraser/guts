require 'test_helper'

class DestroyTest < ActionDispatch::IntegrationTest

  def setup
    @brent = users(:brent)
  end

  test "logout" do
    post login_path, session: { email: "david@office.com", password: "password" }
    delete logout_path
    assert_redirected_to root_url
    refute is_logged_in?
  end

end
