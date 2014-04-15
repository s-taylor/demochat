# Seed files
User.destroy_all
Room.destroy_all
Message.destroy_all
Vote.destroy_all
Response.destroy_all

# user's seed file
user = User.new(:username => 'testuser1', :email => 'user1@user.com', :password => 'abcd1234', :password_confirmation => 'abcd1234')
user.save
user2 = User.new(:username => 'testuser2', :email => 'user2@user.com', :password => 'abcd1234', :password_confirmation => 'abcd1234')
user2.save
user3 = User.new(:username => 'testuser3', :email => 'user3@user.com', :password => 'abcd1234', :password_confirmation => 'abcd1234')
user3.save
user4 = User.new(:username => 'testuser4', :email => 'user4@user.com', :password => 'abcd1234', :password_confirmation => 'abcd1234')
user4.save
system = User.new(:username => 'SYSTEM', :email => 'system@user.com', :password => 'abcd1234', :password_confirmation => 'abcd1234')
system.save


# room's seed file
room = user.rooms.new(:name => "SimonsRoom", :description => 'first ever room')
room.save
room2 = user.rooms.new(:name => "NixsRoom", :description => 'second room')
room2.save
room3 = user.rooms.new(:name => "MarksRoom", :description => 'third room')
room3.save


# message's seed file
message = room.messages.new(:text => "new message in Simon's room")
message.user_id = user.id
message.save

message2 = room.messages.new(:text => "second message in Simon's room?")
message2.user_id = user.id
message2.save


# vote's seed file
# vote = room.votes.new(:category => "kick", :room_id => room.id)
# vote.save
# vote2 = room2.votes.new(:category => "kick", :room_id => room.id)
# vote2.save