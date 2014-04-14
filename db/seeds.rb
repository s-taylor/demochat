# Seed files
User.destroy_all
Room.destroy_all
Message.destroy_all

# user's seed file
user = User.new(:username => 'user1', :email => 'user1@user.com', :password => 'abcd1234', :password_confirmation => 'abcd1234')
user.save
user2 = User.new(:username => 'user2', :email => 'user2@user.com', :password => 'abcd1234', :password_confirmation => 'abcd1234')
user2.save
user3 = User.new(:username => 'user3', :email => 'user3@user.com', :password => 'abcd1234', :password_confirmation => 'abcd1234')
user3.save
user4 = User.new(:username => 'user4', :email => 'user4@user.com', :password => 'abcd1234', :password_confirmation => 'abcd1234')
user4.save


# room's seed file
room = user.rooms.new(:name => "Simon's room", :description => 'first ever room')
room.save
room2 = user.rooms.new(:name => "Nix's room", :description => 'second room')
room2.save
room3 = user.rooms.new(:name => "Mark's room", :description => 'third room')
room3.save


# message's seed file
message = room.messages.new(:text => "new message in Simon's room")
message.user_id = user.id
message.save

message2 = room.messages.new(:text => "second message in Simon's room?")
message2.user_id = user.id
message2.save


# vote's seed file
vote = room.votes.new(:category => "kick", :room_id => room.id)
vote.save
vote2 = room2.votes.new(:category => "kick", :room_id => room.id)
vote2.save