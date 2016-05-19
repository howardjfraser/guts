require 'test_helper'

class PasswordChangesUpdateTest < ActionDispatch::IntegrationTest
  test 'access' do
    check_redirect(new_session_url) { patch password_change_path(@brent.id) }

    @gareth.create_reset_digest
    check_redirect(user_path(@gareth), @gareth) do
      patch password_change_path @gareth.id, user: { password: 'new password' }
    end

    check_access(:forbidden, @gareth) { patch password_change_path @tim.id }

    @brent.create_reset_digest
    check_redirect(user_path(@brent), @brent) do
      patch password_change_path @brent, user: { password: 'new password' }
    end

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

  test 'expired token' do
    @gareth.create_reset_digest
    @gareth.update_attribute(:reset_sent_at, 3.hours.ago)
    log_in_as @gareth
    patch_via_redirect password_change_path(@gareth.id), user: { password: 'foobar' }
    assert_not flash.empty?
    assert_match(/expired/i, response.body)
  end

  private

  def update(password)
    @gareth.create_reset_digest
    log_in_as @gareth
    patch password_change_path @gareth.id, user: { password: password }
    assert_errors_present
    assert_template 'password_changes/edit'
  end
end
