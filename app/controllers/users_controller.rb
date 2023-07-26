# frozen_string_literal: true

class UsersController < ApplicationController
  # these are filters
  before_action :logged_in_user, only: %i[index edit update destroy]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.where(activated: true).find(params[:id])
    redirect_to root_url and return if @user.nil?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check email for account activation'
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url, status: :see_other
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # guard against not logged in user
  def logged_in_user
    return if logged_in?

    store_location # from session helper
    flash[:danger] = 'Please login'
    redirect_to login_url, status: :see_other
  end

  # guard agains wrong user
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless current_user?(@user) # current user from session helper
  end

  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
    flash[:danger] = 'You are no admin'
  end
end
