class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

   def show_stock_modal
    @stock = Stock.find_by(id: params[:stock_id])
    #TODO definitely needs to be changed
    @time = Time.now.utc.in_time_zone("Eastern Time (US & Canada)")
    respond_to do |format|
      format.js {render 'shared/show_stock_modal.js'}
    end
  end

  def show_user_modal
    @user = User.find_by(id: params[:user_id])
    respond_to do |format|
      format.js {render 'shared/show_user_modal.js'}
    end
  end
 
  def show_news_modal
    @n = News.find_by(id: params[:news_id]) 
    respond_to do |format|
      format.js {render 'shared/show_news_modal.js'}
    end
  end


end
