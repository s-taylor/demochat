class HomeController < ApplicationController

  def index
    @rooms = Room.all
    @room = Room.new
  end
  
end
