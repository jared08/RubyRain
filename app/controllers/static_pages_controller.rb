class StaticPagesController < ApplicationController
  before_filter :redirect_if_logged_in

  def home
  end

  def help
  end
 
  def about
  end
  
  def contact
  end

  def redirect_if_logged_in
    redirect_to(holdings_url) if current_user # check if user logged in
  end

end
