class AddIntentToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :intent, :string
  end
end
