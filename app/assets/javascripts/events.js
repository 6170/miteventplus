/*# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/*/

$(document).ready(function(){
var date = new Date();
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();
		
var calendar = $('#event_calendar').fullCalendar({
	header: {
		left: 'prev,next today',
		center: 'New Event',
		right: 'month'
	},
	selectable: true,
	selectHelper: true, 
	select: function(start, end, allDay) { //do something here
	    var correct_date = confirm('Are you sure you want your event to start on ' + start.toDateString() + '?');
		if (correct_date) {
		    $('#event_time_tab').click();
		}
		calendar.fullCalendar('unselect');
	},
	editable: false
		});
		
    $('.event_input_field').focusout(function(){
	var summary_page_id = '#'+$(this).attr("id") + '_s';
	$(summary_page_id).val($(this).val());
    });

});
