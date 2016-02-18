class InvitationsController < ApplicationController
  before_action :find_user, :require_admin

  def resend
    @user.renew_activation_digest
    @user.save
    @user.send_activation_email
    redirect_to users_url, notice: "Invitation for #{@user.name} has been resent "
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

end
