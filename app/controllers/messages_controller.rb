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

      #finding SYSTEM user
      user = User.where('username = ?','SYSTEM').first

      #create a message against this user
      message = user.messages.new(params[:message])
      message.text = "Vote in progress, type either #{current_task.id}:yes or #{current_task.id}:no"

    elsif (/\d+:yes/.match message.text)
      parts = message.text.split(':')
      vote_id = parts[0]
      Response.create(
        :vote_id => vote_id,
        :user_id => current_user.id,
        :choice => true,
      )

      #finding SYSTEM user
      user = User.where('username = ?','SYSTEM').first

      #create a message against this user
      message = user.messages.new(params[:message])
      message.text = "You voted 'Yes' for Poll #{vote_id}" # customise this
      #make this a private message for the current user
      message.audience_id = current_user.id

    elsif (/\d+:no/.match message.text)
      parts = message.text.split(':')
      vote_id = parts[0]
      Response.create(
        :vote_id => vote_id,
        :user_id => current_user.id,
        :choice => false,
      )

      #finding SYSTEM user
      user = User.where('username = ?','SYSTEM').first

      #create a message against this user
      message = user.messages.new(params[:message])
      message.text = "You voted 'No' for Poll #{vote_id}" # customise this
      #make this a private message for the current user
      message.audience_id = current_user.id

    end

    # binding.pry

    if message.save
      render :json => message.to_json
    else
      render :json => false
    end
  end

end