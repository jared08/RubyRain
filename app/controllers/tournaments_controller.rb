class TournamentsController < ApplicationController
  def index

    @stock_id = params[:stock_id] 
    
    tournaments = Tournament.all

    @completed_tournaments = tournaments.find_all {|x| x[:tournament_info]["IsOver"] == true}
    @remaining_tournaments = tournaments.find_all {|x| x[:tournament_info]["IsOver"] == false}

  end
end
