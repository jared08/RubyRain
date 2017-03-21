class TournamentsController < ApplicationController
  before_action :logged_in_user, only: [:index]
  def index

    stock_id = params[:stock_id]
    @golfer_id = Golfer.find_by(stock_id: stock_id).id

    tournaments = Tournament.all
    completed_tournaments = tournaments.find_all {|x| x[:tournament_info]["IsOver"] == true}

    @completed = []

    completed_tournaments.reverse.each do |tournament|
      temp = Hash.new
      temp[:name] = tournament[:tournament_info]["Name"]
      temp[:date] = tournament[:tournament_info]["StartDate"]

      gt = GolferTournament.find_by(golfer_id: @golfer_id, tournament_id: tournament[:id])
      if gt
        if gt[:golfer_tournament_info]["Rank"] == nil
          temp[:rank] = 'Missed Cut'
        else
          temp[:rank] = gt[:golfer_tournament_info]["Rank"]
        end
      else
        temp[:rank] = 'DNP'
      end
      @completed << temp
    end

    remaining_tournaments = tournaments.find_all {|x| x[:tournament_info]["IsOver"] == false}

    @remaining = []
    remaining_tournaments.reverse.each do |tournament|
      temp = Hash.new
      temp[:name] = tournament[:tournament_info]["Name"]
      temp[:date] = tournament[:tournament_info]["StartDate"]

      if tournament[:tournament_info]["IsInProgress"] == true
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
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

end
