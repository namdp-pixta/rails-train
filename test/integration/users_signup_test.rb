require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test 'sign up validation failed' do
    get signup_path
    assert_no_difference 'User.count' do 
      post users_path, params: {user: { name: '', email: 'user@invalid', password: 'foo', password_confirmation: 'bar'}}
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
  end

  test 'sign up ok' do
    get new_user_path # the same as sign up path
    assert_difference 'User.count', 1 do
      post users_path, params: {user: { name: 'dude', email: 'dude@gmail.com', password: '123456', password_confirmation: '123456'}}
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
