require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    super
    remember(@brent)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @brent, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @brent.update_attribute(:remember_digest, User.digest("wrong token"))
    assert_nil current_user
  end

end
