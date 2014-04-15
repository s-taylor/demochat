class MessagesController < ApplicationController

  #must be logged in to use these functions
  before_filter :authenticate_user!, :only => [:create]

  def create

    message = current_user.messages.new(params[:message])

    # If we see a message that looks like a vote, create a new Vote object for it.
    # We can redo vote detection once we visit Regular Expressions.
    if (/vote/.match message.text)
      parts = message.text.split(',') # vote,kick,nix
      command = parts[0] # vote
      category = parts[1] # kick
      target = User.where(:username => parts[2]) # find the user by username
      
      target.present? && (current_task = Vote.create(
        :category => category,
        :target => target.first.id,
        :room_id => 1 # fix me
      ))
      
      current_task.present? && Response.create(
        :vote_id => current_task.id,
        :user_id => current_user.id,
        :choice => true,
      )

      system_message = Message.new
      system_message.text = "vote in progress, type either #{current_task.id}:yes or #{current_task.id}:no" # customise this
      system_message.user_id = 0 # user ID 0 can be the system user
      system_message.created_at = Time.now
    end

    # for other user
    # to check the msg contains the response(yes or no)
    if (/\d+:yes/.match message.text)
      parts = message.text.split(':')
      vote_id = parts[0]
      Response.create(
        :vote_id => vote_id,
        :user_id => current_user.id,
        :choice => true,
      )

      system_message = Message.new
      system_message.text = "You voted 'Yes' for Poll #{vote_id}" # customise this
      system_message.user_id = 0 # user ID 0 can be the system user
      system_message.created_at = Time.now


    elsif (/\d+:no/.match message.text)
      parts = message.text.split(':')
      vote_id = parts[0]
      Response.create(
        :vote_id => vote_id,
        :user_id => current_user.id,
        :choice => false,
      )

      system_message = Message.new
      system_message.text = "You voted 'No' for Poll #{vote_id}" # customise this
      system_message.user_id = 0 # user ID 0 can be the system user
      system_message.created_at = Time.now
    end


    if system_message.present?
      render :json => system_message.to_json
    elsif message.save
      render :json => message.to_json
    else
      render :json => false
    end
  end

  #to handle json requests for message data
  def fetch

    # binding.pry

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