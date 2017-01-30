class StocksController < ApplicationController
  before_action :logged_in_user, only: [:new, :show, :index]
  before_action :admin_user, only: [:edit, :update, :destroy]
  before_action :correct_stock, only: [:edit, :update]
 
  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(stock_params)
    if @stock.save
      flash[:success] = "You added a stock!"
      redirect_to stocks_url
    else
      render 'new'
    end
  end

  def show
    @stock = Stock.find(params[:id])
  end

  def index
    @stocks = Stock.all
  end

  def edit
  end

  def update
    if @stock.update_attributes(edit_stock_params)
      flash[:success] = "Stock updated"
      redirect_to @stock
    else
      render 'edit'
    end
  end
  
  def destroy
    Stock.find(params[:id]).destroy
    flash[:success] = "Stock deleted"
    redirect_to stocks_url
  end

  private
    def stock_params
      params.require(:stock).permit(:name, :current_price)
    end

    def edit_stock_params
      params.require(:stock).permit(:name)
    end
  
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_stock
      @stock = Stock.find(params[:id])
    end

     # Confirms an admin user.
    def admin_user
      unless current_user.admin?
        flash[:danger] = "You don't have access to this.."
        redirect_to login_url 
      end
    end


end
