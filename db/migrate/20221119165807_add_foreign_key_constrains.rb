class AddForeignKeyConstrains < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :chats,:applications
    add_foreign_key :chats,:applications, on_delete: :cascade

    remove_foreign_key :messages,:chats
    add_foreign_key :messages,:chats, on_delete: :cascade
  end
end
