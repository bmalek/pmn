class AccountController < ApplicationController

  #before_filter logged_in?, :except => [:login, :index]

  def index
    @categories = Category.find(:all)
    @primarynumber = session[:primarynumber]
  end # end of index

  def register
    if request.post?
      @username = params[:username]
      @password = params[:password]
      @confirm_password = params[:password_confirmation]
      @ads_freq = params[:ads_freq]
      @categories = Category.find_all_by_id(params[:category_ids])
      @primarynumber = session[:primarynumber]
      @user = User.new(:username => @username, :password => @password, :password_confirmation => @password_confirmation, :primarynumber => @primarynumber)
      if @user.save! 
        flash[:notice] = "Account Created!"
      end
      #redirect_to(:controller => "users", :action => "index" )
    end

  end # end of register

  def login
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:username], params[:password])
      if user
        session[:user_id] = user.id                
        redirect_to(:controller => "users", :action => "index" )
      else
        flash[:notice] = "Invalid username/password combination!"        
      end
    end # end of if post

  end # end of signin

end
