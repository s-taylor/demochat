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
    msg_hash["date"] = self.created_at
    msg_hash["username"] = self.user.username

    #if message is private, append PRIVATE to the front of message
    msg_hash["text"] = ""
    msg_hash["text"] = "PRIVATE: " if self.audience_id
    msg_hash["text"] += self.text

    #return the message hash
    msg_hash
  end

  #create system message (requires Room obj, text as string, audience id as int)
  def self.system_msg(room, text, audience_id=nil)
    system_user = User.where('username = ?','SYSTEM').first

    message = system_user.messages.new(:text => text)
    message.audience_id = audience_id
    message.room_id = room.id

    message.save
  end

end
