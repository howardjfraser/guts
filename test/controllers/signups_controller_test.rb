require 'test_helper'

class SignupsControllerTest < ActionController::TestCase

  test "stranger access" do
    check_response(:success) { get :new }
    check_response(:redirect)  { post :create, company: {name: "test", users_attributes: {"0" => {name: "test",
      email: "dave@test.com", password: "aaaaaaaa"}}}}
  end

  private

  def check_response response
    yield
    assert_response response
  end

end
