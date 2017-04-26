class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to Ruby Rain!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @accounts_user = User.find(params[:id])
    @current_user = current_user
    @holdings = @accounts_user.holdings.all
    
    @posts = Post.where(user_id: current_user.id).order('created_at DESC')
  end

  def index
    @users = User.all
    @following = current_user.following
  end

  def follow_user
    user_to_follow = User.find_by(id: params[:user_to_follow].to_i)
    current_user.relationships.create(followed_id: params[:user_to_follow].to_i)
    redirect_to users_path
  end

  def unfollow_user
    r = Relationship.find_by(follower_id: current_user.id, followed_id: params[:user_to_unfollow].to_i)
    r.delete
    redirect_to users_path
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
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
