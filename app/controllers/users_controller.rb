class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :find_user, except: %i(new create index)

  def new
    @user = User.new
  end

  def index
    @users = User.page(params[:page]).per Settings.controllers.per_page
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".user_dele_fail"
    end
    redirect_to users_url
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit :name, :email, :password, :password_confirmation
    end

    def logged_in_user
      return if logged_in?
      store_location
      flash[:danger] = t ".pls_login"
      redirect_to login_url
    end

    def correct_user
      @user = User.find_by id: params[:id]
      redirect_to root_url unless current_user? @user
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end

    def find_user
      @user = User.find_by id: params[:id]
      return if @user
      flash[:danger] = t ".not_found_user"
      redirect_to users_url
    end
end
