//run this code when the site is loaded
$(document).ready(function () {

  //Log that page load code is being run
  helper.log('Page: New Page Loaded');

  //setup js for a new page
  demoChat.newPage();

  //setup dynatable
  $("#top-rooms").dynatable();

  //--------------------------------------------------
  // CODE FOR ROOMS (ONLY APPLICABLE TO ROOMS - SHOW)
  //--------------------------------------------------

  //set the room id
  demoChat.roomID = demoChat.getRoomID();

  //only run this code if the current page is a room
  if (demoChat.roomID !== -1) {

    //change the default underscore template settings
    _.templateSettings = {
      interpolate: /\{\{\=(.+?)\}\}/g,
      evaluate: /\{\{(.+?)\}\}/g
    };

    // fetch the html for our template from the index page
    var message_html = $('#message_template').html();
    demoChat.messageTemp = _.template(message_html);

    // fetch the html for our template from the index page
    var user_html = $('#user_template').html();
    demoChat.userTemp = _.template(user_html);
    
    //fetch the ul element on the page to append messages to
    demoChat.$userList = $('ul#users');

    //fetch the ul element on the page to append messages to
    demoChat.$messagesList = $('ul#messages');

    //find the input box on the page (for new message text)
    demoChat.$msgInput = $('#msg-input');

    //when the page loads, get the messages
    demoChat.fetchData();

    //setup our timer to check for new messages automatically
    demoChat.messageTimer = setInterval(function () {
      demoChat.fetchData();
    },3000);

    //add event handler to monitor the input box
    $('#msg-form').on('submit', function (event) {
      //prevent default form submit
      event.preventDefault();
      //grab text from the input box
      var msgText = demoChat.$msgInput.val();
      //clear the input box
      demoChat.$msgInput.val('');
      //update the countdown (will reset back to 512)
      demoChat.updateCountdown();
      //call the create message function
      demoChat.createMessage(msgText);
    });

    //find the countdown text display
    demoChat.$countdown = $('.countdown')
    //add event handler for keypress on event handler
    demoChat.updateCountdown();
    //listen for keypresses on the update countdown
    demoChat.$msgInput.keydown(function () {
      demoChat.updateCountdown()
    });

  }
});

//------------------------------------------------------
// CHATROOM
//------------------------------------------------------

var demoChat = {
  //to store our user list ul
  $userList: undefined,

  //to store our messages list ul
  $messagesList: undefined,

  //to track the message input box
  $messageInput: undefined,

  //timer to periodically check for new messages
  messageTimer: undefined,

  //timer to inform the server that user is active
  activityTimer: undefined,

  //store the id of the last message received from the server
  lastMsgID: 0,

  //store the roomID for the current room
  roomID: -1,

  //to store the current state of fetching requests (true = currently fetching messages)
  requestInProgress: false,

  //to store our message template function
  messageTemp: undefined,

  //to store our user template function
  userTemp: undefined,

  //user signed in (set in application.html.erb script tag)
  signedIn: false,

  //characters remaining in message
  remaining: 512,

  //--------------------------------------------------------
  // FETCH MESSAGES AND USERS FOR THE ROOM AND UPDATES PAGE
  //--------------------------------------------------------

  //fetch the messages from the server
  fetchData: function(){
    //to refer to parent object
    var self = this;

    //if a request is already in progress, exit this method (don't run the remaining code)
    if (self.requestInProgress) {
      //Log that message fetch is being aborted
      helper.log("Messages: Fetch aborted, request already in progress");
      return;
    }

    //set request in progress flag to true
    self.requestInProgress = true;

    //Log which messages are being fetched
    helper.logArray(["Messages: Fetch Messages with id > ",this.lastMsgID]);

    //submit ajax request to fetch all messages
    $.ajax({
      url: ['/rooms/',self.roomID,'/fetch'].join(''), 
      type: 'GET', 
      dataType: 'json',
      data: {
        lastMsgID: self.lastMsgID, 
        // roomID: self.roomID
      }
    }).done(function(response){
      //Log the retrieved messages to console
      helper.log(response);
      // add the new messages to the page
      self.displayMessages(response.messages);
      // add the users to the page
      self.displayUsers(response.users);

    }).always(function() {
      //ajax request completed, set requeset in progress to false
      self.requestInProgress = false;
    });
  },

  //update the page to display the users
  displayUsers: function(users) {
    //to refer to parent object
    var self = this;
    //empty the users list
    self.$userList.empty();
    //loop through all users
    _.each(users, function (user) {
      // add the message to the page
      self.$userList.append(self.userTemp(user));
    });
  },

  //update the page to display the messages
  displayMessages: function(messages) {
    //to refer to parent object
    var self = this;
    //loop through all messages
    _.each(messages, function (message) {
      // add the message to the page
      self.addMessage(message);
      //update the lastMsgID
      if (message.id > self.lastMsgID) {self.lastMsgID = message.id;}
    });
  },

  //takes a single message object and adds it to the page
  addMessage: function (message) {
    //reformat the date using moment.js
    message.date = moment(message.date).format('D MMM - h:mma');
    //append a message to the messages.ul using the messages template
    this.$messagesList.append(this.messageTemp(message));
  },

  //------------------------------------------------------
  // CREATE NEW MESSAGE
  //------------------------------------------------------

  //ajax request to create a new message
  createMessage: function(msgText) {
    //to refer to parent object
    var self = this;
    //Log that a new message is being created
    helper.logArray(["Messages: Creating new Message '",msgText,"' for Room ID ",self.roomID])
    //send ajax request to post message content
    $.ajax({
      url: '/messages',
      method: 'POST',
      dataType: 'json',
      data: {
        message: {
          text: msgText, 
          room_id: self.roomID 
        }
      }
    }).done(function(){
      // update the page with all new messages
      self.fetchData();
    });
  },

  //------------------------------------------------------
  // USER ACTIVITY
  //------------------------------------------------------

  startUserActiveTimer: function () {
    var self = this;

    //send a single user active request
    self.userActive();
  
    //start user activity timer (runs every 60 seconds)
    self.activityTimer = setInterval(function () {
      self.userActive();
    },60000);
  },

  //ajax request to create a new message
  userActive: function() {
    //to refer to parent object
    var self = this;
    //Log that user activity json post has been made
    helper.logArray(["User Activity: I'm still here! I'm in Room ",self.roomID]);
    //send ajax request to post message content
    $.ajax({
      url: '/activity/user_active',
      method: 'POST',
      dataType: 'json',
      data: {
        //tell the server which room you are in
        room_id: self.roomID
      }
    });
  },

  updateCountdown: function() {
    //to refer to parent object
    var self = this;
    //set remaining = 512 - get the current length of input box
    self.remaining = 512 - demoChat.$msgInput.val().length;
    //update text on page
    self.$countdown.text(self.remaining + ' characters remaining.');
  },

  //------------------------------------------------------
  // OTHER CODE
  //------------------------------------------------------

  //code to run each time a new page is visited
  newPage: function() {
    //stop any active message fetch timers
    clearInterval(this.messageTimer);
    //reset the last message id to zero so all messages can be refetched
    demoChat.lastMsgID = 0;
  },

  //fetch the current room id
  getRoomID: function() {
    var path = helper.getPath();
    if(path[0] === 'rooms') {
      return path[1];
    } else {
      return -1;
    }
  },

  //------------------------------------------------------
  // TESTING ONLY
  //------------------------------------------------------
  //stop fetching messages from the server
  stopFetch: function() {
    clearInterval(demoChat.messageTimer);
  }

};

//------------------------------------------------------
// HELPER FUNCTIONS (GENERIC PURPOSE)
//------------------------------------------------------
var helper = {
  //setup logging of messages
  logging: true,

  //log a message to console IF logging true (must pass an array!)
  log: function(text) {
    if (this.logging === true) {
      console.log(text);  
    }
  },

  logArray: function(textArray) {
    if (this.logging === true) {
      console.log(textArray.join(''));  
    }
  },

  //returns the current path as an array split by "/"
  getPath: function() {
    //fetch the full path
    var fullPath = window.location.pathname;
    //ignore the first "/"
    fullPathTrim = fullPath.substr(1,fullPath.length);
    //return an array containing each component of the path
    return fullPathTrim.split("/");
  }
};