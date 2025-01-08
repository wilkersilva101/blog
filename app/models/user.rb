class User < ApplicationRecord
 # rolify :role_cname => 'UserRole'
  rolify
  has_many :articles, dependent: :destroy

  # Validações
  validates :name, presence: true

  # Módulos do Devise
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  # Verifica se o usuário tem um papel específico
  def has_role?(role_name)
    roles.exists?(name: role_name)
  end

  # Métodos para verificar papéis específicos
  def admin?
    has_role?(:admin)
  end

  def read_and_write?
    has_role?(:read_and_write)
  end

  def read_only?
    has_role?(:read_only)
  end
end
