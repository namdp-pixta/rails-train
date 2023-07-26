require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:micheal)
    @non_admin = users(:archer)
  end

  test 'index including pagination' do
    login_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      # assert_select 'a[href=?]', user_path(user), text: 'delete' unless user == @admin
    end
  end
  test 'index as non-admin' do
    login_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
