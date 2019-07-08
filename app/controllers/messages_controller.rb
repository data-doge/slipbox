class MessagesController < ApplicationController
  def create
    # TODO: budget check
    Message.find_or_create_by(from: params["From"], sid: params["CallSid"])
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(timeout: 5, method: "POST", action: "#{ENV["base_uri"]}/messages/process_input", numDigits: 1) do |gather|
      gather.play(url: asset("intro"))
    end
    response.redirect(messages_url, method: 'POST')
    render xml: response
  end

  def process_input
    sid = params["CallSid"]
    digits = params["Digits"] || ""
    # if digits == "hangup"
    #   head :ok and return
    # end
    digit = digits.first || "0"
    message = Message.find_by_sid(sid)
    message.update(intent: Message.intent_for(digit))
    response = Twilio::TwiML::VoiceResponse.new
    case digit
    when "1"
      response.redirect(whisper_messages_url, method: "POST")
    else
      response.redirect(messages_url, method: 'POST')
    end
    render xml: response
  end

  def whisper
    sid = params["CallSid"]
    response = Twilio::TwiML::VoiceResponse.new
    response.play(url: asset("whisper"))
    response.play(url: asset("beep"))
    response.record(
      method: "POST",
      action: hangup_messages_url,
      maxLength: 10,
      playBeep: false,
      recordingStatusCallbackMethod: "POST",
      recordingStatusCallback: "#{ENV['base_uri']}/messages/voicemail?call_sid=#{sid}"
    )
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

  def hangup
    response = Twilio::TwiML::VoiceResponse.new
    response.say(message: "Thanks")
    response.hangup
    render xml: response
  end

  private

  def asset(path)
    "#{ENV["base_uri"]}/#{path}.mp3"
  end
end
