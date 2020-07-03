class UsersController < ApplicationController
  before_action :load_user, except: [:new, :create, :index]
  before_action :logged_in_user, except: [:create, :new]
  before_action :correct_user, only: [:edit, :update, :show]
  before_action :admin_user, only: :destroy
  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "new"
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = "User deleted"
    else
      flash[:danger] = "Can't delete user"
    end
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end
  

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confimation)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in!!"
      redirect_to login_url
    end
  end

  def correct_user
    redirect_to(root_url) unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user
    flash[:warning] = "User not fond"
    redirect_to root_path
  end
end
