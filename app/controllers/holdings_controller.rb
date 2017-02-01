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

    stock_price = stock[:current_price]
    new_quantity = final_params[:quantity].to_i

    @holding = Holding.where("user_id = ? AND stock_id = ?", current_user.id, stock.id)
    if (final_params[:type_of_holding] == 'buy')
      if (!@holding.empty?) #buying more
        @holding = @holding[0] #to get array from activation record
        total_quantity = new_quantity + @holding[:quantity]

        final_params[:price_at_purchase] = ((@holding[:quantity] * @holding[:price_at_purchase]) + 
          (new_quantity * stock_price)) / total_quantity

        final_params[:quantity] = total_quantity
        @holding.update_attributes(final_params)
      else #buying for the first time
        final_params[:price_at_purchase] = stock_price
        @holding = current_user.holdings.create(final_params)
      end 

      if @holding.save
        current_user.update_attribute :cash, (current_user.cash - (stock_price * new_quantity))
        redirect_to holdings_url
      else
        render 'new'
      end

    else #selling stock
      stock_price = stock[:current_price]
      new_quantity = final_params[:quantity].to_i
  
      @holding = @holding[0] #to get array from activation record
      if (@holding[:quantity] > new_quantity) # only selling some
        total_quantity = @holding[:quantity] - new_quantity
        final_params[:quantity] = total_quantity
        @holding.update_attributes(final_params)
        if @holding.save
          current_user.update_attribute :cash, (current_user.cash + (stock_price * new_quantity))
          redirect_to holdings_url
        else
          render 'new'
        end

      else #selling all
        Holding.find(@holding[:id]).destroy
        current_user.update_attribute :cash, (current_user.cash + (stock_price * new_quantity))
        redirect_to holdings_url
      end
    end
  end
  
  def index
    @holdings = Holding.where(:user => current_user)
    @holdings_value = 0   
    @holdings.each do |holding|
      @holdings_value = @holdings_value + (holding[:quantity] * holding.stock[:current_price])
    end
  end


  private
    def holding_params
      params.require(:holding).permit(:stock, :type_of_holding, :quantity)
    end

end
