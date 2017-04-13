class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :show, :index]

  def new
    @post = Post.new
    @stocks = Stock.all.order('name')
  end

  def create
    final_params = Hash.new
    final_params = post_params

    stocks = Hash.new
    stocks = Stock.where(id: post_params[:stocks])
    final_params.delete(:stocks)
    
    @post = current_user.posts.new(final_params)
    @post.stocks = stocks

    if @post.save
        flash[:success] = "You added a post!"
        redirect_to posts_url
      else
        render 'new'
      end
  end

  def show
    @post = Post.find(params[:id])
    @current_user = current_user
  end
  
  def index
    #@posts = Post.all
    @posts = Post.order('created_at DESC').paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js { render 'posts/post_page' }
    end

    @current_user = current_user
  end

  def edit
    @post = Post.find_by(id: params[:id])
    @stocks = Stock.all.order('name')
  end

  def update
    @post = Post.find_by(id: params[:id])
    if @post.update_attributes(edit_post_params)
      flash[:success] = "Post updated"
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    flash[:success] = "Post deleted"
    redirect_to posts_url
  end

  private
    def post_params
      params.require(:post).permit(:title, :content, :stocks, :custom_tags)
    end

    def edit_post_params
      params.require(:post).permit(:title, :content, :stocks, :custom_tags)
    end

    # Confirms a logged-in user.
    def logged_in_user
      if logged_in?
        current_user.UpdateAccountValue(current_user)
      else
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

end
