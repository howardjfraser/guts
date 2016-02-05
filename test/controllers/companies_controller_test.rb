require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase

  def setup
    @howard = users(:howard)
    @brent = users(:brent)
    @michael = users(:michael)
    @gareth = users(:gareth)
  end

  test "stranger access" do
    check_response(:redirect) { get :index }
    check_response(:redirect) { get :show, id: @brent.company }
    check_response(:redirect) { get :edit, id: @brent.company }
    check_response(:redirect) { patch :update, id: @brent.company, company: { name: "NewCo" } }
  end

  test "user access" do
    check_response(:forbidden, @gareth) { get :index }
    check_response(:success, @gareth) { get :show, id: @gareth.company }
    check_response(:forbidden, @gareth) { get :edit, id: @gareth.company }
    check_response(:forbidden, @gareth) { patch :update, id: @gareth.company, company: { name: "NewCo" } }
    check_response(:forbidden, @gareth) { delete :destroy, id: @gareth.company }
    check_response(:forbidden, @gareth) { post :select, id: @michael.company }
  end

  test "admin access" do
    check_response(:forbidden, @brent) { get :index }
    check_response(:success, @brent) { get :show, id: @brent.company }
    check_response(:forbidden, @brent) { get :show, id: @michael.company }
    check_response(:success, @brent) { get :edit, id: @brent.company }
    check_response(:forbidden, @brent) { get :edit, id: @michael.company }
    check_response(:redirect, @brent) { patch :update, id: @brent.company, company: { name: "NewCo" } }
    check_response(:forbidden, @brent) { patch :update, id: @michael.company, company: { name: "NewCo" } }
    check_response(:forbidden, @brent) { delete :destroy, id: @brent.company }
    check_response(:forbidden, @brent) { delete :destroy, id: @michael.company }
    check_response(:forbidden, @brent) { post :select, id: @michael.company}
  end

  test "root access" do
    check_response(:success, @howard) { get :index}
    check_response(:success, @howard) { get :show, id: @brent.company }
    check_response(:success, @howard) { get :show, id: @michael.company }
    check_response(:success, @howard) { get :edit, id: @brent.company }
    check_response(:success, @howard) { get :edit, id: @michael.company }
    check_response(:redirect, @howard) { patch :update, id: @brent.company, company: { name: "NewCo" } }
    check_response(:redirect, @howard) { patch :update, id: @michael.company, company: { name: "NewCo" } }
    check_response(:redirect, @howard) { post :select, id: @michael.company }
    check_response(:redirect, @howard) { delete :destroy, id: @brent.company }
  end

  private

  def check_response response, user=nil
    log_in_as user if user
    yield
    assert_response response
  end

end
