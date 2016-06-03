require 'test_helper'

class InvitationsCreateTest < ActionDispatch::IntegrationTest
  def setup
    super
    ActionMailer::Base.deliveries.clear
  end

  test 'create' do
    log_in_as @brent
    post user_invitation_path(@ricky)
    assert_redirected_to users_path
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  test 'activation digest is set' do
    assert @ricky.activation_digest.nil?
    log_in_as @brent
    post_via_redirect user_invitation_path(@ricky)
    assert !@ricky.reload.activation_digest.nil?
  end
end
