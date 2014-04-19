#Demochattic App

- - -

###Scope:-

To create a website that allows chatroom functionality via the browser but with a difference. Most chatroom sites / apps require admins to administer each channel / room to kick / ban users, change the topic, promote other admins etc... Admins are usually determined solely by who was the first user to enter the channel. 

So the question we wanted to ask is why can't channels govern themselves? Why is it necessary to have admins at all? Democracy works right?

Our concept is to have democratic chatrooms, where all users in the channel get a say in any and every change anyone may want to make! Whether it's muting a user or changing the topic, you'll have your say!

Another gripe we had with chat channels is that you need to be a user simply to view the chatroom. We wanted to allow guest access to rooms so that users who want to read but not message can do so at their leisure.

Finally we wanted a chatroom with a clean and sleek design. So many of the web based chatrooms have either hideous designs or load some horrid external application within the browser. This certainly does not provide a good user experience!

- - -

###Inspiration

IRC is an obvious inspiration for our app, but it also has it's quirks. When I used to use IRC, I remember several instances of power hungry admins ruling the roost and making channels unfriendly for the user base. It is this that we wanted to address.

- - -

###Object Models:-

Note: excludes relationship table ids

Users (Devise Gem)

* email (user's email address)
* encrypted_password (user's password, encrypted)
* username (user's username)
* last_active (the last time the user was active, as per json ping to server)
* image (user's avatar image)

rooms_users (join table)

* active (unused - intended to be able to disable a relationship without destroying it)

- - -

Rooms

* name (the chatroom name)
* description (unused - intended to store room's topic)
  
Messages

* text (the message content)
* audience_id (used by "SYSTEM" to send a private message to a specific user)

- - -

Votes

* category (the type of vote, only "mute" implemented)
* target (the target of the vote, with a mute vote, this is a user_id)
* closed (if the vote has yet been closed)
* passed (whether the vote was passed, or was unsuccessful)

Responses

* choice (whether the user was in favour (true) or not in favour (false) of the vote)
    
- - -

Tasks

* name
* command
* frequency
* counter


###Relationships

Users >-< Rooms (through rooms_users)
This relationship exists while a user is in a room, and is destroyed after logout or after a period of 1 minute of user inactivity (if the user closes the window)

Rooms -< Messages
The messages associated with the chat room

Room -< Votes -< Responses - User
A vote is associated with the room it was created in. A vote is then responded to by users (A user can only respond once to each vote)

###Gems

Gems for debugging

* gem 'pry-rails'
* gem 'pry-debugger'
* gem 'pry-stack_explorer'
* gem 'better_errors'
* gem 'binding_of_caller'
* gem 'dotenv-rails'

To allow user sign up / logins

* gem 'devise'

To prevent mass assignment to attributes not explicitly allowed

* gem 'protected_attributes'

underscore javascript library (primarily used for looping)

* gem 'underscore-rails'

To annotate our models

* gem 'annotate'

to allow better timestamp formatting

* gem 'momentjs-rails'

supports user logins and image uploads

* gem 'rails_12factor'

allows upload of Profile Avatar images to Heroku from Amazon S3

* gem 'carrierwave'

Interact with a variety of file services #carrierwave handles the fog interaction;

* gem 'fog', "~> 1.3.1"


###API
Amazon S3 and Carrierwave to allow users to upload their own image files

- - -

###Acknowledgements

**Joel Turnbull** - For helping us out with tonnes of questions. Particularly for saving us at the 11th hour regarding server side timers and also not going insane with our devise questions, despite him hating the gem!

**Mathilda Thompson** - For again helping out with our many many questions. In particular helping us with Carrierwave... yet again!

**Tarun Moohkey** - For giving us confidence that we don't need to freak out about using Web Sockets and that AJAX is OK.

- - -