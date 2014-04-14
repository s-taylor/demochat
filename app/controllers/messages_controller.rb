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

    @messages = Message.where("id > ? AND room_id = ?", lastMsgID, roomID)

    response = {}
    @messages.each_with_index do |message,index|
      msg_hash = {}
      msg_hash["id"] = message.id
      msg_hash["text"] = message.text
      msg_hash["date"] = message.created_at
      msg_hash["username"] = message.user.username
      response["message-#{index + 1}"] = msg_hash
    end

    respond_to do |format|
      format.json {render :json => response}
    end
  end

end