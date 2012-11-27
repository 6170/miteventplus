// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require_tree .
//= require_tree ../fullcalendar

$(document).ready(function() {
	$("#loginModalButton").click(function() {
		$("#loginModal").reveal();
	});

	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth();
	var y = date.getFullYear();

	$('#calendar').fullCalendar({
		editable: true,
		events: [
		  {
		    title: 'All Day Event',
		    start: new Date(y, m, 1)
		  },
		  {
		    title: 'Long Event',
		    start: new Date(y, m, d-5),
		    end: new Date(y, m, d-2)
		  },
		  {
		    id: 999,
		    title: 'Repeating Event',
		    start: new Date(y, m, d-3, 16, 0),
		    allDay: false
		  },
		  {
		    id: 999,
		    title: 'Repeating Event',
		    start: new Date(y, m, d+4, 16, 0),
		    allDay: false
		  },
		  {
		    title: 'Meeting',
		    start: new Date(y, m, d, 10, 30),
		    allDay: false
		  },
		  {
		    title: 'Lunch',
		    start: new Date(y, m, d, 12, 0),
		    end: new Date(y, m, d, 14, 0),
		    allDay: false
		  },
		  {
		    title: 'Birthday Party',
		    start: new Date(y, m, d+1, 19, 0),
		    end: new Date(y, m, d+1, 22, 30),
		    allDay: false
		  },
		  {
		    title: 'Click for Google',
		    start: new Date(y, m, 28),
		    end: new Date(y, m, 29),
		    url: 'http://google.com/'
		  }
		]
	});
});
