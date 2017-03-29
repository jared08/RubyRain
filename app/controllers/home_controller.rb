class HomeController < ApplicationController
  before_action :logged_in_user, only: [:show] 

  def new
  end

  def show
    @news = News.all.order('Updated DESC').limit(10)

    @holdings = Holding.where(user_id: current_user[:id]).limit(5)
    @watchlist = {}
    @trendings = Stock.order('num_trades DESC').limit(5)
    @gainers = Stock.order('daily_change DESC').limit(5)
    @losers = Stock.order('daily_change').limit(5)

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
