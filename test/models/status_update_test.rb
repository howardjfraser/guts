require 'test_helper'

class StatusUpdateTest < ActiveSupport::TestCase
  def setup
    @company = Company.new(name: 'TestCo')
    @user = @company.users.build(name: 'Example', email: 'user@example.com', password: 'foobar', role: 'admin')
    @update = @user.status_updates.build(message: 'message')
  end

  test 'should be valid' do
    assert @update.valid?
  end

  test 'message is required' do
    @update.message = nil
    assert_not @update.valid?
    @update.message = ''
    refute @update.valid?
    @update.message = ' '
    refute @update.valid?
  end

  test 'message max length is 256' do
    @update.message = 'a' * 256
    assert @update.valid?
    @update.message = 'a' * 257
    refute @update.valid?
  end

  test 'user is required' do
    @update.user = nil
    refute @update.valid?
  end

end
