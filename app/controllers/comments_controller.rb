class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article
  before_action :set_comment, only: [:destroy]
  before_action :authorize_commenter!, only: [:destroy]  # Ajustado para solo destruir

  # Crear un nuevo comentario
  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      redirect_to @article, notice: 'Comentario agregado exitosamente.'
    else
      redirect_to @article, alert: 'No se pudo agregar el comentario.'
    end
  end

  # Eliminar un comentario
  def destroy
    if @comment.user == current_user
      @comment.destroy
      redirect_to @article, notice: 'Comentario eliminado exitosamente.'
    else
      redirect_to @article, alert: 'No puedes eliminar este comentario.'
    end
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = @article.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  # Autoriza si el usuario es el dueño del comentario
  def authorize_commenter!
    unless @comment.user == current_user
      redirect_to @article, alert: 'No tienes permiso para eliminar este comentario.'
    end
  end
end
