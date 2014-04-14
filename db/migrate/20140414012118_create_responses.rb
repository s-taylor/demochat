class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :vote_id
      t.integer :user_id
      t.boolean :choice
      t.timestamps
    end
  end
end
