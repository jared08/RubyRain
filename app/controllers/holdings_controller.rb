class HoldingsController < ApplicationController
  before_action :logged_in_user, only: [:new, :index]
  respond_to :html, :js

  def new
    @holding = Holding.new
    @stock = Stock.find_by(symbol: params[:stock_symbol])
    @user = current_user
    @past_holding = Holding.find_by(user_id: current_user.id, stock_id: @stock.id)
  end


  def refresh
    @stock = Stock.find_by(symbol: params[:stock_symbol])
    respond_to do |format|
      format.js
    end
  end

  def create
    final_params = holding_params
    stock_symbol = final_params[:symbol]
    stock = Stock.find_by(symbol: stock_symbol)
    final_params.delete("symbol") #removes the stock name retrieved by the form
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
          return
        elsif (@holding.type_of_holding == 'short' && final_params[:type_of_holding] == 'buy')
          flash[:danger] = "Sorry you can't buy a stock that you already have shorted.."
          redirect_to request.path
          return
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
      stock[:current_price] = stock[:current_price] + stock[:price_to_change] #price changes based on prior transaction (so you don't 'earn' money when you buy stock)
      if (final_params[:type_of_holding] == 'buy')      
        stock[:price_to_change] = (new_quantity * (1 / stock[:volume].to_f)) #maybe a better algorithm?
        if (stock[:current_price] > stock[:high])
          stock[:high] = stock[:current_price]
        end
        if (stock[:current_price] > stock[:season_high])
          stock[:season_high] = stock[:current_price]
        end
      else #short
        stock[:price_to_change] = (-1) * (new_quantity * (1 / stock[:volume].to_f))#maybe a better algorithm
        if (stock[:current_price] < stock[:low])
          stock[:low] = stock[:current_price]
        end
        if (stock[:current_price] < stock[:season_low])
          stock[:season_low] = stock[:current_price]
        end
      end
      stock[:num_trades] = stock[:num_trades] + new_quantity
      stock[:daily_change] = ((stock[:current_price] - stock[:open_price]) / stock[:open_price])
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
          return
        else
          flash[:danger] = "Sorry you can't cover a stock you haven't shorted "
          redirect_to request.path
          return
        end
      else
        @holding = @holding[0] #to get array from activation record
        if (@holding[:quantity] > new_quantity) # only selling/covering some
          total_quantity = @holding[:quantity] - new_quantity
          #final_params[:quantity] = total_quantity
          @holding[:quantity] = total_quantity
          #@holding.update_attributes(final_params)
          if @holding.save

            stock[:volume] = stock[:volume] - new_quantity
            stock[:current_price] = stock[:current_price] + stock[:price_to_change]
            if (stock[:volume] == 0)
              if (final_params[:type_of_holding] == 'sell')
                stock[:price_to_change] = (-1) * (new_quantity * (1 / new_quantity.to_f))
              else
		stock[:price_to_change] = (new_quantity * (1 / new_quantity.to_f))
              end
            else
              if (final_params[:type_of_holding] == 'sell')
                stock[:price_to_change] = (-1) * (new_quantity * (1 / stock[:volume].to_f))
              else
		stock[:price_to_change] = (new_quantity * (1 / stock[:volume].to_f))
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
            stock[:num_trades] = stock[:num_trades] + new_quantity
            stock[:daily_change] = ((stock[:current_price] - stock[:open_price]) / stock[:open_price])
            stock.save

            if (final_params[:type_of_holding] == 'sell')
              current_user.update_attribute :cash, (current_user.cash + (stock_price * new_quantity))
            else
              current_user.update_attribute :cash, (current_user.cash + (new_quantity * (@holding.price_at_purchase - stock_price)))
            end

            redirect_to holdings_url
          else
            render 'new'
          end

        elsif (@holding[:quantity] == new_quantity) #selling/covering all
          total_quantity = @holding[:quantity] #needed to calculate cash after sale
          price_at_purchase = @holding[:price_at_purchase] #same
          Holding.find(@holding[:id]).destroy
 
	  stock[:volume] = stock[:volume] - new_quantity
          stock[:current_price] = stock[:current_price] + stock[:price_to_change]
            if (stock[:volume] == 0)
              if (final_params[:type_of_holding] == 'sell')
                stock[:price_to_change] = (-1) * (new_quantity * (1 / new_quantity.to_f))
              else
                stock[:price_to_change] = (new_quantity * (1 / new_quantity.to_f))
              end
            else
              if (final_params[:type_of_holding] == 'sell')
                stock[:price_to_change] = (-1) * (new_quantity * (1 / stock[:volume].to_f))
              else
                stock[:price_to_change] = (new_quantity * (1 / stock[:volume].to_f))
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
            stock[:num_trades] = stock[:num_trades] + new_quantity
            stock[:daily_change] = ((stock[:current_price] - stock[:open_price]) / stock[:open_price])
            stock.save

          if (final_params[:type_of_holding] == 'sell')
            current_user.update_attribute :cash, (current_user.cash + (stock_price * total_quantity))
          else
	    current_user.update_attribute :cash, (current_user.cash + (total_quantity * (price_at_purchase - stock_price)))
          end
          redirect_to holdings_url
        else
          if (final_params[:type_of_holding] == 'sell')
            flash[:danger] = "Sorry you can't sell more stock than you own"
            redirect_to request.path
            return
          else
            flash[:danger] = "Sorry you can't cover more stock that you have shorted "
            redirect_to request.path
            return
          end    
        end
      end
    end
  end
  
  def index
    @holdings = Holding.where(:user => current_user)
  end 

  def watch
    @holding = Holding.new
    @holding.user_id = current_user.id
    @holding.stock_id = params[:id]
    @holding.type_of_holding = 'watch'
    
    @holding.save
    debugger
  end

  def unwatch
    debugger
  end

  private
    def holding_params
      params.require(:holding).permit(:symbol, :type_of_holding, :quantity)
    end

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
