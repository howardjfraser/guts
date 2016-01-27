class UsersController < ApplicationController

  before_action :check_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all()
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.company = current_user.company
    if @user.save
      @user.send_activation_email
      flash[:success] = "#{@user.name} has been invited"
      redirect_to users_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.name} has been updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    if @user != current_user
      @user.destroy
      flash[:success] = "#{@user.name} has been deleted"
      redirect_to users_url
    else
      flash[:warning] = "You can’t delete yourself"
      redirect_to users_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :admin)
  end

  def check_admin
    unless current_user.admin?
      flash[:danger] = "You’re not allowed to do that"
      redirect_to(root_url)
    end
  end

  def find_user
    @user = User.find(params[:id])
  end

end
