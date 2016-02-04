class CompaniesController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :find_company, only: [:show]
  before_action :require_root, only: [:index]
  before_action :require_admin, only: [:show]
  before_action :check_company, only: [:show]

  def index
    @companies = Company.all
  end

  def show
  end

  def new
    @company = Company.new
    @company.users.build
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      set_up_owner @company.users.first
      redirect_to users_url, notice: "Congratulations!"
    else
      render 'new'
    end
  end

  private

  def company_params
    params.require(:company).permit(:id, :name, users_attributes: [:id, :name, :email, :password])
  end

  def find_company
    @company = Company.find(params[:id])
  end

  def check_company
    forbidden unless @company == current_user.company || current_user.root?
  end

  def set_up_owner user
    user.update_attribute(:role, "admin")
    user.activate
    log_in user
  end

end
