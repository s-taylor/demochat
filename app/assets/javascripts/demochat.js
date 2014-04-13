//this code will run on every new page including following links
$(document).on('ready page:load', function () {

  console.log('Running Document Ready Code');

  //stop any active message fetch timers
  demoChat.stopMessageFetch();
  demoChat.lastMsgID = 0;

  //--------------------------------------------
  // CODE FOR ROOMS
  //--------------------------------------------

  //fetch the ul element on the page to append messages to
  demoChat.$messagesList = $('ul#messages');

  //only run this code if the current page is a room
  if ($('ul#messages').length > 0) {
    //find the input box on the page (for new message text)
    var $msgInput = $('#msg-input');

    //when the page loads, get the messages
    demoChat.getMessages();

    //setup our timer to check for new messages automatically
    demoChat.messageTimer = setInterval(function () {
      demoChat.getMessages();
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

    //store the id of the last message received from the server
    lastMsgID: 0,

    //store the roomID for the current room (this is set by the .html file script tag)
    roomID: undefined,

    //fetch the messages from the server
    getMessages: function(){
      //to refer to parent object
      var self = this;

      //TESTING ONLY
      console.log(["Requesting Messages with id > ",this.lastMsgID].join(''));

      //submit ajax request to fetch all messages
      $.ajax({
        url: '/messages/fetch', 
        type: 'GET', 
        dataType: 'json',
        data: {lastMsgID: self.lastMsgID, roomID: self.roomID}
      }).done(function(response){
        //log the response to console
        console.log(response);
        // add the new messages to the page
        self.displayMessages(response);
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
      var date = moment(message.created_at).calendar();
      //append a message to the messages.ul
      this.$messagesList.append(['<li>',date,': ',message.username,': ' ,message.text,'</li>'].join(''));
    },

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
        self.getMessages();
      });
    },

    stopMessageFetch: function() {
      clearInterval(this.messageTimer);
    },

    //FOR TESTING ONLY! Deletes all messages and re-feches
    reset: function() {
      this.$messagesList.empty();
      this.lastMsgID = 0;
      this.getMessages();
    }
};