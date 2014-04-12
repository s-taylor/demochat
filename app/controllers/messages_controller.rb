class MessagesController < ApplicationController
  
  def index
    @messages = Message.all

    response = {}
    @messages.each_with_index do |message,index|
      msg_hash = {}
      msg_hash["text"] = message.text
      msg_hash["date"] = message.created_at
      msg_hash["username"] = message.user.username
      response["message-#{index + 1}"] = msg_hash
    end

    respond_to do |format|
      format.html
      format.json {render :json => response}
    end
  end

  def create
    message = current_user.messages.new(params[:message])

    msg_hash = {}
    msg_hash["text"] = message.text
    msg_hash["date"] = message.created_at
    msg_hash["username"] = message.user.username

    if message.save
      render :json => msg_hash.to_json
    else
      render :json => false
    end
  end

end