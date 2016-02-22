require 'test_helper'

class PasswordResetsUpdateTest < ActionDispatch::IntegrationTest
  def setup
    super
    ActionMailer::Base.deliveries.clear
  end

  test 'empty pw' do
    patch password_reset_path(@keith.reset_token), email: @keith.email, user: { password: '' }
    assert_select 'div.errors'
  end

  test 'pw too short' do
    patch password_reset_path(@keith.reset_token), email: @keith.email, user: { password: 'aaa' }
    assert_select 'div.errors'
  end

  test 'expired token' do
    @keith.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@keith.reset_token), email: @keith.email, user: { password: 'foobar' }
    assert_response :redirect
    follow_redirect!
    assert_not flash.empty?
    assert_match(/expired/i, response.body)
  end

  test 'valid pw reset' do
    patch password_reset_path(@keith.reset_token), email: @keith.email, user: { password: 'foobaz' }
    assert user_logged_in?
    assert_not flash.empty?
    assert_redirected_to @keith
  end
end
