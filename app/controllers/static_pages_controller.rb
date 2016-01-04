class StaticPagesController < ApplicationController

  skip_before_action :require_login

  def home
  end

  def sign_up
  end

end
