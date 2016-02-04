class CompaniesController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :find_company, only: [:show, :edit, :update, :destroy, :select]
  before_action :require_root, only: [:index, :destroy, :select]
  before_action :require_admin, only: [:edit, :update]
  before_action :check_company, only: [:show, :edit, :update]

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

  def edit
  end

  def update
    # TODO user[0] params are permitted?
    if @company.update_attributes(company_params)
      redirect_to @company, notice: "#{@company.name} updated"
    else
      render :edit
    end
  end

  def destroy
    if @company == current_user.company
      redirect_to companies_url, notice: "Can’t delete currently selected company"
    else
      @company.destroy
      redirect_to companies_url, notice: "#{@company.name} deleted"
    end
  end

  def select
    current_user.update_attribute(:company, @company)
    redirect_to users_url, notice: "Company changed to #{@company.name}"
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
