class PbxController < ApplicationController
  skip_before_filter :authorized?  

  def voice    

    @postto = TWILIO_CONFIG["base_url"].to_s + 'pbx/check'

    respond_to do |format|
        format.xml { @postto }
    end
  end

  def check

    voice = {
    :sid => params[:CallSid],
    :from => params[:From],
    :to => params[:To],
    :status => params[:CallStatus],
    :direction => params[:Direction],    
    :body => params[:Digits]
    }

    @call = Call.new(voice)    
    
    @say_digits = @call.body.to_s.split(//).join(', ')

    @flag = @call.match_coupon?(voice)

    respond_to do |format|
        if @call.save and @flag        
        format.xml { @call }
      else        
        @redirect = TWILIO_CONFIG["base_url"].to_s + 'pbx/voice'
        format.xml { @call }
      end
    end

  end

  def sms

  end
end
