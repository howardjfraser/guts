require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:brent)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'

    # request reset - invalid email
    post password_resets_path, password_reset: { email: "" }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # request reset - valid email
    post password_resets_path, password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    # user is available in assigns due to post above
    user = assigns(:user)

    # get reset form - wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url

    # get reset form - right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url

    # get reset form - right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # get reset form - inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)

    # submit pw change - empty password
    patch password_reset_path(user.reset_token), email: user.email,
      user: { password: "" }
    assert_select 'div.errors'

    # submit pw change - password to short
    patch password_reset_path(user.reset_token), email: user.email,
      user: { password: "aaa" }
    assert_select 'div.errors'

    # submit pw change - valid password
    patch password_reset_path(user.reset_token), email: user.email,
      user: { password: "foobaz" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, password_reset: { email: @user.email }

    user = assigns(:user)
    user.update_attribute(:reset_sent_at, 3.hours.ago)

    patch password_reset_path(user.reset_token), email: user.email,
      user: { password: "foobar" }
    assert_response :redirect
    follow_redirect!
    assert_not flash.empty?
    assert_match /expired/i, response.body
  end

end
