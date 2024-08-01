class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

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
      flash[:notice] = "User was successfully created."
      redirect_to @user
    else
      flash.now[:alert] = "There was an error creating the user."
      render :new
    end
  end

  def update
    unless @user
      flash[:alert] = "User not found."
      redirect_to users_path
    else
      if @user.update(user_params)
        flash[:notice] = "User was successfully updated."
        redirect_to @user
      else
        flash.now[:alert] = "There was an error updating the user."
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
      flash[:notice] = "User was successfully destroyed."
      redirect_to users_url
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
