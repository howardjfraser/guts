class UpdatesController < ApplicationController
  def index
    # to include users with no updates
    @users = User.company(current_user.company).each
  end
end
