class RenameUrlToRecordingUrl < ActiveRecord::Migration[5.2]
  def change
    rename_column :messages, :url, :recording_url
  end
end
