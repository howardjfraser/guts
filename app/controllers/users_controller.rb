class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :check_company, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :hide_root, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.where(company: current_user.company)
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      redirect_to users_url, notice: "#{@user.name} has been invited"
    else
      render 'new'
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
    if @user != current_user
      @user.destroy
      redirect_to users_url, notice: "#{@user.name} has been deleted"
    else
      redirect_to users_url, notice: "You can’t delete yourself"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :role).merge(company: current_user.company)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def check_company
    forbidden unless current_user.company == @user.company
  end

  def hide_root
    forbidden if @user.root?
  end



end
