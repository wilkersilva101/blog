class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_article, only: %i[show edit update destroy]
  before_action :check_user_profile, only: %i[index]
  load_and_authorize_resource except: :index


  def index
  search_params = params[:q] || {}
  @q = Article.ransack(
    combinator: 'or',
    title_cont: search_params[:text_cont],
    text_cont: search_params[:text_cont]
  )
  @articles = @q.result.page(params[:page]).per(3)
end


  def show
    # A autorização é tratada pelo CanCanCan e pelo ApplicationController
  end

  def new
    @article = Article.new
    authorize! :create, @article # Verifica autorização para criar o artigo
  end

  def create
    @article = current_user.articles.build(article_params)
    authorize! :create, @article # Verifica autorização para criar o artigo

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Artigo criado com sucesso." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    # Remover ou ajustar se a permissão para editar não deve estar disponível
  end

  def update
    # Remover ou ajustar se a permissão para atualizar não deve estar disponível
    authorize! :update, @article # Verifica autorização para atualizar o artigo
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Artigo atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @article # Verifica autorização para excluir o artigo
    @article.destroy!
    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Artigo excluído com sucesso." }
      format.json { head :no_content }
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :text)
  end

  def check_user_profile
    # Verifica se o usuário está logado antes de verificar o perfil
    if user_signed_in? && !current_user.roles.exists?
      flash[:alert] = "Você precisa solicitar um perfil ao administrador para ver os artigos."
      redirect_to root_path unless request.path == root_path
    end
  end
end
