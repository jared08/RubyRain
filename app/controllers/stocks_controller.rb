class StocksController < ApplicationController
  before_action :logged_in_user, only: [:new, :show, :index]
  before_action :admin_user, only: [:edit, :update, :destroy]
  before_action :correct_stock, only: [:edit, :update]
 
  def new
    @stock = Stock.new
  end

  def create
    final_params = stock_params
    final_params[:open_price] = stock_params[:current_price]

    final_params[:daily_prices] = [{time: Time.now, price: stock_params[:current_price]}]

    @stock = Stock.new(final_params)
    @stock.save

    @stock[:high] = stock_params[:current_price]
    @stock[:low] = stock_params[:current_price]
    @stock[:season_high] = stock_params[:current_price]
    @stock[:season_low] = stock_params[:current_price]
    @stock[:volume] = 0
    @stock[:earnings] = 0
    @stock[:price_to_change] = 0
    @stock.save
    if (stock_params[:sport] == "Golf") 
      create_golfer
    end
  end

  def show
    @stock = Stock.find(params[:id])
    @holding = Holding.find_by(stock_id: @stock.id, user_id: current_user.id)
    @watchlist = Watchlist.find_by(stock_id: @stock.id, user_id: current_user.id)
    @news = News.limit(4).where(stock_id: params[:id]).order("Updated DESC")
    @posts = Post.joins(:posts_stocks).where(:posts_stocks => {:stock_id => @stock.id}).limit(4).order("created_at DESC") 
   
    #TODO definitely needs to be changed
    @time = Time.now.utc.in_time_zone("Eastern Time (US & Canada)")

    if (@stock[:sport] == "Golf") 
      @golfer = Golfer.find_by(stock_id: @stock.id)
      show_golfer
    end
  end

  def index
    @stocks = Stock.all
  end

  def edit
    debugger
    @stock = Stock.find_by(id: params[:id])
    debugger
  end

  def update
    if @stock.update_attributes(edit_stock_params)
      flash[:success] = "Stock updated"
      redirect_to @stock
    else
      render 'edit'
    end
  end
  
  def destroy
    Stock.find(params[:id]).destroy
    flash[:success] = "Stock deleted"
    redirect_to stocks_url
  end

  def open_stock_modal
    debugger
    @stock = Stock.find_by(id: params[:id])
    respond_to do |format|
      format.js
    end
  end

  private
    def stock_params
      params.require(:stock).permit(:name, :symbol, :PlayerID, :current_price, :sport)
    end

    def edit_stock_params
      params.require(:stock).permit(:name, :symbol, :sport)
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
    def correct_stock
      @stock = Stock.find(params[:id])
    end

     # Confirms an admin user.
    def admin_user
      unless current_user.admin?
        flash[:danger] = "You don't have access to this.."
        redirect_to login_url 
      end
    end

    def create_golfer
      require 'net/http'

      url = 'https://api.fantasydata.net/golf/v2/json/Player/' + stock_params[:PlayerID]
      uri = URI(url)

      request = Net::HTTP::Get.new(uri.request_uri)
      request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'
      request.body = "{body}"

      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
      end

      @stock[:player_info] = JSON.parse(response.body)
      @stock.save

      golfer = Golfer.new({stock_id: @stock.id})

      golfer[:first] = 0
      golfer[:second] = 0
      golfer[:third] = 0
      golfer[:top_ten] = 0
      golfer[:top_twenty_five] = 0
      golfer[:made_cut] = 0
      golfer.save

      params = Hash.new

      tournaments = Tournament.all
      for tournament in tournaments
        if (tournament[:IsOver])
          id = tournament[:TournamentID].to_s
          puts(tournament[:Name])

          uri = URI('https://api.fantasydata.net/golf/v2/json/PlayerTournamentStatsByPlayer/' + id + '/' + @stock[:PlayerID].to_s)

          request = Net::HTTP::Get.new(uri.request_uri)
          request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'
          request.body = "{body}"

          response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
            http.request(request)
          end

          if (response.body != '') #returns blank if the player didn't play in the tournament
            info = JSON.parse(response.body)

            golfer_tournament = golfer.golfer_tournaments.create()
            golfer_tournament[:tournament_id] = tournament[:id]

            golfer_tournament[:Rank] = info["Rank"]
            golfer_tournament[:TotalScore] = info["TotalScore"]
 	    golfer_tournament[:Earnings] = info["Earnings"]

            golfer_tournament.save

            if (info["Rank"] != nil) #can switch to MadeCut when data isn't scrambled
              puts(info["Rank"])

              golfer[:made_cut] = golfer[:made_cut] + 1
              if (info["Rank"].to_i < 25)
                golfer[:top_twenty_five] = golfer[:top_twenty_five] + 1
              end
              if (info["Rank"].to_i < 10)
                golfer[:top_ten] = golfer[:top_ten] + 1
              end

              if (info["Rank"].to_i == 1)
                golfer[:first] = golfer[:first] + 1
              elsif (info["Rank"].to_i == 2)
                golfer[:second] = golfer[:second] + 1
              elsif (info["Rank"].to_i == 3)
                golfer[:third] = golfer[:third] + 1
              end
              golfer.save
            else
              puts('MISSED CUT')
              puts(info)
            end

          else
            puts('DID NOT PLAY')
          end
 
        end
      end
 
      golfer.save

      @stock[:earnings] = (golfer[:made_cut] * 2) + (golfer[:top_twenty_five] * 3) + (golfer[:top_ten] * 5) + (golfer[:third] * 4) +
          (golfer[:second] * 8) + (golfer[:first] * 15)

      url = 'https://api.fantasydata.net/golf/v2/json/NewsByPlayerID/' + @stock[:PlayerID].to_s
      uri = URI(url)

      request = Net::HTTP::Get.new(uri.request_uri)
      request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'
      request.body = "{body}"

      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
      end

      for news in JSON.parse(response.body)
        new_news = stock.news.new(news)
        new_news.save
      end

      if @stock.save
        flash[:success] = "You added a stock!"
        redirect_to stocks_url
      else
        render 'new'
      end
    end

    def show_golfer
      @events = Array.new

      current_index = Rails.application.config.current_tournament_index
      
      for i in (0..3).to_a.reverse
        tournament = Tournament.find_by(index: (current_index + i))
        temp = Hash.new
 
        temp[:id] = tournament[:id]
        temp[:name] = tournament[:Name]
        gt = GolferTournament.find_by(golfer_id: @golfer[:id], tournament_id: tournament[:id])
        if gt
          if tournament[:IsOver] == true
            if gt[:Rank] != nil
              temp[:rank] = gt[:Rank]
            else
              temp[:rank] = 'Missed Cut'
            end
          else
            temp[:rank] = 'TBD'
          end
        else
          if tournament[:IsOver] == true
            temp[:rank] = 'DNP'
          else
            temp[:rank] = 'Not Playing'
          end
        end

        temp[:date] = tournament[:StartDate].strftime("%-m/%-d")

        @events << temp
      end

    end

end
