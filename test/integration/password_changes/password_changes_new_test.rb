require 'test_helper'

class PasswordChangesNewTest < ActionDispatch::IntegrationTest
  test 'access' do
    check_redirect(new_session_url) { get new_user_password_change_path @brent }
    check_access(:success, @gareth) { get new_user_password_change_path @gareth }
    check_access(:forbidden, @gareth) { get new_user_password_change_path @tim }
    check_access(:success, @brent) { get new_user_password_change_path @brent }
    check_access(:forbidden, @brent) { get new_user_password_change_path @tim }
    check_access(:forbidden, @brent) { get new_user_password_change_path @michael }
    check_access(:forbidden, @howard) { get new_user_password_change_path @howard }
    check_access(:forbidden, @howard) { get new_user_password_change_path @brent }
    check_access(:forbidden, @howard) { get new_user_password_change_path @tim }
  end
end
