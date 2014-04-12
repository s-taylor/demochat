$(document).ready(function () {
  var $msgform = $('#msgform');
  demoChat.$messagesList = $('ul');

  // when the page loads, get the messages
  demoChat.getMessages();

  $msgform.on('click','button',function (event) {
    // test
    console.log("click detected");
    // prevent default form submit
    event.preventDefault();
    // grab text from the input box
    var msgText = $msgform.find('input').val();
    $msgform.find('input').val('');

    $.ajax({
      url: '/messages',
      method: 'POST',
      dataType: 'json',
      data: {message: {text: msgText}}
    }).done(function(response){
      console.log("message created",response);
    });
  });
});

var demoChat = {
    //to store our messages list ul
    $messagesList: undefined,

    //fetch the messages from the server
    getMessages: function(){
      var self = this
      $.ajax({
        url: '/messages', 
        type: 'GET', 
        dataType: 'json'
      }).done(function(response){
        // console.log(response);
        self.displayMessages(response);
      });
    },

    //update the page to display the messages
    displayMessages: function(messages) {
      var self = this
      _.each(messages, function (message) {
        console.log(message);
        var date = moment(message.created_at).calendar();
        self.$messagesList.append(['<li>',date,': ',message.text,'</li>'].join(''));
      });
    }
};