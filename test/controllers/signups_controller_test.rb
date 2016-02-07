require 'test_helper'

class SignupsControllerTest < ActionController::TestCase

  test "stranger access" do
    check_access(:success) { get :new }
    check_access(:redirect)  { post :create, company: {name: "test", users_attributes: {"0" => {name: "test",
      email: "dave@test.com", password: "aaaaaaaa"}}}}
  end

  private

end
