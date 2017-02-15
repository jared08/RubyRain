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
    if (final_params[:type_of_holding] == 'buy' || final_params[:type_of_holding] == 'short')
      if ((stock_price * new_quantity) > current_user.cash) #checks to see if the user has enough cash
        flash[:danger] = "Sorry you don't have enough cash.."
        redirect_to request.path #since we want a new form
        return
      end
      if (!@holding.empty?) #buying/shorting more
        @holding = @holding[0] #to get array from activation record
        if (@holding.type_of_holding == 'buy' && final_params[:type_of_holding] == 'short')
          flash[:danger] = "Sorry you can't short a stock that you already bought.."
          redirect_to request.path
        elsif (@holding.type_of_holding == 'short' && final_params[:type_of_holding] == 'buy')
          flash[:danger] = "Sorry you can't buy a stock that you already have shorted.."
          redirect_to request.path
        else            
          total_quantity = new_quantity + @holding[:quantity]

          final_params[:price_at_purchase] = ((@holding[:quantity] * @holding[:price_at_purchase]) + 
            (new_quantity * stock_price)) / total_quantity

          final_params[:quantity] = total_quantity
          @holding.update_attributes(final_params)
        end
      else #buying/shorting for the first time
        final_params[:price_at_purchase] = stock_price
        @holding = current_user.holdings.create(final_params)
      end 

      stock[:volume] = stock[:volume] + new_quantity #not sure what to do with this for shorts
      if (final_params[:type_of_holding] == 'buy')      
        stock[:current_price] = stock[:current_price] + (new_quantity * (1 / stock[:volume].to_f))#need to figure out how the price of a stock is raised
        if (stock[:current_price] > stock[:high])
          stock[:high] = stock[:current_price]
        end
        if (stock[:current_price] > stock[:season_high])
          stock[:season_high] = stock[:current_price]
        end
      else #short
        stock[:current_price] = stock[:current_price] - (new_quantity * (1 / stock[:volume].to_f))#need to figure out how the price of a stock is raised
        if (stock[:current_price] < stock[:low])
          stock[:low] = stock[:current_price]
        end
        if (stock[:current_price] < stock[:season_low])
          stock[:season_low] = stock[:current_price]
        end
      end
      stock.save

      if @holding.save
        current_user.update_attribute :cash, (current_user.cash - (stock_price * new_quantity))
        redirect_to holdings_url
      else
        render 'new'
      end

    else #selling/covering stock
      stock_price = stock[:current_price]
      new_quantity = final_params[:quantity].to_i
      if (@holding.empty?) 
        if (final_params[:type_of_holding] == 'sell')
          flash[:danger] = "Sorry you can't sell a stock you haven't bought"
          redirect_to request.path
        else
          flash[:danger] = "Sorry you can't cover a stock you haven't shorted "
          redirect_to request.path
        end
      else
        @holding = @holding[0] #to get array from activation record
        if (@holding[:quantity] > new_quantity) # only selling/covering some
          total_quantity = @holding[:quantity] - new_quantity
          final_params[:quantity] = total_quantity
          @holding.update_attributes(final_params)
          if @holding.save

            stock[:volume] = stock[:volume] - new_quantity
            if (stock[:volume] == 0)
              if (final_params[:type_of_holding] == 'sell')
                stock[:current_price] = stock[:current_price] - (new_quantity * (1 / new_quantity.to_f))
              else
		stock[:current_price] = stock[:current_price] + (new_quantity * (1 / new_quantity.to_f))
              end
            else
              if (final_params[:type_of_holding] == 'sell')
                stock[:current_price] = stock[:current_price] - (new_quantity * (1 / stock[:volume].to_f))
              else
		stock[:current_price] = stock[:current_price] + (new_quantity * (1 / stock[:volume].to_f))
	      end
            end

            if (final_params[:type_of_holding] == 'sell')
              if (stock[:current_price] < stock[:low])
                stock[:low] = stock[:current_price]
                if (stock[:current_price] < stock[:season_low])
                  stock[:season_low] = stock[:current_price]
                end
              end
            else
 	      if (stock[:current_price] > stock[:high])
                stock[:high] = stock[:current_price]
                if (stock[:current_price] > stock[:season_high])
                  stock[:season_high] = stock[:current_price]
                end
              end
            end
            stock.save

            if (final_params[:type_of_holding] == 'sell')
              current_user.update_attribute :cash, (current_user.cash + (stock_price * total))
            else
              current_user.update_attribute :cash, (current_user.cash + (total * (@holding.price_at_purchase - stock_price)))
            end

            redirect_to holdings_url
          else
            render 'new'
          end

        elsif (@holding[:quantity] = new_quantity) #selling/covering all
          total = @holding[:quantity] #needed to calculate cash after sale
          Holding.find(@holding[:id]).destroy
 
	  stock[:volume] = stock[:volume] - new_quantity
            if (stock[:volume] == 0)
              if (final_params[:type_of_holding] == 'sell')
                stock[:current_price] = stock[:current_price] - (new_quantity * (1 / new_quantity.to_f))
              else
                stock[:current_price] = stock[:current_price] + (new_quantity * (1 / new_quantity.to_f))
              end
            else
              if (final_params[:type_of_holding] == 'sell')
                stock[:current_price] = stock[:current_price] - (new_quantity * (1 / stock[:volume].to_f))
              else
                stock[:current_price] = stock[:current_price] + (new_quantity * (1 / stock[:volume].to_f))
              end
            end

            if (final_params[:type_of_holding] == 'sell')
              if (stock[:current_price] < stock[:low])
                stock[:low] = stock[:current_price]
                if (stock[:current_price] < stock[:season_low])
                  stock[:season_low] = stock[:current_price]
                end
              end
            else
              if (stock[:current_price] > stock[:high])
                stock[:high] = stock[:current_price]
                if (stock[:current_price] > stock[:season_high])
                  stock[:season_high] = stock[:current_price]
                end
              end
            end
            stock.save

          if (final_params[:type_of_holding] == 'sell')
            current_user.update_attribute :cash, (current_user.cash + (stock_price * total))
          else
	    current_user.update_attribute :cash, (current_user.cash + (total * (@holding.price_at_purchase - stock_price)))
          end
          redirect_to holdings_url
        else
          if (final_params[:type_of_holding] == 'sell')
            flash[:danger] = "Sorry you can't sell more stock than you own"
            redirect_to request.path
          else
            flash[:danger] = "Sorry you can't cover more stock that you have shorted "
            redirect_to request.path
          end    
        end
      end
    end
  end
  
  def index
    @holdings = Holding.where(:user => current_user)
    @holdings_value = 0   
    @holdings.each do |holding|
      if (holding[:type_of_holding] == 'buy')
        @holdings_value = @holdings_value + (holding[:quantity] * holding.stock[:current_price])
      else #(q * i) - (q(c - i))
        @holdings_value = @holdings_value + ((holding[:quantity] * holding[:price_at_purchase]) - 
	    (holding[:quantity] * (holding.stock[:current_price] - holding[:price_at_purchase])))
      end
    end
  end


  private
    def holding_params
      params.require(:holding).permit(:stock, :type_of_holding, :quantity)
    end

end
