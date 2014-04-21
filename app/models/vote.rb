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
#  passed     :boolean
#

class Vote < ActiveRecord::Base
  #required for protected attributes mass assignment
  attr_accessible :category, :target, :room_id, :closed

  #relationships
  belongs_to :room
  has_many :responses

  def close
    #count yes, no and total votes
    yes = self.responses.where('choice = true').count
    no = self.responses.where('choice = false').count
    total_responses = yes + no

    #determine outcome (% of yes votes)
    outcome = yes.to_f / total_responses.to_f

    #set vote to closed
    self.closed = true

    #find target user
    username = User.find(self.target).username

    # if participation < 0.2
      #OUTPUT INADEQUATE PARTICIPATION
      # passed = false
    if outcome > 0.5
      #OUTPUT VOTE SUCCESSFUL (X% voted yes)
      self.passed = true
      Message.system_msg(self.room, "#{self.category} vote against #{username} was successful! #{yes} users voted yes and #{no} users voted no. #{username} will be unable to message for 1 hour", nil)
    else
      #OUTPUT VOTE UNSUCCESSFUL (X% voted yes)
      self.passed = false
      Message.system_msg(self.room, "#{self.category} vote against #{username} was unsuccessful! #{yes} users voted yes and #{no} users voted no.", nil)
    end

    self.save
  end

  #---------------------------------------------
  # CLASS METHODS

  #check for votes that need to close (where more than 5 minutes has passed)
  def self.check_to_close
    #current time minus 5 minutes (in UTC)
    time = Time.now.utc - (5 * 60)

    #find votes created more than 5 minutes ago
    votes = Vote.where('created_at < ? AND closed is false',time)

    #close each vote found
    votes.each { |vote| vote.close }

    #return the votes closed
    votes
  end

  #check if message text is a vote and return vote components as Regex
  def self.check_msg(text)
    #return [1] = command, return [2] = target
    vote_text = /vote (.+) (.+)/.match text
  end

  #validate the vote and if valid, create it and an associated response
  def self.message_to_vote(user, room, command, target)
    #perform vote validation and retrieve output
    result = Vote.validate_msg(user, room, command, target)

    #create a system message, provide audience id if private
    Message.system_msg(room, result[:message], result[:audience_id])

    #if the vote is valid, create it
    if result[:valid]
      vote = Vote.create(
        :category => command,
        :target => result[:target],
        :room_id => room.id,
        :closed => false
      )

      #create a corresponding response for the vote
      vote.present? && Response.create(
        :vote_id => vote.id,
        :user_id => user.id,
        :choice => true,
      )

      #inform user a response was automatically recorded
      Message.system_msg(room, "Your response of yes has automatically been recorded for your vote", user.id)
    end
  end

  #check if the vote is valid
  def self.validate_msg(user, room, command, target)
    #to store the output
    output = nil

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
          output = mute_valid(target_user)
        #mute target is invalid so error
        else
          output = mute_invalid_target(user)
        end#if target_user

      #vote command is invalid so error
      else
        output = command_invalid(user)
      end#when "mute"

    #there is an open vote already  
    else
      output = open_vote_exists(user)
    end

    #return the output hash
    output
  end#def self.validate_msg

  #---------------------------------------------
  # PRIVATE CLASS METHODS

  def self.mute_valid(target_user)
    output = {
      :valid => true,
      :message => "Mute Vote Initiated for User: \"#{target_user.username}\", type \"Respond Yes\" or \"Respond No\"",
      :audience_id => nil,
      :target => target_user.id
    }
  end

  def self.mute_invalid_target(current_user)
    output = {
      :valid => false,
      :message => "Your target for a mute vote is invalid, target must be a user in this room, check username",
      :audience_id => current_user.id,
      :target => nil
    }
  end

  def self.command_invalid(current_user)
    output = {
      :valid => false,
      :message => "Your vote command is invalid, vote commands available are \"mute\".",
      :audience_id => current_user.id,
      :target => nil
    }
  end

  def self.open_vote_exists(current_user)
    output = {
      :valid => false,
      :message => "An open vote already exists for this room, please wait until this is closed",
      :audience_id => current_user.id,
      :target => nil
    }
  end

  private_class_method :mute_valid, :mute_invalid_target, :command_invalid, :open_vote_exists
end
