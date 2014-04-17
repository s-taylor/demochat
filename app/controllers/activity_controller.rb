class ActivityController < ApplicationController

  def userActive
    current_user.last_active = Time.now.utc

    #convert room id to integer
    room_id = params[:room_id].to_i

    # if a room id was found in the json request (i.e. is not -1)
    if room_id != -1
      #find the room
      room = Room.find(params[:room_id])
      #if the room is not already in the user's current rooms, add it
      current_user.rooms << room unless current_user.rooms.include? room
    else
      # user is not currently in a room so destroy the relationship
      current_user.rooms = []
    end

    #save the user to save new relationships
    current_user.save

    #inform the client this request was successful
    render :json => true

  end

end  