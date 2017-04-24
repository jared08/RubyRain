class HomeController < ApplicationController
  before_action :logged_in_user, only: [:show] 

  def new
  end

  def show

    #current_tournament_id = Tournament.find_by(index: Rails.application.config.current_tournament_index)[:id]
   
    @first_tournament = Tournament.find_by(index: Rails.application.config.current_tournament_index)
    current_tournament_id = @first_tournament[:id]
    
    @tournaments = Tournament.where('id >= ?', (current_tournament_id + 1)).order('id ASC').paginate(page: params[:page])

    prior_tournament = Tournament.find_by(index: (@tournaments[0][:index] - 1))
    @news = News.where('Updated <= ? AND Updated > ?', prior_tournament[:EndDate], @tournaments[0][:EndDate]).order('Updated DESC')

    respond_to do |format|
      format.html
      format.js { render 'home/home_page' }
    end  


    @holdings = Holding.where(user_id: current_user[:id]).order('quantity DESC').limit(5)
    @watchlist = { }
    @top_users = User.order('account_value DESC').limit(5)
    @trending_users = User.order('((account_value - start_value) / (start_value)) DESC').limit(5)
    @following = current_user.following.limit(5)
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
