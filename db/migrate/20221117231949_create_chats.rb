class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.integer :chat_number, null: false
      t.integer :messages_count, default: 0, null: false
      t.belongs_to :application, null: false, foreign_key: true

      t.timestamps
    end
  end
end
