# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  room_id     :integer
#  user_id     :integer
#  text        :text
#  created_at  :datetime
#  updated_at  :datetime
#  audience_id :integer
#

class Message < ActiveRecord::Base
  attr_accessible :room_id, :user_id, :text

  belongs_to :user
  belongs_to :room

  #reformat messages with needed fields and username (from user model)
  def json_format
    #create a message hash for the current message
    msg_hash = {}

    #populate the values
    msg_hash["id"] = self.id
    msg_hash["text"] = self.text
    msg_hash["date"] = self.created_at
    msg_hash["username"] = self.user.username

    #return the message hash
    msg_hash
  end

end
