// Populate mail form with content from previous email
$("#publicity_email_id").on("change", function(){
  var selected = $(this).val();
  $.ajax({
    type: "GET",
    url: "/events/" + $('.publicity_email_form').attr("id") + "/publicity_emails/" + selected,
    success: function(data) {
      $('#publicity_email_subject').val(data["subject"]);
      $('#publicity_email_content').val(data["content"]);
      $('.redactor_editor').children().first().html(data["content"]);
    }
  });
});