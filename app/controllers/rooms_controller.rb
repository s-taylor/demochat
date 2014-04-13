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
            room = Room.new(params[:room])
            room.save

            redirect_to room_path(room.id)
        end

    end

    def show
        @room = Room.find(params[:id])
    end

end
