class AddSidToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :sid, :string
  end
end
