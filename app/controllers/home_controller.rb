class HomeController < ApplicationController
  before_action :logged_in_user, only: [:show] 

  def new
  end

  def show

    current_tournament_id = Tournament.find_by(index: Rails.application.config.current_tournament_index)[:id]

    @initial_tournaments = Tournament.where('id >= ?', current_tournament_id).order('id ASC').limit(5)

    current_tournament_id = current_tournament_id + 5
    @tournaments = Tournament.where('id >= ?', current_tournament_id).order('id ASC').paginate(page: params[:page])
   
    respond_to do |format|
      format.html
      format.js { render 'home/home_page' }
    end  

 #   @news = News.all.order('Updated DESC').where('Updated > ?', @previous_tournament[:StartDate]).limit(10)
    
    @holdings = Holding.where(user_id: current_user[:id]).order('quantity DESC').limit(5)
    @watchlist = { }
    @top_users = User.order('account_value DESC').limit(5)
    @trending_users = User.order('((account_value - start_value) / (start_value)) DESC').limit(5)
    @following = { }
    @trendings = Stock.order('num_trades DESC').limit(5)
    @gainers = Stock.order('daily_change DESC').limit(5)
    @losers = Stock.order('daily_change').limit(5)

  end

  def index
  end


  private
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
