class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  layout "admin" # use a custom layout

  def index
    @users = User.search(params[:search]).page(params[:page]).per(10).order(created_at: :desc)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "User created successfully."
    else
      render :new
    end
  end

  def edit; end

  def update
    cleaned_params = user_params.dup

    # Don't overwrite secret if left blank
    if cleaned_params[:password].blank?
      cleaned_params.delete(:password)
    end

    if @user.update(cleaned_params)
      redirect_to admin_users_path, notice: "User updated."
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :display_name, :username, :email, :password, :role) # update as per your model
  end
end
