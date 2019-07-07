class MessagesController < ApplicationController
  def create
    Message.create(from: params["From"], sid: params["CallSid"])
    response = Twilio::TwiML::VoiceResponse.new
    response.say(message: 'Hello World')
    render xml: response
  end

  def complete
    head :ok
  end
end
