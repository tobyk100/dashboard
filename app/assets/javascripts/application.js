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

function buildYoutubeUrl(youtubeCode) {
  var url = 'https://www.youtubeeducation.com/embed/' +
             youtubeCode +
             '?modestbranding=1&rel=0&fs=1&showinfo=1';
  return url;
}

function showVideo(youtubeCode, name) {
  var src = buildYoutubeUrl(youtubeCode);
  var header = $('<h3/>').text(name);
  var video = $('<iframe/>').addClass('video-player').attr({
    src: src,
    scrolling: 'no'
  });

  var dialog = new Dialog({ header: header, body: video });
  $(dialog.div).addClass('video-modal');

  dialog.show();
  $('.modal-backdrop').addClass('video-backdrop');  // Hack to fix z-index.
}

function embed_thumbnail_image(data) {
  var thumbnails = data.entry.media$group.media$thumbnail;
  var video_code = data.entry.media$group.yt$videoid.$t;
  if (thumbnails && thumbnails.length > 0) {
      $("#thumbnail_" + video_code).attr('src', thumbnails[0].url);
  }
}

var addClickTouchEvent = function(element, handler) {
  element.on({
    'touchend': handler,
    'click': handler
  });
};

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
  this.div.append(modalBody).appendTo($(document.body));

  addClickTouchEvent(close, $.proxy(function() {
    this.hide();
  }, this));
}

/**
 * Options is configurable with a top and left properties, both are integers.
 */
Dialog.prototype.show = function(options) {
  options = options || {};

  $(this.div).modal('show');

  addClickTouchEvent($(this.div).next(), $.proxy(function() {
    this.hide();
  }, this));

  this.div.offset(options);
}
Dialog.prototype.hide = function() {
  // Hide let's bootstrap cleanup first, then we remove.
  $(this.div).modal('hide');
  $(this.div).remove();
}

$(document).ready(function() {
  $('.video-link').each(function() {
    addClickTouchEvent($(this), $.proxy(function() {
      showVideo($(this).attr('data-code'), $(this).attr('data-name'));
    }, this));
  });
});
