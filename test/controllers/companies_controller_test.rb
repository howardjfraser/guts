require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase

  def setup
    @howard = users(:howard)
    @brent = users(:brent)
    @michael = users(:michael)
    @gareth = users(:gareth)
  end

  test "stranger access" do
    check_response(:success) { get :new }
    check_response(:redirect) { get :index }
    check_response(:redirect) { get :show, id: @brent.company }
    check_response(:redirect) { get :edit, id: @brent.company }

    check_response(:redirect) do
      assert_difference 'Company.count', 1 do
        post :create, company: {name: "test", users_attributes: {"0" => {name: "test",
          email: "dave@test.com", password: "aaaaaaaa"}}}
        assert is_logged_in?
      end
    end
  end

  test "user access" do
    check_response(:forbidden, @gareth) { get :index }
    check_response(:forbidden) { get :show, id: @gareth.company }
    check_response(:forbidden) { get :edit, id: @gareth.company }
  end

  test "admin access" do
    check_response(:forbidden, @brent) { get :index }
    check_response(:success) { get :show, id: @brent.company }
    check_response(:forbidden) { get :show, id: @michael.company }
    check_response(:success) { get :edit, id: @brent.company }
    check_response(:forbidden) { get :edit, id: @michael.company }
  end

  test "root access" do
    check_response(:success, @howard) { get :index}
    check_response(:success) { get :show, id: @brent.company }
    check_response(:success) { get :show, id: @michael.company }
    check_response(:success) { get :edit, id: @brent.company }
    check_response(:success) { get :edit, id: @michael.company }
  end

  private

  def check_response response, user=nil
    log_in_as user if user
    yield
    assert_response response
  end

end
