class CompaniesController < ApplicationController

  skip_before_action :require_login, only: [:new, :create]

  def new
    @company = Company.new
    @company.users.build
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      flash[:success] = "Congratulations!"
      set_up_owner @company.users.first
      redirect_to users_url
    else
      render 'new'
    end
  end

  private

  def company_params
    params.require(:company).permit(:id, :name,
      users_attributes: [:id, :name, :email, :password])
  end

  def set_up_owner user
    user.update_attribute(:admin, true)
    user.activate
    log_in user
  end

end
