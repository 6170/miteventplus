/*# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/*/

$(document).one('ready', function () {
var date = new Date();
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();
var current_start_date = new Date();

//formats date to enter into start and end time fields
//takes in date, returns formatted date
function toFormattedDateString(x){
	m = String(x.getMonth()+1);
	d = String(x.getDate());
        y = String(x.getFullYear());
	if (m.length < 2){ m = '0'+m;}
	if (d.length < 2){ d = '0'+d;}
	answer = m + '/'+d+'/'+y;
	return answer;
    }
    function toFormattedTimeString(x){
	h = x.getHours();
	PM = false;
	if (h > 12) {h = h - 12; PM = true;}
	h = String(h);
	m = String(x.getMinutes());
        s = String(x.getSeconds());
	if (h.length < 2){ h = '0'+h;}
	if (m.length < 2){ m = '0'+m;}
	if (d.length < 2){ d = '0'+d;}
	answer = h + ':'+m+":00 ";
	if (PM) { answer += 'PM';}
	else    { answer += 'AM';}
	return answer;
    }

	//month view calendar instance
	//goes to next tab on success
	var calendar = $('#event_calendar').fullCalendar({
		header: {
			left: 'prev,next today',
			center: 'title',
			right: ''
		},
		selectable: true,
		selectHelper: true,
		select: function(start, end, allDay) { 
			//when a date is selected timeView is opened
			//start and end dates are added to appropriate fields
			//var correct_date = confirm('Are you sure you want your event to start on ' + start.toLocaleDateString() + '?');
			if (true) {
				$('#event_time_tab').click();
				current_start_date = start;
				start_date = toFormattedDateString(start);
				end_date = toFormattedDateString(end);
				$('#start_date_s').val(start_date);
				$('#end_date_s').val(end_date);
				$('#agenda_calendar').fullCalendar('gotoDate',current_start_date);
			}
			
			//fix for resourceView times
			//so only displays whole numbers not ":30"
			htmls = $('.fc-view-resourceDay .fc-widget-header');
			for (var i = 0; i < htmls.length; i++) {
				if ($(htmls[i]).html().search("\:") != -1) {
					$(htmls[i]).html("   ");
				}
			}
			calendar.fullCalendar('unselect');
		},
		events: '/getevents',
		editable: false,
		eventClick: function(event, jsEvent, view) {
		//shows event description on click
			if ($('#showEventModal').length !== 0) {
				$('#showEventModal').remove();
			}
			$('body').append('<div id=\"showEventModal\" class=\"reveal-modal\"><a class=\"close-reveal-modal\">x</a><pre><h2>' + event.title + '\:</h2> <p>' + event.description + '</p></pre></div>');
			$("#showEventModal").reveal();
			return false;
			}
	});
	
	//time view "resourceDay" calendar instance
	//goes to next tab on success
    var agenda_calendar = $('#agenda_calendar').fullCalendar({
		header: {
			left: 'prev,next today',
			center: 'title',
			right: ''
		},
		defaultView: 'resourceDay',
		year: current_start_date.getFullYear(),
        month: current_start_date.getMonth(),
        day: current_start_date.getDay(),
		events: '/getevents',
		selectable: true,
		selectHelper: true,
		select: function(start, end, allDay) { 
			//when a time is selected last tab is opened
			//start and end dates are added to appropriate fields
			//var correct_time = confirm('Are you sure you want your event to \n\nstart at ' + start.toLocaleTimeString() + '\nand end at ' + end.toLocaleTimeString() + '?');
				if (true) {
					$('#event_finalize_tab').click();
				    start_time = toFormattedTimeString(start);
				    end_time = toFormattedTimeString(end);
					$('#start_time_s').val(start_time);
					$('#end_time_s').val(end_time);
			    }
				agenda_calendar.fullCalendar('unselect');
			},
		editable: true,
		firstDay: 1,
		minTime: '7am',
		maxTime:'11:59pm',
		resources: '/getresources',
		refetchResources: true,
		refetchEvents: true,
		columnFormat: {
			month: 'ddd',    // Mon
			resourceDay: 'h(:mm)t' // 7:30p
		},
		eventClick: function(event, jsEvent, view) {
		//shows event description on click
			if ($('#showEventModal').length !== 0) {
				$('#showEventModal').remove();
			}
			$('body').append('<div id=\"showEventModal\" class=\"reveal-modal\"><a class=\"close-reveal-modal\">x</a><pre><h2>' + event.title + '\:</h2> <p>' + event.description + '</p></pre></div>');
			$("#showEventModal").reveal();
			return false;
			}

	});

    $('.event_input_field').focusout(function(){
		var summary_page_id = '#'+$(this).attr("id") + '_s';
		$(summary_page_id).val($(this).val());
    });


    $('.date_tab_button').click(function(){
		$('#event_date_tab').click();
	});

	$('.time_tab_button').click(function(){
		$('#event_time_tab').click();
	 });
	
	$('.finalize_tab_button').click(function(){
		$('#event_finalize_tab').click();
    });
   
  var event_id = $("h1.center").attr("id");
  $(".yelp-search").on('click', function() {
    var search_term = $(".yelp_search_term").val();
    var search_zip = $(".yelp_search_zip").val();
    $(".yelp-search-results").empty();
    $.ajax({
      type: "POST",
      url: "/events/" + event_id + "/yelp_search",
      data: "search_term=" + search_term + "&search_zip=" + search_zip + "&page=1",
      success: $.proxy(function(data) {
      }, this)
    });

    return false;
  });

  var yelp_search_enter = function (e) {
    if (e.which == 13) {
      e.preventDefault();
      var search_term = $(".yelp_search_term").val();
      var search_zip = $(".yelp_search_zip").val();
      $(".yelp-search-results").empty();
      $.ajax({
        type: "POST",
        url: "/events/" + event_id + "/yelp_search",
        data: "search_term=" + search_term + "&search_zip=" + search_zip + "&page=1",
        success: $.proxy(function(data) {
        }, this)
      });
    }
  }

  $(".yelp_search_term").keypress(yelp_search_enter);
  $(".yelp_search_zip").keypress(yelp_search_enter);

  $(".select-restaurant.not-checked").on('click', function() {
    var event_id = $("h1.center").attr("id");
    var id = $(this).attr("id");
    var restaurant_div = $("." + id);
    var name = restaurant_div.find(".business-info").find(".business-name").find("a").text();
    var url = restaurant_div.find(".business-info").find(".business-name").find("a").attr("href");
    var pre_phone = restaurant_div.find(".business-phone").text().trim();
    if (pre_phone.indexOf("phone") != -1) {
      var phone = "";
    } else {
      var phone = pre_phone;
    }

    $.ajax({
      type: "POST",
      url: "/events/" + event_id + "/select_restaurant",
      data: "yelp_id=" + id + "&yelp_name=" + name + "&yelp_url=" + url + "&yelp_phone=" + phone,
      success: $.proxy(function(data) {
        $(this).toggleClass('not-checked checked');
      }, this)
    });
  }); 

  $(".select-restaurant.checked").on('click', function() {
    var event_id = $("h1.center").attr("id");
    var id = $(this).attr("id");
    $.ajax({
      type: "POST",
      url: "/events/" + event_id + "/deselect_restaurant",
      data: "yelp_id=" + id,
      success: $.proxy(function(data) {
        $(this).toggleClass('not-checked checked');
      }, this)
    });
  });

    
});

