# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  category   :string(255)
#  target     :integer
#  room_id    :integer
#  status     :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Vote < ActiveRecord::Base
  attr_accessible :category, :target, :room_id, :closed

  belongs_to :room
  has_many :responses

  def close_vote
    yes = self.responses.where('choice = true').count
    no = self.responses.where('choice = false').count
    total_votes = yes + no
    calculate = yes.to_f / total_votes.to_f

    if calculate > 0.5
      puts "vote success"
      return true
      User.kick(self.target)
    else
      puts "vote fail"
      return false
    end
  end
end
