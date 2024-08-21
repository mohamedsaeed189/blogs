class BlogsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_blog, only: [:show, :destroy]
  before_action :authorize_blog, only: [:destroy]

  def index
    render json: Blog.all
  end

  def show
    # @blog is set by the before_action :set_blog
    render json: @blog
  end

  def create
    @blog = current_user.blogs.build(blog_params)
    if @blog.save
      redirect_to @blog, notice: 'Blog was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @blog.destroy
    render json: {"message":"Blog deleted successfully"}
  end

  private

  def set_blog
    @blog = Blog.find_by(id: params[:id])
    if @blog.nil?
      render json: {"message":"Blog not found"}
    end
  end

  def authorize_blog
    render json: {"message":"Not Authorized"} unless @blog.user == current_user
  end
  
  def blog_params
    params.require(:blog).permit(:title, :content)
  end
end
