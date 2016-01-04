require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  test "should get welcome" do
    get :welcome
    assert_response :success
    assert_select "title", "Enigmatic Springs"
  end

end
