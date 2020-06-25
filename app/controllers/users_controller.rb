class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :find_user, except: [:new, :create, :index]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.page(params[:page]).per Settings.user.per_page
  end

  def show
    @microposts = @user.microposts.page(params[:page]).per Settings.user.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t".check_active_link"
      redirect_to root_url
    else
      flash[:danger] = t".sign_up_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t".updated_profile_succsess"
      redirect_to @user
    else
      flash[:danger] = t".updated_profile_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
      redirect_to users_path
    else
      flash[:danger] = t ".user_delete_fail"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t".not_found_user"
    redirect_to root_path
  end

  def correct_user
    return if current_user? @user
    flash[:danger] = t".correct_user"
    redirect_to root_path
  end
end
