class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_article, only: %i[show edit update destroy]
  load_and_authorize_resource except: :index

  def index
    if user_signed_in?
      @q = Article.ransack(params[:q])
      @articles = @q.result.page(params[:page]).per(3)
    else
      @q = Article.ransack(params[:q])
      @articles = @q.result.page(params[:page]).per(3)
    end
  end

  def show
    # A autorização já é tratada pelo CanCanCan
  end

  def new
    # @article já é inicializado pelo CanCanCan
  end

  def edit
    # A autorização já é tratada pelo CanCanCan
  end

  def create
    @article = current_user.articles.build(article_params)
    authorize @article

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
    authorize! :destroy, @article
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
