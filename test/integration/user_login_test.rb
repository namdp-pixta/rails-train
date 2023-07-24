require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:micheal) # get user from fixture file
  end

  test 'login with invalid credentials' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with valid information followed by logout' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
    delete logout_path
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test 'login with remembering' do
    login_as(@user, remember_me: '1')
    assert_not cookies[:remember_token].blank?
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test 'login without remembering' do
    login_as(@user, remember_me: '1')
    login_as(@user, remember_me: '0')
    assert cookies[:remember_token].blank?
  end
end
