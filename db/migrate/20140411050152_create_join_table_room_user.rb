class CreateJoinTableRoomUser < ActiveRecord::Migration
  def change
    create_table :rooms_users, :force => true do |t|
      t.integer "room_id", :null => false
      t.integer "user_id", :null => false
      t.boolean  "active"
    end
  end
end