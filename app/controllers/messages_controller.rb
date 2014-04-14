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

end