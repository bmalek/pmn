class Message < ActiveRecord::Base
  belongs_to :user, :foreign_key => "user_id"

  #attr_accessible  

  def reply_sms
    require 'twiliolib'
    # Create a Twilio REST account object using your Twilio account ID and token
    api_version = TWILIO_CONFIG["api_version"]
    account_sid = TWILIO_CONFIG["account_sid"]
    account_token = TWILIO_CONFIG["account_token"]
    caller_id = TWILIO_CONFIG["caller_id"]
    account = Twilio::RestAccount.new(account_sid, account_token)    
    sms = {
    'From' => caller_id.to_s, # self.to,
    'To' => self.from,
    'Body' => 'Thank you!',
    }
    account.request("/#{api_version}/Accounts/#{account_sid}/SMS/Messages", 'POST', sms)

  end


end
