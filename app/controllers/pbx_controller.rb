class PbxController < ApplicationController
  skip_before_filter :authorized?  

  def voice    

    @postto = TWILIO_CONFIG["base_url"].to_s + '/pbx/check'

    respond_to do |format|
        format.xml { @postto }
    end
  end

  def check

    vc = {
    :sid => params[:CallSid],
    :from => params[:From],
    :to => params[:To],
    :status => params[:CallStatus],
    :direction => params[:Direction],    
    :body => params[:Digits]
    }

    @call = Call.new(vc)
    @call.save
    
    @digits = @call.body.to_s

    @digits.split(//).join(', ')

    respond_to do |format|
        format.xml 
    end

  end

  def sms

  end
end
