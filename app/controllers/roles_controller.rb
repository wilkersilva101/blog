class RolesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[edit update]

  def index
    @users = User.all
  end

  def edit
    @roles = Role.all
  end

  def update
    if @user.update(user_params)
      redirect_to roles_path, notice: "Permissões atualizadas com sucesso."
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(role_ids: [])
  end
end
