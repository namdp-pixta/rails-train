# frozen_string_literal: true

require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:micheal)
    remember(@user)
  end

  test 'current user returns right user when session is nil but cookies is not' do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test 'current_user returns nil when remember_digest is wrong' do
    @user.update_attribute(:remember_digest, User.digest(User.new_token)) # change digest to some random token
    assert_nil current_user
  end
end
