# Seed files
User.destroy_all
Room.destroy_all
Message.destroy_all

# user's seed file
user = User.new(:username => 'user1', :email => 'user1@user.com', :password => 'abcd1234', :password_confirmation => 'abcd1234')
user.save


# room's seed file
room = user.rooms.new(:name => "Simon's room", :description => 'first ever room')
room.save


# message's seed file
message = room.messages.new(:text => 'new message')
message.user_id = user.id
message.save