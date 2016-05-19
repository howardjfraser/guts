require 'test_helper'

class PasswordChangesEditTest < ActionDispatch::IntegrationTest
  test 'access' do
    check_redirect(new_session_url) { get edit_password_change_path @brent }
    check_access(:success, @gareth) { get edit_password_change_path @gareth }
    check_access(:forbidden, @gareth) { get edit_password_change_path @tim }
    check_access(:success, @brent) { get edit_password_change_path @brent }
    check_access(:forbidden, @brent) { get edit_password_change_path @tim }
    check_access(:forbidden, @brent) { get edit_password_change_path @michael }
    check_access(:forbidden, @howard) { get edit_password_change_path @howard }
    check_access(:forbidden, @howard) { get edit_password_change_path @brent }
    check_access(:forbidden, @howard) { get edit_password_change_path @tim }
  end
end
