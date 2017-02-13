class TournamentsController < ApplicationController
  before_action :logged_in_user, only: [:index]
  def index

    @stock_id = params[:stock_id] 
    
    tournaments = Tournament.all

    @completed_tournaments = tournaments.find_all {|x| x[:tournament_info]["IsOver"] == true}

    @remaining_tournaments = tournaments.find_all {|x| x[:tournament_info]["IsOver"] == false}
    @upcoming_tournament = @remaining_tournaments.pop
    

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
