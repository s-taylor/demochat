$(document).ready(function () {

  //find the input box on the page
  var $msgInput = $('#msg-input');

  //fetch the ul element on the page to append messages to
  demoChat.$messagesList = $('ul#messages');

  // when the page loads, get the messages
  demoChat.getMessages();

  // setup our timer to check for new messages
  // demoChat.messageTimer = setInterval(function () {
  //   demoChat.pageUpdate();
  // },3000);

  //add event handler to monitor the input box
  $('#msg-form').on('submit', function (event) {
    // prevent default form submit
    event.preventDefault();
    // grab text from the input box
    var msgText = $msgInput.val();
    //clear the input box
    $msgInput.val('');
    //call the create message function
    demoChat.createMessage(msgText);
  });
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
        data: {lastMsgID: this.lastMsgID}
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

    //ajax request to create a new message
    createMessage: function(msgText) {
      //to refer to parent object
      var self = this;
      //send ajax request to post message content
      $.ajax({
        url: '/messages',
        method: 'POST',
        dataType: 'json',
        data: {message: {text: msgText}}
      }).done(function(response){
        // update the page with all new messages
        self.getMessages();
      });
    },

    //takes a single message object and adds it to the page
    addMessage: function (message) {
      //reformat the date
      var date = moment(message.created_at).calendar();
      //append all messages to the ul
      this.$messagesList.append(['<li>',date,': ',message.username,': ' ,message.text,'</li>'].join(''));
    },

    //delete all messages displayed on the page
    deleteMessages: function() {
      this.$messagesList.empty();
    },

    // pageUpdate: function () {
    //   console.log('checking for messages');
    //   this.deleteMessages();
    //   this.getMessages();
    // }
};