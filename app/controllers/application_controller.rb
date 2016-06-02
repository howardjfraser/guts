class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception
  before_action :require_login
  helper_method :logged_in?, :current_user?, :current_user, :current_company

  private

  def require_login
    return if logged_in?
    session[:forwarding_url] = request.url if request.get?
    redirect_to new_session_url, notice: 'Please log in'
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
