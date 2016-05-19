class RootUsersController < ApplicationController
  before_action :require_root

  def update
    @company = Company.find params[:id]
    current_user.update_attribute(:company, @company)
    redirect_to users_url, notice: "Company changed to #{@company.name}"
  end
end
