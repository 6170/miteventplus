/*# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/*/

$(document).ready(function(){
var date = new Date();
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();
var current_start_date = new Date();
		
	var calendar = $('#event_calendar').fullCalendar({
		header: {
			left: 'prev,next today',
			center: 'New Event',
			right: ''
		},
		selectable: true,
		selectHelper: true,
		select: function(start, end, allDay) { //do something here
			var correct_date = confirm('Are you sure you want your event to start on ' + start.toLocaleDateString() + '?');
			if (correct_date) {
				$('#event_time_tab').click();
				current_start_date = start;
				start_date = start.toLocaleDateString();
				end_date = end.toLocaleDateString();
				$('#start_date_s').val(start_date);
						$('#end_date_s').val(end_date);
			}
			calendar.fullCalendar('unselect');
		},
		events: '/events/1',
		editable: false
	});
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
		events: '/events/1',
		selectable: true,
		selectHelper: true,
		select: function(start, end, allDay) { //do something here
			var correct_time = confirm('Are you sure you want your event to start at ' + start.toLocaleTimeString() + '?');
				if (correct_time) {
					$('#event_finalize_tab').click();
					start_time = start.toLocaleTimeString();
					end_time = end.toLocaleTimeString();
					$('#start_time_s').val(start_time);
					$('#end_time_s').val(end_time);
			    }
				agenda_calendar.fullCalendar('unselect');
			},
		editable: false,
		firstDay: 1,
		minTime: 8,
		maxTime:16,
		resources: [{"name":"New Event","id":"resource2"}]
	});		
    
    $('.event_input_field').focusout(function(){
		var summary_page_id = '#'+$(this).attr("id") + '_s';
		$(summary_page_id).val($(this).val());
    });
    
});
