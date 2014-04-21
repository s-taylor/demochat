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

  #check if message text is a response and return response components as Regex
  def self.check_msg(text)
    #return [2] = yes/no (or Yes/No)
    vote_text = /([Rr]espond|[Rr]esponse) ([Yy]es|[Nn]o)/.match text
  end

  #validate the response and if valid, create it
  def self.message_to_response(user, room, response_text)

    #call the response validation and retrieve output
    result = Response.validate_msg(user, room, response_text)

    #convert response text to a true or false
    choice = response_text.downcase == "yes" ? true : false

    #if the response is valid, create it
    if result[:valid]
      result[:open_vote].responses.create(:user_id => user.id, :choice => choice)
    end
    
    #create a system message for the user
    Message.system_msg(room, result[:message], user.id)
  end

  #check if the response is valid
  def self.validate_msg(current_user, room, response_text)
    #to store the output
    output = nil
    
    #find the open vote for this room (there should only ever be one)
    open_vote = room.votes.where('closed is false').first

    #if an open vote was found
    if open_vote
      #check if this user has already voted
      user_response = open_vote.responses.where('user_id = ?',current_user.id).first

      #user has not already responsed so response OK
      unless user_response
        output = response_valid(current_user, response_text)
      #user has already responded so error
      else
        output = already_responded(current_user)
      end

    #there are no open votes to respond to
    else
      output = no_open_votes(current_user)
    end

    #add the current user_id to the output
    output[:audience_id] = current_user.id
    output[:open_vote] = open_vote

    #return the output
    output
  end

  #---------------------------------------------
  # PRIVATE CLASS METHODS
  def self.response_valid(current_user, response_text)
    output = {
      :valid => true,
      :message => "Your response of #{response_text} has been recorded"
    }
  end

  def self.already_responded(current_user)
    output = {
      :valid => false,
      :message => "You have already responded to this vote... Jerk!"
    }
  end

  def self.no_open_votes(current_user)
    output = {
      :valid => false,
      :message => "There are no open votes to respond to"
    }
  end

  private_class_method :response_valid, :already_responded, :no_open_votes
end
