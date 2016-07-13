class CompaniesController < ApplicationController
  before_action :find_company, only: [:show, :edit, :update, :destroy]
  before_action :require_root, only: [:index, :destroy]
  before_action :require_admin, only: [:edit, :update]
  before_action :check_company, only: [:show, :edit, :update]

  def index
    @companies = Company.all.order(:name)
  end

  def show
  end

  def edit
  end

  def update
    if @company.update_attributes(company_params)
      redirect_to @company, notice: "#{@company.name} updated"
    else
      render :edit
    end
  end

  def destroy
    if @company == current_company
      redirect_to companies_url, notice: 'Can’t delete currently selected company'
    else
      @company.destroy
      redirect_to companies_url, notice: "#{@company.name} deleted"
    end
  end

  private

  def company_params
    params.require(:company).permit(:name)
  end

  def find_company
    @company = Company.find(params[:id])
  end

  def check_company
    forbidden unless @company == current_company || current_user.root?
  end
end
