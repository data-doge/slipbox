class MessagesController < ApplicationController
  def create
    message = Message.create(from: params["From"], sid: params["CallSid"])
    response = Twilio::TwiML::VoiceResponse.new
    response.say(message: 'Here is an explanation')
    response.record(
      maxLength: 10,
      playBeep: true,
      recordingStatusCallbackMethod: "POST",
      recordingStatusCallback: "#{ENV['base_uri']}/messages/voicemail?call_sid=#{message.sid}"
    )
    response.say(message: "Thank you")
    render xml: response
  end

  def voicemail
    message = Message.find_by_sid(params[:call_sid])
    message.update(recording_url: params["RecordingUrl"])
    $twilio_client.messages.create({
      body: message.recording_url,
      from: ENV["twilio_phone"],
      to: ENV["eugenes_phone"]
    })
    head :ok
  end
end
