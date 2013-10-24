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
    return 'https://www.youtubeeducation.com/embed/' + youtube_code + '?modestbranding=1&rel=0&fs=1&showinfo=1'
}

function initialize_video_popup(youtube_code,name) {
    $('#video_iframe')[0].src = build_youtube_url(youtube_code);
    $('#video_title').text(name);
    $('#video_player').modal('show');
    return false;
}

function embed_thumbnail_image(data) {
    var thumbnails = data.entry.media$group.media$thumbnail;
    var video_code = data.entry.media$group.yt$videoid.$t;
    if (thumbnails && thumbnails.length > 0) {
        $("#thumbnail_" + video_code).attr('src', thumbnails[0].url);
    }
}

/**
 * Create a custom modal dialog box which takes a configurable options object.
 * Currently supported options include 'header' and 'body', which are DOM
 * elements.
 */
function Dialog(options) {
  var body = options.body;
  var header = options.header;

  var close = $('<a/>').addClass('close')
                       .attr('data-dismiss', 'modal')
                       .text('\u2297');
  this.div = $('<div/>').addClass('modal');
  var modalBody = $('<div/>').addClass('modal-body');
  if (header) {
    var modalHeader = $('<div/>').addClass('modal-header')
                                 .append(close)
                                 .append(header);
    this.div.append(modalHeader);
  } else {
    modalBody.append(close);
  }
  modalBody.append(body);
  this.div.append(modalBody).appendTo('body');
}

Dialog.prototype.show = function() {
  $(this.div).modal('show');
}
Dialog.prototype.hide = function() {
  $(this.div).modal('hide');
}
