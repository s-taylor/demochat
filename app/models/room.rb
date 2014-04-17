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

  attr_accessible :name, :description, :current_user

  has_many :messages
  has_and_belongs_to_many :users
  has_many :votes

  #Room validation - doesn't allow a space at the start or end when creating a room, 
  #and min and max character set to 5 min and 32 max.
  validates :name, length: { minimum: 5, maximum: 20 }, :uniqueness => true,
  format: { with: /\A\b[a-zA-Z0-9]+\b\Z/, message: "only allows alphanumeric characters without spaces" }

  #find if user exists in this room ONLY, case insensitive (if not found will return nil)
  def find_user(username)
    self.users.where('username = ?',username).first
  end

  def is_muted?(user)

    #find a mute vote for this user in the current room where it is closed and passed
    mute_vote = self.votes.where('target = ? AND created_at > (NOW() - interval \'2 hour\') AND closed is true AND passed is true', user.id).first

    #return true if mute vote exists or false if not
    mute_vote ? true : false
  end
end
