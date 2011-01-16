class VerifyController < ApplicationController
  #this controller verifies a cell phone number through Challenre-Response Protocol
 

  skip_before_filter :verify_authenticity_token

  # Generates a random string from a set of easily readable characters
  def generate_activation_code(size)
    charset = %w{A B C D E F G H J K L M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end

  def generate
    if request.post?
      randnumber_lenght = 6
      @primarynumber = params[:primarynumber]
      @randnumber = generate_activation_code(randnumber_lenght)

      # Use session for verification
      session[:primarynumber] = @primarynumber
      session[:randnumber] = @randnumber
    else
      flash[:notice] = "GENERATE Send your cell phone number first"
      #redirect_to(enter cell phone number page)
   end # end of request.post?

  end # end of generate

  def check
    if request.post?
      @respnumber = params[:respnumber]
      if @respnumber.to_s.upcase == session[:randnumber]
        flash[:notice] = "Good, Cell Phone Verified"
        # redirect_to(:controller => "verify", :action => "result" )
        @user = User.new()
      else
        flash[:notice] = "Cell Phone Not Verified"
      end
    else
      flash[:notice] = "Send your cell phone number first"
      #redirect_to(enter cell phone number page)
    end  # end of if request.post?
  end # end of response


end