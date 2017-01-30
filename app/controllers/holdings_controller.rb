class HoldingsController < ApplicationController

  def new
    @holding = Holding.new
    @stock_id = params[:format]
  end

  def create
    debugger
    @holding = current_user.holdings.create(holding_params.merge(:stock_id => @stock_id))
    if @holding.save
      flash[:success] = "You bought a stock!"
      redirect_to holdings_url
    else
      render 'new'
    end
  end
  
  def index
    @holdings = Holding.all
  end


  private
    def holding_params
      params.require(:holding).permit(:stock_name, :type_of_holding, :quantity)
    end

end
