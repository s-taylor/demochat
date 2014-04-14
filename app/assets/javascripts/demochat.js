//run this code when the site is loaded
$(document).ready(function () {

  helper.log('Page: New Page Loaded');

  //setup js for a new page
  demoChat.newPage();

  //--------------------------------------------
  // CODE FOR ROOMS
  //--------------------------------------------

  //set the room id
  demoChat.roomID = demoChat.getRoomID();

  //only run this code if the current page is a room
  if (demoChat.roomID !== -1) {
    
    //fetch the ul element on the page to append messages to
    demoChat.$messagesList = $('ul#messages');

    //find the input box on the page (for new message text)
    var $msgInput = $('#msg-input');

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
      var msgText = $msgInput.val();
      //clear the input box
      $msgInput.val('');
      //call the create message function
      demoChat.createMessage(msgText);
    });
  }
});

//------------------------------------------------------
// CHATROOM
//------------------------------------------------------

var demoChat = {
    //to store our messages list ul
    $messagesList: undefined,

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

    //--------------------------------------------------------
    // FETCH MESSAGES AND USERS FOR THE ROOM AND UPDATES PAGE
    //--------------------------------------------------------

    //fetch the messages from the server
    fetchData: function(){
      //to refer to parent object
      var self = this;

      //if a request is already in progress, exit this method (don't run the remaining code)
      if (self.requestInProgress) {
        helper.log("Messages: Fetch aborted, request already in progress");
        return;
      }

      //set request in progress flag to true
      self.requestInProgress = true;

      //TESTING ONLY
      helper.logArray(["Messages: Fetch Messages with id > ",this.lastMsgID]);

      //submit ajax request to fetch all messages
      $.ajax({
        url: '/messages/fetch', 
        type: 'GET', 
        dataType: 'json',
        data: {
          lastMsgID: self.lastMsgID, 
          roomID: self.roomID
        }
      }).done(function(response){
        //log the response to console
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

    displayUsers: function(users) {
      
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
      var date = moment(message.created_at).calendar();
      //append a message to the messages.ul
      this.$messagesList.append(['<li>',date,': ',message.username,': ' ,message.text,'</li>'].join(''));
    },

    //------------------------------------------------------
    // CREATE NEW MESSAGE
    //------------------------------------------------------

    //ajax request to create a new message
    createMessage: function(msgText) {
      //to refer to parent object
      var self = this;
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
    // SEND USER ACTIVE
    //------------------------------------------------------

    //ajax request to create a new message
    userActive: function() {
      //to refer to parent object
      var self = this;
      //log a message
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

    //FOR TESTING ONLY! Deletes all messages and re-feches
    reFetchMessages: function() {
      this.$messagesList.empty();
      this.lastMsgID = 0;
      this.fetchData();
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