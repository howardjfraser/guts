require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Enigmatic Springs"
    assert_select "h1", "Home"
  end

  test "should get sign up" do
    get :sign_up
    assert_response :success
    assert_select "h1", "Sign up"
  end

end
