/*# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/*/

// Drop zone where user can drag and drop files
$(document).bind('dragover', function (e) {
    var dropZone = $('#dropzone')
    dropZone.addClass('hover');
    if (e.target === dropZone[0]) {
        dropZone.addClass('hover');
    } else {
        dropZone.removeClass('hover');
    }
});

$(function () {
  // Initialize the jQuery File Upload widget:
  $('#fileupload').fileupload({
    dropZone: $('#dropzone')
  });
  // 
  // Load existing files:
  $.getJSON($('#fileupload').prop('action'), function (files) {
    var fu = $('#fileupload').data('fileupload'), 
      template;
    fu._adjustMaxNumberOfFiles(-files.length);
    console.log(files);
    template = fu._renderDownload(files)
      .appendTo($('#fileupload .files'));
    // Force reflow:
    fu._reflow = fu._transition && template.length &&
      template[0].offsetWidth;
    template.addClass('in');
    $('#loading').remove();
  });
});

// Initialize Redactor plugin
$(function() {
   var event_id = $(".publicity_email_form").attr('id');
   $('.redactor').redactor({ 
    imageUpload: "/events/" + event_id + "/uploadFromRedactor" + "?" + $('meta[name=csrf-param]').attr('content') + "=" + encodeURIComponent($('meta[name=csrf-token]').attr('content')),
    imageGetJson: "/events/" + event_id + "/images.json",
    imageUploadErrorCallback: callback
   });
});

// Callback if file uploaded to redactor not an image
function callback(obj, json) {
  alert(json.error);
}