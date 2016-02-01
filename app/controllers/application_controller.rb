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
    render(file: File.join(Rails.root, 'public/403.html'), status: 403, layout: false)
  end

end
