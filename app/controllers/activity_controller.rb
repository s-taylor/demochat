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

    #call the update_state task
    update_state

    #inform the client this request was successful
    render :json => true

  end

  private
  def update_state
    close_votes_task = Task.find_by_name 'close_votes'
    users_rooms_task = Task.find_by_name 'users_rooms'

    puts "--------------------------"
    puts "launching update state"
    puts "--------------------------"

    # binding.pry

    if (close_votes_task.updated_at > close_votes_task.frequency.minutes.ago.utc)
      #do nothing
    else
      Vote.check_to_close  
      close_votes_task.counter += 1
      close_votes_task.save
      puts "--------------------------"
      puts "launching close votes task"
      puts "--------------------------"
    end

    if (users_rooms_task.updated_at > users_rooms_task.frequency.minutes.ago.utc)
      #do nothing
    else
      User.check_inactive
      users_rooms_task.counter += 1
      users_rooms_task.save
      puts "-------------------------"
      puts "launching user rooms task"
      puts "-------------------------"
    end


  end

end  