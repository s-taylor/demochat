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
      $('#user').html('<p>User signed in:' + data.name + '</p>');
      $('#user').append('<a href="/users/sign_out" data-method="delete">Sign Out</a>');

      
    } else {
      $('h3#error-msg').html(data.errors[0] + '<br>Incorrect email or password.');
    }
  });
});

