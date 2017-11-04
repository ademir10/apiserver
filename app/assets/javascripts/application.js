// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//=require jquery.turbolinks
//= require jquery-ui
//= require twitter/bootstrap
//= require autocomplete-rails
//= require turbolinks
//= require rails-ujs
//= require sweetalert2
//= require sweet-alert2-rails

//= require maskedinput
//= require masks
//= require_tree .

var sweetAlertConfirmConfig = {
  title: 'Are you sure?',
  type: 'warning',
  showCancelButton: true,
  cancelButtonColor: "#DD6B55",
  confirmButtonColor: "#DD6B55",
  confirmButtonText: "Sim",
  cancelButtonText: "Cancelar",
};
