require 'test_helper'

class PasswordChangesCreateTest < ActionDispatch::IntegrationTest
  test 'access' do
    check_redirect(new_session_url) { post user_password_change_path(@brent) }

    @gareth.create_reset_digest
    check_redirect(user_path(@gareth), @gareth) do
      post user_password_change_path @gareth.id, user: { password: 'new password' }
    end

    check_access(:forbidden, @gareth) { post user_password_change_path @tim }

    @brent.create_reset_digest
    check_redirect(user_path(@brent), @brent) do
      post user_password_change_path @brent, user: { password: 'new password' }
    end

    check_access(:forbidden, @brent) { post user_password_change_path @tim }
    check_access(:forbidden, @brent) { post user_password_change_path @michael }
    check_access(:forbidden, @howard) { post user_password_change_path @howard }
    check_access(:forbidden, @howard) { post user_password_change_path @brent }
    check_access(:forbidden, @howard) { post user_password_change_path @tim }
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
    post_via_redirect user_password_change_path(@gareth), user: { password: 'foobar' }
    assert_not flash.empty?
    assert_match(/expired/i, response.body)
  end

  private

  def update(password)
    @gareth.create_reset_digest
    log_in_as @gareth
    post user_password_change_path @gareth, user: { password: password }
    assert_errors_present
    assert_template 'password_changes/new'
  end
end
