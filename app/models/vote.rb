# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  category   :string(255)
#  target     :integer
#  room_id    :integer
#  closed     :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Vote < ActiveRecord::Base
  #required for protected attributes mass assignment
  attr_accessible :category, :target, :room_id, :closed

  #relationships
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

  #check if a text string is a vote and return vote components as Regex
  def self.check_msg(text)
    #return [1] = command, return [2] = target
    vote_text = /vote (.+) (.+)/.match text
  end

  #check if the vote is valid (requires 'room' object, 'command' as text, 'target' as text)
  def self.validate_msg(room, command, target)
    #create an empty hash
    response = {}

    #find any open votes for this room
    open_vote = room.votes.where('closed is false').first

    #if there is not an open vote
    unless open_vote

      #if command is mute
      case command 
      when "mute"

        #find the target user within the specified room
        target_user = room.find_user(target)

        #check if target user is valid
        if target_user
          response[:valid] = true
          response[:message] = "Mute Vote Initiated for User: \"#{target_user.username}\", type \"Respond Yes\" or \"Respond No\""
          response[:private] = false
          response[:target] = target_user.id
        #mute target is invalid so error
        else
          response[:valid] = false
          response[:message] = "Your target for a mute vote is invalid, target must be a user in this room, check username"
          response[:private] = true
          response[:target] = nil
        end#if target_user

      #vote command is invalid so error
      else
        response[:valid] = false
        response[:message] = "Your vote command is invalid, vote commands available are \"mute\"."
        response[:private] = true
        response[:target] = nil
      end#when "mute"

    #there is an open vote already  
    else
      response[:valid] = false
      response[:message] = "An open vote already exists for this room, please wait until this is closed"
      response[:private] = true
      response[:target] = nil
    end

    #return the response hash
    response
  end#def self.validate_msg
end
