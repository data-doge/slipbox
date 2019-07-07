class MessagesController < ApplicationController
  def create
    message = Message.create(from: params["From"], sid: params["CallSid"])
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(method: "POST", action: "#{ENV["base_uri"]}/messages/process_input") do |gather|
      gather.play(url: "#{ENV["base_uri"]}/intro.mp3")
    end
    render xml: response
  end

  def process_input
    sid = params["CallSid"]
    key = params["Digits"].first || "0"
    response = Twilio::TwiML::VoiceResponse.new
    case key
    when "1"
      response.play(url: "#{ENV["base_uri"]}/whisper.mp3")
      response.record(
        maxLength: 10,
        playBeep: true,
        recordingStatusCallbackMethod: "POST",
        recordingStatusCallback: "#{ENV['base_uri']}/messages/voicemail?call_sid=#{sid}"
      )
    end
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
