// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require underscore
//= require bootstrap
//= require moment
//= require_tree .

$(document).ready(function () {
  $("form#sign_in_user").bind("ajax:success", function(e, data, status, xhr) {
    // debugger;
    // console.log(data.errors);
    if (data.success) {
      // Update navigation to say "you are logged in as someuser@somesite.com"
      $('#user').html('<p>User signed in:' + data.name + '</p>')
      $('#user').append('<a href="/users/sign_out" data-method="delete">Sign Out</a>');

      var textfield = $("input#user_email");
      console.log(textfield);
      $("#output").addClass("alert alert-success animated fadeInUp").html("Welcome back " + "<span style='text-transform:uppercase'>" + data.name + "</span>");
      // $("#output").removeClass(' alert-danger');
      // debugger;
      $("input").css({
      "height":"0",
      "padding":"0",
      "margin":"0",
      "opacity":"0"
      });
      //change button text 
      $('#render-box').hide();
      $('button.loginbox').hide();
      $('form.new_user').append('<button class="btn btn-success"><a href="/">Continue</a></button>')
      .on('click', function () {
        $.colorbox.close();
      });

      //show avatar
      $(".avatar").css({
          "background-image": "url('http://api.randomuser.me/0.3.2/portraits/women/35.jpg')"
      });
      
    }
    else {
      console.log(data.errors[0]);
      $('h3#error-msg').html(data.errors[0]);
    }
  });
});


// $(document).ready(function () {
//   $(function(){
//   var textfield = $("input[name=user]");
//     $('button.loginbox').click(function() {
//         // e.preventDefault();
//         //little validation just to check username
//         if (textfield.val() != "") {
            
//         } else {
//             //remove success mesage replaced with error message
//             $("#output").removeClass(' alert alert-success');
//             $("#output").addClass("alert alert-danger animated fadeInUp").html("sorry enter a username ");
//         }
//         //console.log(textfield.val());

//     });
//   });

// });