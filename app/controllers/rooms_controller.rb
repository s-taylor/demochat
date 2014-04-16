class RoomsController < ApplicationController

  def index
    @rooms = Room.all

    @room = Room.new
  end

  def create
    input = params[:room]["name"]
    #CHANGE THIS TO A LIKE MATCH (IGNORE CASE)
    room = Room.where(:name => input).first

    if room != nil
      redirect_to room_path(room.id)
    else
      @room = Room.new(params[:room])
      @room.save
      if @room.save
        redirect_to @room
      else
        @rooms = Room.all
        render :template => "home/index"  
      end
    end#end of if
  end#end of create

  def show
    @room = Room.find(params[:id])
  end

  #to handle json requests for messages and users for the current room
  def fetch

    lastMsgID = params[:lastMsgID]
    roomID = params[:id]

    #setup a response hash
    response = {}

    #find the messages required (include private messages if the user is signed in)
    if user_signed_in?
      @messages = Message.where("id > ? AND room_id = ? AND (audience_id is null OR audience_id = ?)", lastMsgID, roomID, current_user.id)
    else
      @messages = Message.where("id > ? AND room_id = ? AND audience_id is null", lastMsgID, roomID)
    end

    #reformat all messages 
    response["messages"] = @messages.map { |message| message.json_format }

    #find all of the users for this room (returning username ONLY)
    response["users"] = Room.find(roomID).users.pluck(:username)

    #send response to client
    respond_to do |format|
      format.json {render :json => response}
    end
  end

end
