class MessagesController < ApplicationController

  #must be logged in to use these functions
  before_filter :authenticate_user!, :only => [:create]

  def create

    message = current_user.messages.new(params[:message])

    if message.save
      render :json => message.to_json
    else
      render :json => false
    end
  end

  #to handle json requests for message data
  def fetch

    lastMsgID = params["lastMsgID"]
    roomID = params["roomID"]

    #find the messages required
    @messages = Message.where("id > ? AND room_id = ?", lastMsgID, roomID)

    #setup a response hash
    response = {}

    #setup a messages array within the response hash
    response["messages"] = []

    @messages.each do |message|

      #create a message hash for the current message
      msg_hash = {}
      msg_hash["id"] = message.id
      msg_hash["text"] = message.text
      msg_hash["date"] = message.created_at
      msg_hash["username"] = message.user.username

      #add the message to the response hash
      response["messages"] << msg_hash

    end

    @users = Room.find(roomID).users

    #setup a users array within the response hash
    response["users"] = []    

    @users.each do |user|
      response["users"] << user.username      
    end

    #send response to client
    respond_to do |format|
      format.json {render :json => response}
    end
  end

end