xml.instruct!
xml.Response do
    xml.Say "You Entered #{@say_digits}."
    xml.Say "#{@call.reply_message}"
    if @flag
      xml.Say "Goodbye!"
    else
      xml.Redirect @redirect, :method => "GET"
    end
    
    xml.Hangup
end