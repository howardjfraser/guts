class UpdatesController < ApplicationController
  def index
    # include users with no updates
    @users = User.company(current_user.company)
  end

  def create
    @update = current_user.updates.build update_params
    @update.save ? create_success : create_fail
  end

  private

  def update_params
    params.require(:update).permit(:message)
  end

  def create_success
    respond_to do |format|
      format.html { redirect_to updates_url, notice: 'Update posted' }
      format.js
    end
  end

  def create_fail
    respond_to do |format|
      format.html { render 'new' }
      format.js { render 'fail' }
    end
  end
end
