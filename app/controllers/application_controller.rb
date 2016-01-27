class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :require_login

  private

  def require_login
    unless logged_in?
      store_location
      redirect_to login_url, notice: "Please log in"
    end
  end

  def forbidden
    flash[:danger] = "You’re not allowed to do that"
    redirect_to root_url
  end

end
