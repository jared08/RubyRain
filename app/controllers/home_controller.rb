class HomeController < ApplicationController
  before_action :logged_in_user, only: [:show] 

  def new
  end

  def show
    @news = News.limit(5).order('Updated DESC')

    @holdings = Holding.limit(5).where(user_id: current_user[:id])
    @watchlist = {}
    @trendings = Stock.limit(5).order('num_trades DESC')
    @gainers = Stock.limit(5).order('daily_change DESC') 
    @losers = Stock.limit(5).order('daily_change')

  end

  def index
  end


  private
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

end
