class WatchlistsController < ApplicationController
  def new
    stock = Stock.find_by(id: params[:id])
    @watchlist = Watchlist.new
    @watchlist.user_id = current_user.id
    @watchlist.stock_id = params[:id]
    @watchlist.save

    flash[:success] = "Added to watchlist"
    redirect_to stock
  end

  def destroy 
    stock = Watchlist.find(params[:id]).stock
    Watchlist.find(params[:id]).destroy

    flash[:success] = "Removed from watchlist"
    redirect_to stock
  end
end
