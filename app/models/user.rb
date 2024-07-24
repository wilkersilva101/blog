class User < ApplicationRecord
  rolify
  has_many :articles, dependent: :destroy
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable, and :omniauthable
  devise :confirmable,
         :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  def admin?
    roles.exists?(name: 'admin')
  end

  def read_and_write?
    roles.exists?(name: 'read_and_write')
  end

  def read_only?
    roles.exists?(name: 'read_only')
  end

  # Verifica se o usuário tem algum papel específico
  def has_role?(role_name)
    roles.exists?(name: role_name)
  end
end
