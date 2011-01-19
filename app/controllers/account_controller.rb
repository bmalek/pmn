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

  def signin
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:username], params[:password])
      if user
        session[:user_id] = user.id
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || {:controller => "contacts", :action => "index" }) and return true
      else
        flash[:notice] = "Invalid username/password combination!"
        #redirect_to :action=> "login"
      end
    end # end of if post

  end # end of signin

end
