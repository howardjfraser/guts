class SignupsController < ApplicationController
  skip_before_action :require_login

  def new
    @company = Company.new
    @company.users.build
  end

  def create
    @company = Company.new(signup_params)
    if @company.save
      set_up_owner @company.users.first
      redirect_to users_url, notice: "Congratulations!"
    else
      render 'new'
    end
  end

  private

  def signup_params
    params.require(:company).permit(:name, users_attributes: [:name, :email, :password])
  end

  def set_up_owner user
    user.update_attribute(:role, "admin")
    user.activate
    log_in user
  end

end
