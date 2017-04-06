class HomeController < ApplicationController
  before_action :logged_in_user, only: [:show] 

  def new
  end

  def show
    tournament = Tournament.find_by(index: Rails.application.config.current_tournament_index)

    @upcoming_tournament = Hash.new
    @upcoming_tournament[:id] = tournament[:id]
    @upcoming_tournament[:Name] = tournament[:Name]
    @upcoming_tournament[:StartDate] = tournament[:StartDate]
    @upcoming_tournament[:EndDate] = tournament[:EndDate]
    @upcoming_tournament[:Venue] = tournament[:Venue]
    @upcoming_tournament[:Location] = tournament[:Location]
    @upcoming_tournament[:Par] = tournament[:Par]
    @upcoming_tournament[:Yards] = tournament[:Yards]
    @upcoming_tournament[:Purse] = tournament[:Purse]

    golfers_array = Array.new

    golfers = GolferTournament.where(tournament_id: tournament[:id])
    for golfer in golfers
      temp = Hash.new
      temp[:golfer_stock] = Golfer.find_by(id: golfer[:golfer_id]).stock
      temp[:golfer_rank] = golfer[:Rank]
 
      golfers_array << temp
    end
      golfers_array.sort! { |x, y| x[:golfer_rank] <=> y[:golfer_rank] }
    
    @upcoming_tournament[:golfers] = golfers_array

    
   

    previous_tournament = Tournament.find_by(index: Rails.application.config.current_tournament_index + 1)
    
    @previous_tournament = Hash.new
    @previous_tournament[:Name] = previous_tournament[:Name]
    @previous_tournament[:StartDate] = previous_tournament[:StartDate]
    @previous_tournament[:EndDate] = previous_tournament[:EndDate]
    @previous_tournament[:Venue] = previous_tournament[:Venue]
    @previous_tournament[:Location] = previous_tournament[:Location]
    @previous_tournament[:Par] = previous_tournament[:Par]
    @previous_tournament[:Yards] = previous_tournament[:Yards]
    @previous_tournament[:Purse] = previous_tournament[:Purse]

    previous_golfers_array = Array.new

    previous_golfers = GolferTournament.where(tournament_id: previous_tournament[:id])
    for previous_golfer in previous_golfers
      temp = Hash.new
      temp[:golfer_stock] = Golfer.find_by(id: previous_golfer[:golfer_id]).stock
      temp[:golfer_rank] = previous_golfer[:Rank]

      previous_golfers_array << temp
    end

    @previous_tournament[:golfers] = previous_golfers_array
    

    @news = News.all.order('Updated DESC').where('Updated > ?', @previous_tournament[:StartDate]).limit(10)

    #@feeds = Array.new
    #@feeds << @previous_tournament
    #@feeds << @news

    #respond_to do |format|
    #  debugger
    #  format.html
    #  format.js { render 'feed_page' }
    #end

    @holdings = Holding.where(user_id: current_user[:id]).limit(5)
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
