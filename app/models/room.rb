# == Schema Information
#
# Table name: rooms
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Room < ActiveRecord::Base
  attr_accessible :name, :description

  has_many :messages
  has_and_belongs_to_many :users
  has_many :votes

 # Room validation - doesn't allow a space at the start or end when creating a room, 
 # 	and min and max character set to 5 min and 32 max.
  validates :name, length: { minimum: 5, maximum: 32 }, :uniqueness => true,
  format: { with: /\A\b[a-zA-Z0-9]+\b\Z/, message: "only allows alphanumeric characters without spaces" } 

end
