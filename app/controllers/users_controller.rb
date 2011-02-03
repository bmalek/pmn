class UsersController < ApplicationController

  #require 'twiliolib'

  #before_filter :logged_in?, :except => [:home, :login, :verify, :new, :create]
  #before_filter :authorized?, :except => [:home, :login, :verify, :new, :create]
  skip_before_filter :authorized?, :except => [:index, :show, :edit, :update, :destroy, :logout]

  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/home
  def home
    
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    #@user = User.find_by_id(session[:user_id]) 

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users/login
  # POST /users/login.xml
  def login
    @user = User.find_by_username_and_password(params[:username], params[:password]) #(params[:user])

    respond_to do |format|

      unless @user.nil?
        flash.now[:notice] = 'Successfully logged in!'
        session[:user_id] = @user.id
        format.html { redirect_to(@user) } # login.html.erb
        format.xml  { render :xml => @user } #.errors, :status => :unprocessable_entity }
      else
        flash.now[:notice] = 'Login error, try again!'
        format.html { render :action => "home" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new    

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users/verify
  # POST /users/verify.xml
  def verify
    @user = User.new(params[:user])        
    @resp = @user.send_sms # AFTER send_sms, the challenge_code is generated!
    @challenge_code = @user.challenge_code
    session[:challenge_code] = @challenge_code

    respond_to do |format|
      format.html # verify.html.erb { render :action => "new" }
      format.xml  { render :xml => @user } #.errors, :status => :unprocessable_entity }
    end
  end


  # GET /users/1/edit
  def edit
    #@user = User.find_by_id(params[:id])
    @account = @user.account
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @challenge_code = session[:challenge_code]
    #@response_code = @user.response_code

    respond_to do |format|
      if @user.verified_response_code?(@challenge_code) and @user.add_account_save
        session[:user_id] = @user.id #unless @user.nil?
        flash.now[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        flash.now[:notice] = 'Invalid inputs, try again!'
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    #@user = User.find_by_id(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash.now[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    #@user = User.find_by_id(params[:id])
    @user.destroy
    reset_session

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  # GET /users/logout
  def logout
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
end
