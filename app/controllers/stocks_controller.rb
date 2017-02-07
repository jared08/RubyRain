class StocksController < ApplicationController
  before_action :logged_in_user, only: [:new, :show, :index]
  before_action :admin_user, only: [:edit, :update, :destroy]
  before_action :correct_stock, only: [:edit, :update]
 
  def new
    @stock = Stock.new
  end

  def create
    final_params = stock_params
    final_params[:open_price] = stock_params[:current_price]
    @stock = Stock.new(final_params)
    if @stock.save
      flash[:success] = "You added a stock!"
      redirect_to stocks_url
    else
      render 'new'
    end
  end

  def show
    @stock = Stock.find(params[:id])

    #TODO definitely needs to be changed
    @time = Time.now.utc.in_time_zone("Eastern Time (US & Canada)")
  end

  def index

    require 'net/http'

    uri = URI('https://api.fantasydata.net/golf/v2/xml/Players')

    request = Net::HTTP::Get.new(uri.request_uri)

    request['Ocp-Apim-Subscription-Key'] = '34380396ef994539b30aa22ac1759ffb'

    request.body = "{body}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    out_file = File.new("out.txt", "w")

    out_file.puts(response.body.force_encoding('ASCII-8BIT').encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '?'))

    out_file.close

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
      params.require(:stock).permit(:name, :symbol, :current_price, :league)
    end

    def edit_stock_params
      params.require(:stock).permit(:name, :symbol, :league)
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
