class UsersController < ApplicationController

  before_filter :logged_in?, :except => [:new, :verify, :create]

  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users/login
  # POST /users/login.xml
  def login
    @user = User.find_by_username_and_password(params[:username], params[:password]) #(params[:user])
    #session[:user_id] ||= @user.id 

    respond_to do |format|
      format.html # login.html.erb
      format.xml  { render :xml => @user } #.errors, :status => :unprocessable_entity }
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
    @challenge_code = @user.generate_challenge_code
    session[:challenge_code] = @challenge_code

    respond_to do |format|
      format.html # verify.html.erb { render :action => "new" }
      format.xml  { render :xml => @user } #.errors, :status => :unprocessable_entity }
    end
  end


  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @challenge_code = session[:challenge_code]
    #@response_code = @user.response_code

    respond_to do |format|
      if @user.verified_response_code?(@challenge_code) and @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find_by_id(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
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
    @user = User.find_by_id(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
