xml.instruct!
xml.Response do
    xml.Gather(:action => @postto, :numDigits => 4) do
        xml.Say "Hello, do you have your four digit coupon?"
        xml.Say "Please enter it now."
    end
end