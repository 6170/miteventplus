$(function(){
  $(".checked, .unchecked").live('click', function() {
    if ($(this).attr('id') != "home-check") {
      $.ajax({
        type: "POST",
        url: "/checklist_items/" + $(this).attr("id") + "/toggle_checked",
        success: $.proxy(function() {
          $(this).toggleClass("foundicon-checkmark foundicon-remove").toggleClass("checked unchecked");
          $(this).next().toggleClass("strikethrough bold");
        }, this)
      });
    }
  });

  $(".new-checklist-item").keypress(function(e) {
    if (e.which == 13) {
      var event_id = $(this).attr('id');
      var text = $(this).val();
      e.preventDefault();
      $.ajax({
        type: "POST",
        url: "/checklist_items",
        data: "text=" + text + "&event_id=" + event_id,
        success: $.proxy(function(data) {
          $(this).val('');
          var div_start = '<div id="checklist-item-' + data.id + '" style="padding-left:10px;">';
          var icon_code = '<i class="general foundicon-remove unchecked" id="' + data.id + '"></i>';
          var text_code = '<span class="bold"><span class="edit" id="' + data.id + '">&nbsp;' + text + '</span></span>';
          var delete_button = '<span class="right-align"><a href="#" class="delete-checklist-item" id="' + data.id + '" data-confirm="Are you sure you want to delete this checklist item?">Delete</a></span>';
          var ending = '<br></div>';
          $(div_start + icon_code + text_code + delete_button + ending).hide().appendTo("#existing-checklist-items-" + event_id).fadeIn(800);
          $(".editableitem").editable("/checklist_items/edit_text");
        }, this)
      });
    }
  });

  $(".delete-checklist-item").live('click', function() {
    var checklist_id = $(this).attr('id');
    $.ajax({
      type: "DELETE",
      url: "/checklist_items/" + checklist_id,
      success: $.proxy(function() {
        $("#checklist-item-" + checklist_id).fadeOut(300, function() {
          $(this).remove();
        })
      }, this)
    });

    return false;
  });

  $("div[id|='checklist-item']").live({
    mouseenter:
      function() {
        $("a.delete-checklist-item", this).show();
        $(this).css("background", '#e0e0e0');
      },
    mouseleave:
      function() {
        $("a.delete-checklist-item", this).hide();
        $(this).css("background", 'transparent');
      }
  });

  if ($('.editableitem').length != 0)
    $(".editableitem").editable("/checklist_items/edit_text");

  $(".new-tag").keypress(function(e) {
    if (e.which == 13) {
      var text = $(this).val();
      e.preventDefault();
      $.ajax({
        type: "POST",
        url: "/tags",
        data: "name=" + text,
        success: $.proxy(function(data) {
          $(this).val('');
          var div_start = '<div id="tag-' + data.id + '"" style="padding:5px;">';
          var icon_code = '<i class="general foundicon-star"></i>';
          var text_code = '<span class="bold">&nbsp;' + text + '</span>';
          var delete_button = '<span class="right-align"><a href="#" class="delete-tag" id="' + data.id + '" data-confirm="Are you sure you want to delete this tag?">Delete</a></span>';
          var ending = '<br></div>';

          $(div_start + icon_code + text_code + delete_button + ending).hide().appendTo("#existing-tags").fadeIn(800);
        }, this)
      });
    }
  });

  $(".delete-tag").live('click', function() {
    var tag_id = $(this).attr('id');
    $.ajax({
      type: "DELETE",
      url: "/tags/" + tag_id,
      success: $.proxy(function() {
        $("#tag-" + tag_id).fadeOut(300, function() {
          $(this).remove();
        })
      }, this)
    });
    return false;
  });

  $("div[id|='tag']").live({
    mouseenter:
      function() {
        $("a.delete-tag", this).show();
        $(this).css("background", '#e0e0e0');
      },
    mouseleave:
      function() {
        $("a.delete-tag", this).hide();
        $(this).css("background", 'transparent');
      }
  });
});