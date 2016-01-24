require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase

  test "new is accessible pre-login" do
    get :new
    assert_response :success
    assert_template :new
  end

  test "create is accessible pre-login" do
    post :create, company: {name: "test", users_attributes: {"0" => {name: "test",
      email: "dave@test.com", password: "aaaaaaaa"}}}
    assert_redirected_to users_url
  end

end
