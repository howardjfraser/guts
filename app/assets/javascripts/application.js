// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).on('page:change', function () {

  // prevent_double_submits();
  prevent_empty_updates()

  $('body').on('click', '.flash', function(e) {
    e.preventDefault();
    // TODO: use CSS animation?
    $(this).fadeToggle('fast');
  });

  $('.ajax-submit').click(function() {
    $('.flash').remove();
  })
});

function prevent_double_submits() {
  $('form').on('submit', function(e) {
    var $form = $(this);
    if ($form.data('submitted') == true) {
      e.preventDefault();
    } else {
      $form.data('submitted', true);
    }
  });
}

function prevent_empty_updates() {
  var submit = $('#new_update :submit');
  submit.prop('disabled', true);

  $('#update_message').keyup(function() {
    var length = $('#update_message').val().length;
    if(length > 0 && submit.prop('disabled') == true) {
      submit.prop('disabled', false);
    }
    if(length == 0 && submit.prop('disabled') == false) {
      submit.prop('disabled', true);
    }
  })
}
