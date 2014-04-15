class AddAudienceIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :audience_id, :integer
  end
end
