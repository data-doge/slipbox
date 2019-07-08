class Message < ApplicationRecord
  INTENTS = {
    "1" => :whisper
  }
  def self.intent_for(digit)
    INTENTS[digit]
  end
end
