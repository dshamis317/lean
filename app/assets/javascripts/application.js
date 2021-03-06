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
//= require jquery.ui.all
//= require jquery.mambo
//= require d3
//= require jquery.easy-ticker
//= require turbolinks
//= require_tree .

$(function() {
  visualInitializers();

  $('.search').submit(function(e) {
    e.preventDefault();
    clearPageData();
    var userText = $('.search_field').val();
    var topicID = $('.topics').val();
    $('#term').append(userText);
    $('#topic').append($('.topics option:selected').text());
    $('.user_search_title').fadeIn();
    getSearchData(userText, topicID);
  })

  automatedSearches();

  getTickerInfo();
})

$( document ).tooltip();
