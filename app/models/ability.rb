class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Garante que haja um usuário (mesmo que seja um usuário convidado)

    if user.has_role?(:admin)
      # Administrador pode fazer qualquer coisa com qualquer artigo
      can :manage, Article
    elsif user.has_role?(:read_and_write)
      # Usuário com perfil de leitura e escrita pode ler e editar todos os artigos
      can :read, Article
      can :update, Article
    elsif user.has_role?(:read_only)
      # Usuário com perfil somente leitura pode apenas ler artigos
      can :read, Article
    else
      # Usuário não logado ou sem perfil específico, só pode ver artigos públicos
      can :read, Article
    end
  end
end
