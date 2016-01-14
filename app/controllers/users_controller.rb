class UsersController < ApplicationController

  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    @users = User.all()
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = "We’ve emailed #{@user.name} an invitation to join Questions"
      redirect_to users_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.name} has been updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if user != @current_user
      user.destroy
      flash[:success] = "#{user.name} has been deleted"
      redirect_to users_url
    else
      flash[:warning] = "You can’t delete yourself"
      redirect_to users_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def admin_user
    unless current_user.admin?
      flash[:danger] = "You’re not allowed to do that"
      redirect_to(root_url)
    end
  end

end
