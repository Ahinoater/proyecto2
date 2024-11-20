class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]  # Asegúrate de que el usuario esté autenticado
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]  # Solo el propietario puede editar o eliminar

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)  # Asociamos el artículo con el usuario actual

    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      render :new
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def index
    @articles = Article.includes(:comments).all
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render "edit"
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "Article was successfully destroyed."
  end

  private
  def article_params
    params.require(:article).permit(:title, :text)  # Agrega aquí los parámetros permitidos
  end

  def set_article
    @article = Article.find(params[:id])
  end

  private
  def authorize_user!
    unless @article.user == current_user
      redirect_to articles_path, alert: "No tienes permiso para realizar esta acción."
    end
  end
end
