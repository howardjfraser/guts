class UpdatesController < ApplicationController
  def index
    # include users with no updates
    @users = User.company(current_user.company)
  end
end
