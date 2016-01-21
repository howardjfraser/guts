require 'test_helper'

class SignupNewTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid sign up" do
    assert_no_difference 'User.count' do
      post companies_path, company: {name: "test", users_attributes: {"0" => {name: "test",
        email: "dave@test.com", password: "aaaaaaaa", password_confirmation: "bbbbbbbb"}}}
    end
    assert_template 'companies/new'
    assert_select 'div.errors'
  end

  test "valid signup" do
    assert_difference 'User.count', 1 do
      post companies_path, company: {name: "test", users_attributes: {"0" => {name: "test",
        email: "dave@test.com", password: "password", password_confirmation: "password"}}}
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
