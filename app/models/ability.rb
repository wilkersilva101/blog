class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Garante que haja um usuário (mesmo que seja um usuário convidado)

    if user.has_role?(:admin)
      can :manage, :all # Administradores podem gerenciar todos os recursos
    elsif user.has_role?(:read_only)
      can :read, Article # Usuários com papel `read_only` podem apenas ler todos os artigos
    elsif user.has_role?(:read_and_write)
      can :read, Article # Usuários com papel `read_and_write` podem ler todos os artigos
      can :update, Article, user_id: user.id # Podem atualizar apenas seus próprios artigos
    else
      can :read, Article, user_id: user.id # Usuários não autenticados ou com outros papéis podem apenas ler seus próprios artigos
    end
  end
end
