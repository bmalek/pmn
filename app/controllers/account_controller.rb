class AccountController < ApplicationController

  def index
    @categories = Category.find(:all)
    
  end # end of index

  def register
    if request.post?
      @username = params[:username]
      @password = params[:password]
      @confirm_password = params[:confirm_password]
      @ads_freq = params[:ads_freq]
      @categories = Category.find_all_by_id(params[:category_ids])
    end


  end # end of register

end
