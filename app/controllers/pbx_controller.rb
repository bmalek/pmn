class PbxController < ApplicationController
  skip_before_filter :authorized?

  BASE_URL = TWILIO_CONFIG["base_url"]

  def voice    

    @postto = BASE_URL + '/pbx/check'

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
