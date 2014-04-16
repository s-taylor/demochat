class RemoveImageFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :image, :text
  end
end
