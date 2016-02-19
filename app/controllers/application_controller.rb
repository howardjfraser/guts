class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :require_login

  private

  def require_login
    return if logged_in?
    session[:forwarding_url] = request.url if request.get?
    redirect_to login_url, notice: 'Please log in'
  end

  def require_admin
    forbidden unless current_user.admin?
  end

  def require_root
    forbidden unless current_user.root?
  end

  # prevent access *to* root - all changes to root are via console
  def hide_root
    forbidden if @user.root?
  end

  def forbidden
    render(file: File.join(Rails.root, 'public/403.html'), status: 403, layout: false)
  end
end
