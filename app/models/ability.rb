class Ability
  include CanCan::Ability

  def initialize(user)
    Rails.logger.debug "Inicializando Ability com o usuário: #{user.inspect}"
    user ||= User.new # Garante que haja um usuário (mesmo que seja um usuário convidado)

    # Permissões para artigos
    can :read, Article # Todos podem ler artigos

    if user.has_role? :admin
      can :manage, Article # Admin pode gerenciar todos os artigos
    elsif user.has_role? :read_and_write
      can :read, Article # Pode ler todos os artigos
      can :update, Article # Pode editar todos os artigos
    elsif user.has_role? :read_only
      can :read, Article # Pode ler todos os artigos
    end
  end
end
