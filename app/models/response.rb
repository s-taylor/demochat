# == Schema Information
#
# Table name: responses
#
#  id         :integer          not null, primary key
#  vote_id    :integer
#  user_id    :integer
#  choice     :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Response < ActiveRecord::Base
    attr_accessible :vote_id, :user_id, :choice

    belongs_to :user
    belongs_to :vote
end
