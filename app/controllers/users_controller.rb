class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    unless @user
      flash[:alert] = "User not found."
      redirect_to users_path
    end
  end

  def new
    @user = User.new
  end

  def edit
    unless @user
      flash[:alert] = "User not found."
      redirect_to users_path
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    unless @user
      flash[:alert] = "User not found."
      redirect_to users_path
    else
      if @user.update(user_params)
        redirect_to @user, notice: 'User was successfully updated.'
      else
        render :edit
      end
    end
  end

  def destroy
    unless @user
      flash[:alert] = "User not found."
      redirect_to users_path
    else
      @user.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.'
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    unless @user
      flash[:alert] = "User not found."
      redirect_to users_path
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end
end
