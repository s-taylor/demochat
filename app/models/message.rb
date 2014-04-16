# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  room_id    :integer
#  user_id    :integer
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#

class Message < ActiveRecord::Base
    attr_accessible :room_id, :user_id, :text

    belongs_to :user
    belongs_to :room


  #validation for chat message
  #username must be populated and present in the room, a minimum of 1 character, maximum of 512 characters
  	validates :text, :length => { minimum: 1, maximum: 512 }
end
