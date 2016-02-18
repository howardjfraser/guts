require 'test_helper'

class InvitationsResendTest < ActionDispatch::IntegrationTest

  def setup
    super
    ActionMailer::Base.deliveries.clear
  end

  test "resend invitation" do
    log_in_as @brent
    post resend_invitation_path(@ricky)
    assert_redirected_to users_path
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  test "activate from resent invitation" do
    log_in_as @brent
    post resend_invitation_path(@ricky)
    @ricky = assigns[:user] # in order to get the token
    patch activation_path(@ricky.activation_token), email: @ricky.email, user: { password: "password" }
    assert @ricky.reload.activated?
  end

  test "activation digest changes" do
    old = @ricky.activation_digest
    log_in_as @brent
    post_via_redirect resend_invitation_path(@ricky)
    assert @ricky.reload.activation_digest != old
  end
end
