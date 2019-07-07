require 'twilio-ruby'

account_sid = ENV["twilio_account_sid"]
auth_token = ENV["twilio_auth_token"]

$twilio_client = Twilio::REST::Client.new account_sid, auth_token
