class TournamentsController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def show
    tournament_id = params[:id]

    @tournament = Tournament.find_by(id: tournament_id)
    @golfers = @tournament.golfer_tournaments.all.order("Rank IS NULL, Rank ASC")
  end

  def index

    stock_id = params[:stock_id]
    @golfer_id = Golfer.find_by(stock_id: stock_id).id

    completed_tournaments = Tournament.where(:IsOver => true)

    @completed = []

    completed_tournaments.reverse.each do |tournament|
      temp = Hash.new
      temp[:id] = tournament[:id]
      temp[:name] = tournament[:Name]
      temp[:date] = tournament[:StartDate]

      gt = GolferTournament.find_by(golfer_id: @golfer_id, tournament_id: tournament[:id])
      if gt
        if gt[:Rank] == nil
          temp[:rank] = 'Missed Cut'
        else
          temp[:rank] = gt[:Rank]
        end
      else
        temp[:rank] = 'DNP'
      end
      @completed << temp
    end

    remaining_tournaments = Tournament.where(:IsOver => false)

    @remaining = []
    remaining_tournaments.reverse.each do |tournament|
      temp = Hash.new
      temp[:id] = tournament[:id]
      temp[:name] = tournament[:Name]
      temp[:date] = tournament[:StartDate]

      if tournament[:IsInProgress] == true
        gt = GolferTournament.find_by(golfer_id: @golfer_id, tournament_id: tournament[:id])
        if gt
          temp[:status] = 'Playing'
        else
          temp[:status] = 'Not Playing'
        end
      else
        temp[:status] = 'TBD'
      end      

      @remaining << temp
    end
    

    

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
