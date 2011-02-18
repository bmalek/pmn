xml.instruct!
xml.Response do
    xml.Say "You Entered #{@digits}"
    xml.Say "Goodbye!"
    xml.Hangup
end