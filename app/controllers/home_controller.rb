class HomeController < ApplicationController
  def home
    
  end

  def index
    @rooms = Room.all
    @room = Room.new
  end
end
