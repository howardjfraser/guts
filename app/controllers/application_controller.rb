class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :require_login

  private

  def require_login
    unless logged_in?
      session[:forwarding_url] = request.url if request.get?
      redirect_to login_url, notice: "Please log in"
    end
  end

  def require_admin
    forbidden unless current_user.admin?
  end

  def require_root
    forbidden unless current_user.root?
  end

  # prevent changes *to* root rather than *by*, confusing?
  def prevent_root
    forbidden if @user.root?
  end

  def forbidden
    render(file: File.join(Rails.root, 'public/403.html'), status: 403, layout: false)
  end

end
