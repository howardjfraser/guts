class InvitationsController < ApplicationController
  before_action :find_user, :require_admin

  def create
    @user.invite
    redirect_to users_url, notice: "#{@user.name} has been invited"
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end
