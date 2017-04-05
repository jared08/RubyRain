class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :show, :index]
  before_action :admin_user, only: [:destroy]
  before_action :correct_user, only: [:edit, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
        flash[:success] = "You added a post!"
        redirect_to posts_url
      else
        render 'new'
      end
  end

  def show
    @post = Post.find(params[:id])
  end
  
  def index
    @posts = Post.all
  end

  def edit
  end

  def update
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
      params.require(:post).permit(:title, :content, :tags)
    end

    def edit_post_params
      params.require(:post).permit(:title, :content, :tags)
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


    # Confirms the correct user.
    def correct_user
      unless current_user.id == @post.id
        flash[:danger] = "You don't have access to this.."
        redirect_to login_url
      end
    end

     # Confirms an admin user.
    def admin_user
      unless current_user.admin?
        flash[:danger] = "You don't have access to this.."
        redirect_to login_url
      end
    end


end
