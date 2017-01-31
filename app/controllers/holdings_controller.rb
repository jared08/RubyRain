class HoldingsController < ApplicationController

  def new
    @holding = Holding.new
    @stock_id = params[:format]
  end

  def create
    final_params = holding_params
    stock_name = final_params[:stock]
    stock = Stock.find_by(name: stock_name)
    final_params.delete("stock") #removes the stock name retrieved by the form
    final_params[:stock] = stock #and replaces it with actual stock

    @holding = Holding.where("user_id = ? AND stock_id = ?", current_user.id, stock.id)
    if (final_params[:type_of_holding] == 'buy')
      if (!@holding.empty?) #buying more
        @holding = @holding[0] #to get array from activation record
        new_quantity = final_params[:quantity].to_i + @holding[:quantity]

        final_params[:price_at_purchase] = ((@holding[:quantity] * @holding[:price_at_purchase]) + 
          (final_params[:quantity].to_i * stock[:current_price])) / new_quantity

        final_params[:quantity] = new_quantity
        @holding.update_attributes(final_params)
      else #buying for the first time
        final_params[:price_at_purchase] = stock[:current_price]
        @holding = current_user.holdings.create(final_params)
      end 

      if @holding.save
        redirect_to holdings_url
      else
        render 'new'
      end

    else #selling stock
      @holding = @holding[0] #to get array from activation record
      if (@holding[:quantity] > final_params[:quantity].to_i) # only selling some
        new_quantity = @holding[:quantity] - final_params[:quantity].to_i
        final_params[:quantity] = new_quantity
        @holding.update_attributes(final_params)

        if @holding.save
          redirect_to holdings_url
        else
          render 'new'
        end

      else #selling all
        Holding.find(@holding[:id]).destroy
        redirect_to holdings_url
      end
    end
  end
  
  def index
    @holdings = Holding.where(:user => current_user)
  end


  private
    def holding_params
      params.require(:holding).permit(:stock, :type_of_holding, :quantity)
    end

end
