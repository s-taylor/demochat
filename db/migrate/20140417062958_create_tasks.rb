class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :frequency
      t.integer :counter

      t.timestamps
    end
  end
end
