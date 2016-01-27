require 'test_helper'

class UsersAuthTest < ActionController::TestCase
  tests UsersController

  def setup
    @brent = users(:brent)
    @michael = users(:michael)
  end

  test 'can’t view user from different company' do
    log_in_as(@brent)
    get :show, id: @michael
    assert_redirected_to root_url
    assert_not flash.empty?
  end

  test 'user list does not include other companies' do
    log_in_as(@brent)
    get :index
    users = assigns[:users]
    users.each { |u| assert @brent.company == u.company }
  end

end
