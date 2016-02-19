require 'test_helper'

class SignupsNewCreateTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'access' do
    check_access(:success) { get new_signup_path }

    check_redirect(users_path) do
      post signups_path, company: {name: 'test', users_attributes: {'0' => {name: 'test',
                         email: 'dave@test.com', password: 'password'}}}
    end
  end

  test 'invalid sign up' do
    assert_no_difference 'User.count' do
      post signups_path, company: {name: 'test', users_attributes: {'0' => {name: 'test',
        email: 'dave.test.com', password: 'aaa'}}}
    end
    assert_template 'signups/new'
    assert_select 'div.errors'
  end

  test 'invalid sign up - empty password' do
    assert_no_difference 'User.count' do
      post signups_path, company: {name: 'test', users_attributes: {'0' => {name: 'test',
        email: 'dave@test.com', password: ''}}}
    end
    assert_template 'signups/new'
    assert_select 'div.errors'
  end

  test 'valid signup' do
    assert_difference 'User.count', 1 do
      post signups_path, company: {name: 'test', users_attributes: {'0' => {name: 'test',
        email: 'dave@test.com', password: 'password'}}}
    end

    company = assigns(:company)
    assert company.users.count == 1
    owner = company.users.first
    assert owner.admin?
    assert owner.activated?
    assert is_logged_in_as? owner
  end
end
