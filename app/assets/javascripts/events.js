/*# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/*/

$(document).ready(function(){
var date = new Date();
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();
var current_start_date = new Date();

function toFormattedDateString(x){
	m = String(x.getMonth());
	d = String(x.getDay());
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
	answer = h + ':'+m+':'+d+ " ";
	if (PM) { answer += 'PM';}
	else    { answer += 'AM';}
	return answer;
    }

	var calendar = $('#event_calendar').fullCalendar({
		header: {
			left: 'prev,next today',
			center: 'title',
			right: ''
		},
		selectable: true,
		selectHelper: true,
		select: function(start, end, allDay) { //do something here
			var correct_date = confirm('Are you sure you want your event to start on ' + start.toLocaleDateString() + '?');
			if (correct_date) {
				$('#event_time_tab').click();
				current_start_date = start;
				start_date = toFormattedDateString(start);
				end_date = toFormattedDateString(end);
				$('#start_date_s').val(start_date);
				$('#end_date_s').val(end_date);
			}
			calendar.fullCalendar('destroy');
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
        gotoDate: current_start_date,
		events: '/events/1',
		selectable: true,
		selectHelper: true,
		select: function(start, end, allDay) { //do something here
			var correct_time = confirm('Are you sure you want your event to start at ' + start.toLocaleTimeString() + '?');
				if (correct_time) {
					$('#event_finalize_tab').click();
				    start_time = toFormattedTimeString(start);
				    end_time = toFormattedTimeString(end);
					$('#start_time_s').val(start_time);
					$('#end_time_s').val(end_time);
			    }
				agenda_calendar.fullCalendar('unselect');
			},
		editable: false,
		firstDay: 1,
		minTime: 8,
		maxTime:16,
		resources: [{"name":"Select Time","id":"newevent"}]
	});		
    
    $('.event_input_field').focusout(function(){
		var summary_page_id = '#'+$(this).attr("id") + '_s';
		$(summary_page_id).val($(this).val());
    });
 

    $('#event_time_tab').click(function(){
    	$('#agenda_calendar').fullCalendar('render');
    })

    $('.date_tab_button').click(function(){
	$('#event_date_tab').click();
    });
    $('.time_tab_button').click(function(){
	$('#event_time_tab').click();
    });
    $('.finalize_tab_button').click(function(){
	$('#event_finalize_tab').click();
    });

});
