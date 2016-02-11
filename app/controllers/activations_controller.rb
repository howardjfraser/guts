class ActivationsController < ApplicationController
  skip_before_action :require_login
  before_action :find_user
  before_action :valid_user

  def edit
  end

  def update
    @user.activate
    log_in @user
    redirect_to @user, notice: "Account activated"
  end

  private

  def find_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless (@user && !@user.activated? && @user.authenticated?(:activation, params[:id]))
      redirect_to root_url, notice: "Invalid activation"
    end
  end

end
