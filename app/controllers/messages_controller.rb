class MessagesController < ApplicationController

  #must be logged in to use these functions
  before_filter :authenticate_user!, :only => [:create]

  def create

    #find the current room object
    room = Room.find(params["message"]["room_id"])

    if room.is_muted?(current_user)
      #create a private system message to inform the user they are muted
      Message.system_msg(room, "You have been Muted and cannot send messages for 1 hour", current_user.id)
      #inform json request of success
      render :json => true
      #prevent running any further code
      return
    end

    #check if vote using Regex and return result (array)
    vote_array = Vote.check_msg(params["message"]["text"])

    #check if a response using Regex and return result (array)
    response_array = Response.check_msg(params["message"]["text"]) unless vote_array

    #------------------------------------------------

    #if the message is a vote (Vote.check_msg != nil)
    if vote_array

      #create a new vote and associated response
      # vote_array[1] = command, vote_array[2] = target
      Vote.message_to_vote(current_user, room, vote_array[1], vote_array[2])

      #inform the server of success
      render :json => true

    #------------------------------------------------

    #if the message is a response (Response.check_msg != nil)
    elsif response_array
      
      #create a response for the open vote
      #response_array[2] = yes / no
      Response.message_to_response(current_user, room, response_array[2])

      #inform the server of success
      render :json => true

    #------------------------------------------------

    #it's not a vote or response, it's a message
    else

      #html escape the message content
      params[:message][:text] = CGI::escapeHTML(params[:message][:text])

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