class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_article, only: %i[show edit update destroy]
  load_and_authorize_resource except: :index


  def index
    Rails.logger.debug "Parâmetros de busca: #{params[:q].inspect}"
    Rails.logger.debug "Usuário logado: #{user_signed_in?}"

    if user_signed_in?
      @q = Article.ransack(params[:q])
      @articles = @q.result.page(params[:page]).per(3)
      Rails.logger.debug "Artigos carregados: #{@articles.inspect}"
    else
      redirect_to new_user_session_path, alert: "Você precisa estar logado para ver os artigos."
    end
  end




  def show
    # A autorização é tratada pelo CanCanCan e pelo ApplicationController
  end

  def new
    @article = Article.new
    # @article já é inicializado pelo CanCanCan
  end

  def edit
    # Remover ou ajustar se a permissão para editar não deve estar disponível
  end

  def create
    @article = current_user.articles.build(article_params)
    authorize! :create, @article # Alterado para authorize!

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

  def update
    # Remover ou ajustar se a permissão para atualizar não deve estar disponível
    authorize! :update, @article # Alterado para authorize!
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
    authorize! :destroy, @article # Alterado para authorize!
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
end
