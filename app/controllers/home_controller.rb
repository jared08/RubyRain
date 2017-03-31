class HomeController < ApplicationController
  before_action :logged_in_user, only: [:show] 

  def new
  end

  def show
    tournament = Tournament.find_by(index: Rails.application.config.current_tournament_index)

    @upcoming_tournament = Hash.new
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
    
    @upcoming_tournament[:golfers] = golfers_array



    last_tournament = Tournament.find_by(index: Rails.application.config.current_tournament_index + 1)
    
    @last_tournament = Hash.new
    @last_tournament[:Name] = last_tournament[:Name]
    @last_tournament[:StartDate] = last_tournament[:StartDate]
    @last_tournament[:EndDate] = last_tournament[:EndDate]
    @last_tournament[:Venue] = last_tournament[:Venue]
    @last_tournament[:Location] = last_tournament[:Location]
    @last_tournament[:Par] = last_tournament[:Par]
    @last_tournament[:Yards] = last_tournament[:Yards]
    @last_tournament[:Purse] = last_tournament[:Purse]

    last_golfers_array = Array.new

    last_golfers = GolferTournament.where(tournament_id: last_tournament[:id])
    for last_golfer in last_golfers
      temp = Hash.new
      temp[:golfer_stock] = Golfer.find_by(id: last_golfer[:golfer_id]).stock
      temp[:golfer_rank] = last_golfer[:Rank]

      last_golfers_array << temp
    end

    @last_tournament[:golfers] = last_golfers_array
    
    @news = News.all.order('Updated DESC').where('Updated > ?', @last_tournament[:EndDate]).limit(10)

    @last_last_tournament = Tournament.find_by(index: Rails.application.config.current_tournament_index + 2)
    @last_news = News.all.order('Updated DESC').where('Updated > ?', @last_last_tournament[:EndDate]).limit(10)
 

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
