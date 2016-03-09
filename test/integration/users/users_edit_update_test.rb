require 'test_helper'

class UsersEditUpdateTest < ActionDispatch::IntegrationTest
  test 'access' do
    check_redirect(login_url) { get edit_user_path @brent }
    check_redirect(login_url) { patch user_path, id: @brent, user: { name: 'new' } }

    check_access(:forbidden, @gareth) { get edit_user_path @gareth }
    check_access(:forbidden, @gareth) { patch user_path @brent, user: { name: 'new' } }

    check_access(:success, @brent) { get edit_user_path @brent }
    check_redirect(user_path(@brent)) { patch user_path @brent, user: { name: 'new', email: @brent.email } }
  end

  test 'can’t edit users from a different company' do
    check_access(:forbidden, @brent) { get edit_user_path @michael }
  end

  test 'can’t edit root user' do
    check_access(:forbidden, @howard) { get edit_user_path @howard }
  end

  test 'can’t update users from a different company' do
    check_access(:forbidden, @brent) { patch user_path @michael, user: { email: 'new@email.com' } }
  end

  test 'can’t update root users' do
    check_access(:forbidden, @howard) { patch user_path @howard, user: { email: 'new@email.com' } }
  end

  test 'unsuccessful edit' do
    log_in_as(@brent)
    get edit_user_path(@brent)
    assert_template 'users/edit'
    patch user_path(@brent), user: { name: '', email: 'foo.invalid' }
    check_fail
  end

  test 'successful edit' do
    log_in_as(@brent)
    patch user_path(@brent), user: { name: 'dave', email: 'dave@dave.com' }
    check_success @brent, true
  end

  test 'add admin rights' do
    log_in_as(@brent)
    make_gareth_admin
  end

  test 'prevent removal of last admin' do
    log_in_as(@brent)
    patch user_path(@brent), user: { role: 'user' }
    check_fail
    assert @brent.reload.admin?
  end

  test 'allow removal of admin when multiple admins' do
    log_in_as(@brent)
    make_gareth_admin # create multiple admins
    patch user_path(@brent), user: { role: 'user' }
    check_success @brent, false
  end

  test 'prevent root user being created' do
    log_in_as(@brent)
    patch user_path(@gareth), user: { role: 'root' }
    check_fail
    assert @brent.reload.admin?
  end

  private

  def make_gareth_admin
    assert_not @gareth.admin?
    patch user_path(@gareth), user: { role: 'admin' }
    check_success @gareth, true
  end

  def check_success(user, is_admin)
    follow_redirect!
    assert_template 'users/show'
    assert flash.any?
    assert user.reload.admin? == is_admin
  end

  def check_fail
    errors_present
    assert_template 'users/edit'
  end
end
