/*# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/*/

$(document).ready(function(){
var date = new Date();
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();
var start_date_json;
var end_date_json;
		
var calendar = $('#event_calendar').fullCalendar({
	header: {
		left: 'prev,next today',
		center: 'New Event',
		right: 'month'
	},
	selectable: true,
	selectHelper: true, 
	select: function(start, end, allDay) { //do something here
	    var correct_date = confirm('Are you sure you want your event to start on ' + start.toLocaleDateString() + '?');
		if (correct_date) {
		    $('#event_time_tab').click();
		    start_date_json = start.toJSON();
		    end_date_json = end.toJSON();
		    start_date = start.toLocaleDateString();
		    end_date = end.toLocaleDateString();
		    $('#start_date_s').val(start_date);
                    $('#end_date_s').val(end_date);
		}
		calendar.fullCalendar('unselect');
	},
	editable: false
		});
    var agenda_calendar = $('#agenda_calendar').fullCalendar({
			header: {
				left: 'prev,next today',
				center: 'New Event',
				right: 'agendaDay'
			},
			defaultView: 'agendaDay',
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
			events: []
		});		
    
    $('.event_input_field').focusout(function(){
	var summary_page_id = '#'+$(this).attr("id") + '_s';
	$(summary_page_id).val($(this).val());
    });

});