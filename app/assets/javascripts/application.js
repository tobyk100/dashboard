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
//= require_tree .
// Loads all Bootstrap javascripts
//= require bootstrap

function build_youtube_url(youtube_code) {
    return 'http://www.youtubeeducation.com/embed/' + youtube_code + '?modestbranding=1&rel=0&fs=1&showinfo=1'
}

function initialize_video_popup(youtube_code,name) {
    $('#video_iframe')[0].src = build_youtube_url(youtube_code);
    $('#video_title').text(name);
    $('#video_player').modal('show');
    return false;
}

function close_video_popup() {
    $('#video_iframe')[0].src = null;
    $('#video_player').modal('hide');
    return false;
}
