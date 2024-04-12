class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Garante que haja um usuário (mesmo que seja um usuário convidado)

    # Permissões para artigos
    can :read, Article # Todos podem ler artigos
    can :create, Article # Todos podem criar artigos

    # Permissões específicas para editar e excluir artigos
    can [:update, :destroy], Article do |article|
      article.user == user # Apenas o usuário que criou o artigo pode editá-lo ou excluí-lo
    end
  end
end
