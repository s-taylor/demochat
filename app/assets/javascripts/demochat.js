$(document).ready(function () {
  var $msgInput = $('#msg-input');

  demoChat.$messagesList = $('ul#messages');

  // when the page loads, get the messages
  demoChat.getMessages();

  $('#msg-form').on('submit', function (event) {
    // prevent default form submit
    event.preventDefault();
    // grab text from the input box
    var msgText = $msgInput.val();
    //clear the input box
    $msgInput.val('');

    //send ajax request to post message content
    $.ajax({
      url: '/messages',
      method: 'POST',
      dataType: 'json',
      data: {message: {text: msgText}}
    }).done(function(response){
      //add this message to the page
      demoChat.addMessage(response);
    });
  });
});

var demoChat = {
    //to store our messages list ul
    $messagesList: undefined,

    //fetch the messages from the server
    getMessages: function(){
      //to refer to parent object
      var self = this;

      //submit ajax request to fetch all messages
      $.ajax({
        url: '/messages', 
        type: 'GET', 
        dataType: 'json'
      }).done(function(response){
        console.log(response);
        // add the message to the page
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
      });
    },

    //takes a message object and adds it to the page
    addMessage: function (message) {
      //reformat the date
      var date = moment(message.created_at).calendar();
      //append all messages to the ul
      this.$messagesList.append(['<li>',date,': ',message.username,': ' ,message.text,'</li>'].join(''));
    }
};