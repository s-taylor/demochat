class ActivityController < ApplicationController

  def userActive
    current_user.last_active = Time.now

    room_id = params[:room_id].to_i

    # did we get sent a room id in the json?
    if room_id != -1
      room = Room.find(params[:room_id])
      current_user.rooms << room unless current_user.rooms.include? room
    else
      # user is not currently in a room so destroy the relationship
      current_user.rooms = []
    end

    current_user.save

    #inform the client this request was successful
    render :json => true

  end

end  