class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :check_company, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :hide_root, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.activated(current_user.company)
    @invited = User.invited(current_user.company)
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_success
    else
      create_fail
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, notice: "#{@user.name} has been updated"
    else
      render 'edit'
    end
  end

  def destroy
    if @user != current_user && !@user.last_admin?
      @user.destroy
      redirect_to users_url, notice: "#{@user.name} has been deleted"
    else
      redirect_to users_url, notice: "You can’t delete yourself"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role).merge(company: current_user.company)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def check_company
    forbidden unless current_user.company == @user.company
  end

  def create_success
    UserMailer.activation(@user).deliver_now
    respond_to do |format|
      format.html { redirect_to users_url, notice: "#{@user.name} has been invited" }
      format.js
    end
  end

  def create_fail
    respond_to do |format|
      format.html { render 'new' }
      format.js
    end
  end
end
