class RoomsController < ApplicationController

    def index
        @rooms = Room.all

        @room = Room.new
    end

    def create
        input = params[:room].values.first
        binding.pry
        checker = Room.where(:name => input).first.name

        binding.pry
        if input == checker
            binding.pry
        else
            room = Room.new(params[:room])
            room.save

            redirect_to root_path
        end
    end

    def show
        @room_id = params[:id]
    end

end
