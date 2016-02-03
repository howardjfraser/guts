require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase

  def setup
    @howard = users(:howard)
    @brent = users(:brent)
    @gareth = users(:gareth)
  end

  test "stranger access" do
    check_response :new, :success

    post :create, company: {name: "test", users_attributes: {"0" => {name: "test",
      email: "dave@test.com", password: "aaaaaaaa"}}}
    assert_redirected_to users_url
  end

  test "user access" do
    log_in_as(@gareth)
    check_response :index, :forbidden
  end

  test "admin access" do
    log_in_as(@brent)
    check_response :index, :forbidden
  end

  test "root access" do
    log_in_as(@howard)
    check_response :index, :success
  end

  private

  def check_response action, response
    get action
    assert_response response
  end

end
