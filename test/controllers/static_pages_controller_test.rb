require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  test "home is accessible without login" do
    get :home
    assert_response :success
    assert_select "title", "Enigmatic Springs"
    assert_select "h1", "Home"
  end

end
