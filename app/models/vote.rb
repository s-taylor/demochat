# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  category   :string(255)
#  target     :integer
#  room_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Vote < ActiveRecord::Base
    attr_accessible :category, :target, :room_id

    belongs_to :room
    has_many :responses
end
