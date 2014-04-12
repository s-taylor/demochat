class MessagesController < ApplicationController
  
  def index
    @messages = Message.all

    respond_to do |format|
      format.html
      format.json {render :json => @messages}
    end
  end

  def create
    message = Message.new(params[:message])

    if message.save
      render :json => message.to_json
    else
      render :json => false
    end
  end

end