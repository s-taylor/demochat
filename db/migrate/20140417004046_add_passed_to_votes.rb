class AddPassedToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :passed, :boolean
  end
end
