class MessagesController < ApplicationController

  #must be logged in to use these functions
  before_filter :authenticate_user!, :only => [:create]

  def create

    #from JSON request we receive
    # params["message"]["text"]
    # params["message"]["room_id"]

    #check if vote using Regex and return result (array)
    vote_array = Vote.check_msg(params["message"]["text"])

    #check if a response using Regex and return result (array)
    response_array = Response.check_msg(params["message"]["text"])

    #------------------------------------------------

    #if the message is a vote (Vote.check_msg != nil)
    if vote_array
      #fetch needed values from the array
      command = vote_array[1]
      target = vote_array[2]

      #find the current room object
      room = Room.find(params["message"]["room_id"])

      #perform vote validation and retrieve output
      result = Vote.validate_msg(room, command, target)

      #if the vote is valid, create it
      if result[:valid]
        Vote.create(
          :category => command,
          :target => result[:target],
          :room_id => room.id,
          :closed => false
        )

        #TO FIX: CREATE A RESPONSE OF YES FOR THIS VOTE FOR CURRENT USER
      end

      #create a system message, provide audience id if private
      if result[:private]
        Message.system_msg(room, result[:message], current_user.id)
      else  
        Message.system_msg(room, result[:message])
      end

      #inform the server of success
      render :json => true

    #------------------------------------------------

    #if the message is a response (Response.check_msg != nil)
    elsif response_array
      
      #get the response
      response = response_array[2].downcase

      #find the current room object
      room = Room.find(params["message"]["room_id"])

      #is there a vote in progress for this room?
      open_vote = room.votes.where('closed is false').first

      #TO FIX: MAKE SURE THE USER CANNOT RESPOND TO THE SAME VOTE TWICE!

      if open_vote
        open_vote.responses.create(:user_id => current_user.id, :choice => true)
        Message.system_msg(room, "Your vote of #{response} has been recorded", current_user.id)
      else
        Message.system_msg(room, "There are no open votes for this room", current_user.id)
      end

      #inform the server of success
      render :json => true

    #------------------------------------------------

    #it's not a vote or response, it's a message
    else

      #create a new message
      message = current_user.messages.new(params[:message])

      if message.save
        render :json => message.to_json
      else
        render :json => false
      end

    end#if vote_array

  end#def create

end#class MessagesController