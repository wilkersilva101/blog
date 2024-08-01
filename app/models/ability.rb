class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Garante que haja um usuário (mesmo que seja um usuário convidado)

    # Alias para agrupar ações comuns
    alias_action :read, :update, to: :read_and_update

    # Permissões para artigos
    can :read, Article # Todos podem ler artigos

    if user.has_role? :admin
      can :manage, Article # Admin pode gerenciar todos os artigos
      can :manage, Role # Admin pode gerenciar todos os papéis
      can :manage, User # Admin pode gerenciar todos os usuários
    elsif user.has_role? :read_and_write
      can :read_and_update, Article # Pode ler e editar todos os artigos
    elsif user.has_role? :read_only
      can :read, Article # Pode ler todos os artigos
    end

    # Permissão para criar artigos
    can :create, Article if user.persisted?

    # Bloquear acesso ao 'roles#index' para todos exceto admin
    cannot :index, Role unless user.has_role?(:admin)
  end
end
