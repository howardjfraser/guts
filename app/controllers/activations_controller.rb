class ActivationsController < ApplicationController

  skip_before_action :require_login

  def edit
    # TODO remove email and just find by id?
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      redirect_to user, notice: "Account activated"
    else
      redirect_to root_url, notice: "Invalid activation link"
    end
  end

  # TODO edit above should just set up form, then update to make changes inc. setting pw

end
