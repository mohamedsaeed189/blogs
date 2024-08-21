class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_blog, only: [:index, :create]
  before_action :set_comment, only: [:destroy]
  before_action :authorize_comment, only: [:destroy]

  def index
    @comments = @blog.comments
    if @comments.size == 0
      render json: {"message":"No comments found"}
    else
      render json: @comments = @blog.comments
    end
  end

  def create
    @comment = @blog.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      render json: @comment
    else
      render json: {"message":"Error creating coment."}
    end
  end

  def destroy
    @comment.destroy
    render json: {"message":"Comment deleted successfully"}
  end

  private

  def set_blog
    @blog = Blog.find_by(id: params[:blog_id])
    unless @blog
      render json: {"message":"Blog not found"}
    end
  end

  def set_comment
    @comment = Comment.find_by(id: params[:id])
    unless @comment
      render json: {"message":"Comment not found"}
    end
  end

  def authorize_comment
    render json: {"message":"Not Authorized"} unless @comment.user == current_user
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end