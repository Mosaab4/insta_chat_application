class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :message_number, default: 0, null: false
      t.text :body, null: false
      t.belongs_to :chat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
