class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :from
      t.string :url
      t.timestamps null: false
    end
  end
end
