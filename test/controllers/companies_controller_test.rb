require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase

  def setup
    @howard = users(:howard)
    @brent = users(:brent)
    @gareth = users(:gareth)
  end

  test "stranger access" do
    check_response(:success) { get :new }

    check_response(:redirect) do
      assert_difference 'Company.count', 1 do
        post :create, company: {name: "test", users_attributes: {"0" => {name: "test",
          email: "dave@test.com", password: "aaaaaaaa"}}}
      end
    end
  end

  test "user access" do
    check_response(:forbidden, @gareth) { get :index }
  end

  test "admin access" do
    check_response(:forbidden, @brent) { get :index }
  end

  test "root access" do
    check_response(:success, @howard) { get :index}
  end

  private

  def check_response response, user=nil
    log_in_as user if user
    yield
    assert_response response
  end

end
