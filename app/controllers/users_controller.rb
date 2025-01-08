class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    begin
      User.transaction do
        if @user.save
          if params[:user][:role].present?
            @user.add_role(params[:user][:role])
          else
            @user.add_role(:user)
          end

          flash[:notice] = "User was successfully created."
          redirect_to @user and return
        end
      end
    rescue => e
      Rails.logger.error("Erro ao criar usuário: #{e.message}")
    end

    flash.now[:alert] = "There was an error creating the user: #{@user.errors.full_messages.join(', ')}"
    render :new, status: :unprocessable_entity
  end

  def update
    if @user.update(user_params)
      # Atualiza o papel do usuário se fornecido
      if params[:user][:role].present? && !@user.has_role?(params[:user][:role])
        @user.roles.destroy_all # Remove papéis existentes
        @user.add_role(params[:user][:role])
      end

      flash[:notice] = "User was successfully updated."
      redirect_to @user
    else
      flash.now[:alert] = "There was an error updating the user: #{@user.errors.full_messages.join(', ')}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @user.destroy
      flash[:notice] = "User was successfully destroyed."
    rescue => e
      flash[:alert] = "Error deleting user: #{e.message}"
      Rails.logger.error("Error deleting user: #{e.message}")
    end
    redirect_to users_url
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "User not found."
    redirect_to users_path
  end

  def user_params
    # Permitir atualização de senha apenas se fornecida
    if params[:user][:password].present? || action_name == 'create'
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    else
      params.require(:user).permit(:name, :email, :role)
    end
  end
end
