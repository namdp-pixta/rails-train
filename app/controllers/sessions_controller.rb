class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password]) # this is like ? operator in typescript
      reset_session
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      login(@user)
      redirect_to @user
    else
      flash.now[:danger] = 'Invalid email or password'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url, status: :see_other
  end
end
