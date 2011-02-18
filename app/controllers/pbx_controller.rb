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
    :sid => params[:Sid],
    :from => params[:From],
    :to => params[:To],
    :status => params[:Status],
    :direction => params[:Direction],
    :name => params[:CallerName],
    :body => params[:Digits]
    }

    @call = Call.new(vc)
    @call.save

    @digits = params[:Digits]

    respond_to do |format|
        format.xml
    end

  end

  def sms

  end
end
