require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @company = Company.new(name: 'TestCo')
    @user = @company.users.build(name: 'Example', email: 'user@example.com', password: 'foobar', role: 'admin')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = nil
    refute @user.valid?
  end

  test 'email should be present' do
    @user.email = nil
    refute @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'valid addresses should be accepted' do
    valid_addresses = %w(user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn)

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'invalid addresses should be rejected' do
    invalid_addresses =
      %w(user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com)

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    @user.save
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    assert_not duplicate_user.valid?
  end

  test 'email addresses should be lower case' do
    mixed_case_email = 'HOWARD@bindle.io'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'password should be non-blank' do
    @user.password = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'user should have company' do
    @user.company = nil
    refute @user.valid?
  end

  test 'user should have valid role' do
    @user.role = 'invalid'
    refute @user.valid?
  end

  test 'to_s' do
    assert @user.to_s == 'User: Example / user@example.com'
  end
end
