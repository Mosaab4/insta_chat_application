class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :token
      t.integer :chats_count, default:0,null:false

      t.timestamps
    end

    change_column_null :applications, :name, false
    change_column_null :applications, :token, false

    add_index :applications, [:token,:name], unique: true
  end
end
