class RoomsController < ApplicationController

    def index
        @rooms = Room.all

        @room = Room.new
    end

    def create
        # binding.pry
        room = Room.new(params[:room])
        room.save

        redirect_to root_path
    end

    def show
        @room_id = params[:id]
    end

end
