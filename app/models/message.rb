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
end
