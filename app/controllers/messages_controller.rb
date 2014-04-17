class MessagesController < ApplicationController

  #must be logged in to use these functions
  before_filter :authenticate_user!, :only => [:create]

  def create

    #from JSON request we receive
    # params["message"]["text"]
    # params["message"]["room_id"]

    #find the current room object
    room = Room.find(params["message"]["room_id"])

    if room.is_muted?(current_user)
      Message.system_msg(room, "You have been Muted and cannot send messages for 1 hour", current_user.id)
      render :json => true
      #prevent running any further code
      return
    end

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

      #perform vote validation and retrieve output
      result = Vote.validate_msg(current_user, room, command, target)

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
          :user_id => current_user.id,
          :choice => true,
        )

        Message.system_msg(room, "Your response of yes has automatically been recorded for your vote", current_user.id)
      end

      #inform the server of success
      render :json => true

    #------------------------------------------------

    #if the message is a response (Response.check_msg != nil)
    elsif response_array
      
      #get the response
      response_text = response_array[2].downcase
      choice = response_text == "yes" ? true : false

      #call the response validation and retrieve output
      result = Response.validate_msg(current_user, room, response_text)

      #if the response is valid, create it
      if result[:valid]
        result[:open_vote].responses.create(:user_id => current_user.id, :choice => choice)
      end
      
      #create a system message for the user
      Message.system_msg(room, result[:message], current_user.id)

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