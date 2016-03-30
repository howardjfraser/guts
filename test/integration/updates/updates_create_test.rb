require 'test_helper'

class UpdatesCreateTest < ActionDispatch::IntegrationTest
  test 'invalid new update' do
    log_in_as @brent
    assert_no_difference 'Update.count' do
      post updates_path, update: { message: '' }
    end
    assert_template 'updates/new'
    assert_errors_present
  end

  test 'valid new update' do
    log_in_as @tim
    assert_difference 'Update.count', 1 do
      post_via_redirect updates_path update: { message: 'hello' }
    end
    assert_template 'updates/index'
    assert_not flash.empty?
  end

  test 'ajax invalid update' do
    log_in_as @gareth
    assert_no_difference 'Update.count' do
      xhr :post, updates_path(update: { message: '' })
    end
    assert_template 'updates/fail'
    assert_not flash.empty? # js redirects
  end

  test 'ajax valid update' do
    log_in_as @brent
    assert_difference 'Update.count', 1 do
      xhr :post, updates_path(update: { message: 'hello' })
    end
    assert_template 'updates/create'
  end
end
