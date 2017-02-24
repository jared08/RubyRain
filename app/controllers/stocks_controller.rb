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

    initial_price = [stock_params[:current_price]]
    final_params[:daily_prices] = prices

    @stock = Stock.new(final_params)
    @stock.save


    @stock[:high] = stock_params[:current_price]
    @stock[:low] = stock_params[:current_price]
    @stock[:season_high] = stock_params[:current_price]
    @stock[:season_low] = stock_params[:current_price]
    @stock[:volume] = 0
    @stock[:earnings] = 0
    @stock.save

    require 'net/http'

    url = 'https://api.fantasydata.net/golf/v2/json/Player/' + stock_params[:player_id]
    uri = URI(url)

    request = Net::HTTP::Get.new(uri.request_uri)
    request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'
    request.body = "{body}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end
 
    @stock[:player_info] = JSON.parse(response.body) 
    @stock.save

    require 'net/http'


    @stock[:first] = 0
    @stock[:second] = 0
    @stock[:third] = 0
    @stock[:top_ten] = 0
    @stock[:top_twenty_five] = 0
    @stock[:made_cut] = 0
    @stock.save    

    params = Hash.new

    tournaments = Tournament.all
    for tournament in tournaments
      if (tournament[:tournament_info]["IsOver"])
        id = tournament[:tournament_info]["TournamentID"].to_s
        puts(tournament[:tournament_info]["Name"])

        uri = URI('https://api.fantasydata.net/golf/v2/json/PlayerTournamentStatsByPlayer/' + id + '/' + @stock[:player_info]["PlayerID"].to_s)

        request = Net::HTTP::Get.new(uri.request_uri)
        request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'
        request.body = "{body}"

        response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          http.request(request)
        end

        if (response.body != '') #returns blank if the player didn't play in the tournament
          info = JSON.parse(response.body)

          info.delete("Rounds") #maybe want later but don't see the need for storing info on every single hole

          params[:tournament] = tournament
          params[:player_tournament_info] = info

          player_tournament = PlayerTournament.new
          player_tournament = @stock.player_tournaments.create(params)
          player_tournament.save

          if (info["Rank"] != nil) #can switch to MadeCut when data isn't scrambled
            puts(info["Rank"])

            @stock[:made_cut] = @stock[:made_cut] + 1
            if (info["Rank"].to_i < 25)
              @stock[:top_twenty_five] = @stock[:top_twenty_five] + 1
            end
            if (info["Rank"].to_i < 10)
              @stock[:top_ten] = @stock[:top_ten] + 1
            end

            if (info["Rank"].to_i == 1)
              @stock[:first] = @stock[:first] + 1
            elsif (info["Rank"].to_i == 2)
              @stock[:second] = @stock[:second] + 1
            elsif (info["Rank"].to_i == 3)
              @stock[:third] = @stock[:third] + 1
            end
            @stock.save
          else
            puts('MISSED CUT')
            puts(info)
          end

        else
          puts('DID NOT PLAY')
        end

      end
    end

    @stock[:earnings] = (@stock[:made_cut] * 3) + (@stock[:top_twenty_five] * 7) + (@stock[:top_ten] * 5) + (@stock[:third] * 4) + 
        (@stock[:second] * 8) + (@stock[:first] * 15)

    if @stock.save
      flash[:success] = "You added a stock!"
      redirect_to stocks_url
    else
      render 'new'
    end
  end

  def show
    @stock = Stock.find(params[:id])

    #TODO definitely needs to be changed
    @time = Time.now.utc.in_time_zone("Eastern Time (US & Canada)")


    current_index = Rails.application.config.current_tournament_index
    @four_tournaments = Array.new

    @four_tournaments[0] = Tournament.find_by(index: (current_index + 3))
    @four_tournaments[1] = Tournament.find_by(index: (current_index + 2))
    @four_tournaments[2] = Tournament.find_by(index: (current_index + 1))
    @four_tournaments[3] = Tournament.find_by(index: (current_index))

    #TODO find out a way to not update player's news EVERY time
    #require 'net/http'

    #url = 'https://api.fantasydata.net/golf/v2/json/NewsByPlayerID/' + @stock[:player_id].to_s
    #uri = URI(url)

    #request = Net::HTTP::Get.new(uri.request_uri)
    #request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'
    #request.body = "{body}"

    #response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    #  http.request(request)
    #end
        
    #@stock[:player_news] = JSON.parse(response.body)
    #@stock.save
  end

  def events

  end

  def index
    @stocks = Stock.all
  end

  def edit
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

  private
    def stock_params
      params.require(:stock).permit(:name, :symbol, :player_id, :current_price, :league)
    end

    def edit_stock_params
      params.require(:stock).permit(:name, :symbol, :league)
    end
  
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
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


end
