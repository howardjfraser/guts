require 'test_helper'

class PasswordChangesEditTest < ActionDispatch::IntegrationTest

  test "access" do
    check_redirect(login_url) { get edit_password_change_path @brent }
  end

end
