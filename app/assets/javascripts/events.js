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
	answer = h + ':'+m+" ";
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
		events: '/events/1',
		editable: false,
		eventClick: function(event, jsEvent, view) {
		//shows event description on click
			//$('body').append('<div id=\"'+event.id+'\" class=\"hover-end\"><span style=\"font-weight:bold\">' + event.title + '\:</span> ' + event.description+'</div>');
			$('body').append('<div id=\"showEventModal\" class=\"reveal-modal\"><a class=\"close-reveal-modal\">x</a><pre><h2>' + event.title + '\:</h2> <p>' + event.description + '</p></pre></div>');
			$("#showEventModal").reveal();
			return false;
			},

		eventMouseout: function(event, jsEvent, view) {
			$('#'+event.id).remove();
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
		events: '/events/1',
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
		resources: '/events/1/resources',
		refetchResources: true,
		refetchEvents: true,
		columnFormat: {
			month: 'ddd',    // Mon
			resourceDay: 'h(:mm)t' // 7:30p
		},
		eventClick: function(event, jsEvent, view) {
		//shows event description on click
			$('.new_time').append('<div id=\"'+event.id+'\" class=\"hover-end\"><span style=\"font-weight:bold\">' + event.title + '\:</span> ' + event.description+'</div>');
		},

		eventMouseout: function(event, jsEvent, view) {
			$('#'+event.id).remove();
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
    
    
});

