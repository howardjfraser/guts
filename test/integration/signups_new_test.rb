require 'test_helper'

class SignupsNewTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "access" do
    check_access(:success) { get signup_path }
    check_redirect(users_path) { post signup_path, company: {name: "test", users_attributes: {"0" => {name: "test",
      email: "dave@test.com", password: "password"}}}}
  end

  test "invalid sign up" do
    assert_no_difference 'User.count' do
      post signup_path, company: {name: "test", users_attributes: {"0" => {name: "test",
        email: "dave@test.com", password: " "}}}
    end
    assert_template 'signups/new'
    assert_select 'div.errors'
  end

  test "valid signup" do
    assert_difference 'User.count', 1 do
      post signup_path, company: {name: "test", users_attributes: {"0" => {name: "test",
        email: "dave@test.com", password: "password"}}}
    end

    company = assigns(:company)
    assert company.users.count == 1

    check_owner company.users.first
  end

  private

  def check_owner owner
    assert owner.admin?
    assert owner.activated?
    assert logged_in?
  end

end
