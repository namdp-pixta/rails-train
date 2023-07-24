# frozen_string_literal: true

module SessionsHelper
  def login(user)
    session[:user_id] = user.id
    # guards against replay attack
    session[:session_token] = user.session_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token])
        login(user)
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def logout
    forget(current_user)
    reset_session
    @current_user = nil
  end

  def remember(user)
    user.remember # calls the model method
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget # calls the model method
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
