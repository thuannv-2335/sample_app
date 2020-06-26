class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: [:edit, :update]

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_reset_send"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_not_found"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      flash[:danger] = t ".update_password_reset"
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t ".update_password_success"
      redirect_to @user
    else
      flash[:danger] = t ".update_password_fail"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t".not_found_user"
    redirect_to root_url
  end

  def valid_user
    return if @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t".password_reset_exprired"
    redirect_to new_password_reset_url
  end
end
