require 'test_helper'

class PasswordChangesUpdateTest < ActionDispatch::IntegrationTest
  test 'access' do
    check_redirect(login_url) { patch password_change_path(@brent.id) }

    @gareth.create_reset_digest
    check_redirect(user_path(@gareth), @gareth) {
      patch password_change_path @gareth.id, user: { password: 'new password' }
    }

    check_access(:forbidden, @gareth) { patch password_change_path @tim.id }

    @brent.create_reset_digest
    check_redirect(user_path(@brent), @brent) {
      patch password_change_path @brent, user: { password: 'new password' }
    }

    check_access(:forbidden, @brent) { patch password_change_path @tim.id }
    check_access(:forbidden, @brent) { patch password_change_path @michael.id }
    check_access(:forbidden, @howard) { patch password_change_path @howard.id }
    check_access(:forbidden, @howard) { patch password_change_path @brent.id }
    check_access(:forbidden, @howard) { patch password_change_path @tim.id }
  end

  test 'empty password fails' do
    update ''
  end

  test 'short password fails' do
    update 'aaa'
  end

  private

  def update(password)
    @gareth.create_reset_digest
    log_in_as @gareth
    patch password_change_path @gareth.id, user: { password: password }
    assert_select 'div.errors'
    assert_template 'password_changes/edit'
  end
end
