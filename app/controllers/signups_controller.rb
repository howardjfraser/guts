class SignupsController < ApplicationController
  skip_before_action :require_login

  def new
    @company = Company.new
    @company.users.build
  end

  def create
    @company = Company.new(signup_params)
    if password_empty?
      validate
      render 'new'
    elsif @company.save
      set_up_owner
      redirect_to users_url, notice: 'Get in!'
    else
      render 'new'
    end
  end

  private

  def signup_params
    params.require(:company).permit(:name, users_attributes: [:name, :email, :password])
  end

  def password_empty?
    params[:company][:users_attributes]['0'][:password].empty?
  end

  def validate
    @company.valid? # runs other validations
    @company.users[0].errors.add(:password, 'can’t be empty')
  end

  def set_up_owner
    owner = @company.users.first
    owner.update_attribute(:role, 'admin')
    owner.activate
    log_in owner
  end
end
