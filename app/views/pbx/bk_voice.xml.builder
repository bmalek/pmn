xml.instruct!
  xml.Response do
    xml.Say "Hello there. Do you have your four digit coupon?"
      xml.Gather(:action => @postto, :method => 'GET', :numDigits => 4) do
        xml.Say "Please enter it now!"
      end
  end