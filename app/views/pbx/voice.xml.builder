xml.instruct!
  xml.Response do
    xml.Say "Hello there! Enter your four digit coupon now!"
      xml.Gather :action => @postto, :method => "GET", :numDigits => 4 do
        xml.Pause :length => "30"
      end
      xml.Hangup
  end