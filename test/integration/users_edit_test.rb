require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:micheal)
  end

  test 'should redirect user edit when not logged in' do
    get edit_user_path(@user) # get the html page to edit user
    assert_not flash.empty? # notify user to login before
    assert_redirected_to login_url
  end

  test 'should redirect user update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'unsuccessful edit' do
    login_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user),
          params: { user: { name: '', email: 'foo@invalid', password: 'foo', password_confirmation: 'bar' } }
    assert_template 'users/edit'
  end

  test 'successful edit' do
    login_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'FooBar'
    email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name:, email:, password: '', password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    login_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name:,
                                              email:,
                                              password: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
