require 'test_helper'

class SessionsDestroyTest < ActionDispatch::IntegrationTest
  def setup
    @brent = users(:brent)
  end

  test 'logout' do
    post session_path, session: { email: 'david@office.com', password: 'password' }
    delete session_path
    assert_redirected_to new_session_url
    refute user_logged_in?
  end
end
