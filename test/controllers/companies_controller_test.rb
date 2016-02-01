require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase

  def setup
    @howard = users(:howard)
    @brent = users(:brent)
  end

  test "as stranger, new is accessible" do
    get :new
    assert_response :success
    assert_template :new
  end

  test "as stranger, create is accessible" do
    post :create, company: {name: "test", users_attributes: {"0" => {name: "test",
      email: "dave@test.com", password: "aaaaaaaa"}}}
    assert_redirected_to users_url
  end

  test "as admin, index is forbidden" do
    log_in_as(@brent)
    get :index
    assert_response :forbidden
  end

  test "as root, index is accessible" do
    log_in_as(@howard)
    get :index
    assert_response :success
  end

end
