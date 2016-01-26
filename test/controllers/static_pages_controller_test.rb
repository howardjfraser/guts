require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  test "welcome is accessible without login" do
    get :welcome
    assert_response :success
    assert_select "title", "Guts"
    assert_select "h1", "Welcome"
  end

end
