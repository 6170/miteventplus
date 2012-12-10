$(function(){
  // Validates the new budget item, submits it, adds to DOM,
  // adds to b_map and pie_chart and recomputes percentages
  function submit_new_budget_item(e) {
      if (e.which == 13 && validate_budget_input()) {
        // get the input
        var event_id = $('.new-budget-item').attr('id');
        var title = $('.new-budget-item').val();
        var value = $('.new-budget-item-value').val();
        e.preventDefault();
        $.ajax({
          type: "POST",
          url: "/budget_items",
          data: "title=" + title + "&id=" + event_id + "&value="+ value,
          success: function(data) {
            // clear the budget forms
            $('.new-budget-item').val('');
            $('.new-budget-item-value').val('');
            // build the html for the new item and add it
            var div_start = '<div class="row" id="budget-item-' + data.id + '">'
            var icon_code = '<div class="one column"><i class="general foundicon-minus add dashboard delete_budget" id="' + data.id + '" style="cursor: hand; cursor: pointer;"></i></div>'
            var text_code = '<div class="four columns"><p class="b_item_title" id="' + data.id + '">' + title + '</p></div><div class="one column"><p>+</p></div>'
            var value_code = '<div class="three columns"><p class="b_item_value" id="' + data.id + '">' + accounting.formatMoney(value) + '</p></div>'
            var percentage_code = '<div class= "one column end"><p class="b_item_percentage" id="' + data.id + '"></p></div>'
            var ending = '</div>'
            $(div_start + icon_code + text_code + value_code +percentage_code+ ending).hide().appendTo("#budget-item-container").fadeIn(800);
            // update b_map, recompute percentages and add point to pie_chart
            b_map[data.id] = parseFloat(value);
            recompute_numbers(parseFloat(value),true);
            pie_chart.series[0].addPoint([title,parseFloat(value)],true);
          }
        });
      }
    };
  // Bind all of the different ways to submit
  $(".new-budget-item").keypress(function(e){
    submit_new_budget_item(e);
  });
  $(".new-budget-item-value").keypress(function(e){
    submit_new_budget_item(e);
  });
  $(".add_budget").click(function(){
    var event = jQuery.Event("keypress");
    event.which = 13;
    $(".new-budget-item").trigger(event);
  })

  // Bind the delete button
  $('.delete_budget').live('click',function(e){
        if (confirm('Are you sure you want to delete this item?')){
         // The delete AJAX call
         id = $(this).attr('id');
         $.ajax({
                 type: "DELETE",
                 url: "/budget_items/" + id
               });
         x = '#budget-item-' + id;
         // Remove item from DOM, update pie_chart and b_map, recompute numbers
         $(x).fadeOut(300, function() {
                   $(this).remove();
                   setup_pie_chart_data();
                   pie_chart.series[0].setData(pie_chart_array);
                 });
         recompute_numbers(b_map[id],false);
         delete b_map[id];
        }
      });

  //Initialize the sum and b_map variables, b_map[budget_title_here] = budget_value
  var sum = parseFloat($('#budget_sum').text().substring(1));
  $('#budget_sum').text(accounting.formatMoney($('#budget_sum').text().substring(1)));
  var b_map = {};
  $('.b_item_value').each(function(){
    b_map[$(this).attr('id')]= parseFloat($(this).text().substring(1));
    $(this).text(accounting.formatMoney($(this).text().substring(1)));
  });

  // Recomputes and displays new sum and percentages, code: true => add, false => remove
  function recompute_numbers(new_value, code){
    if (code){
      sum += parseFloat(new_value);
    }
    else{
      sum = sum - parseFloat(new_value);
    }

    $('#budget_sum').text(accounting.formatMoney(sum));
    $('.b_item_percentage').each(function(){
      new_percentage = (100 * b_map[$(this).attr('id')] / sum).toFixed(2);
      $(this).text(String(new_percentage) + '%');
    });
  }
  //Setup intital percentages
  recompute_numbers(0,true);

  //validate the new budget item form
  function validate_budget_input(){
    title = $(".new-budget-item").val();
    value = $(".new-budget-item-value").val();
    // check whether value is a number
    number =  ! isNaN (value-0);
    if (number){
      $(".new-budget-item-value").removeClass("error");
      $("#new-budget-item-prefix").removeClass("error");
      return true
    }
    $(".new-budget-item").focus();
    $(".new-budget-item-value").addClass("error");
    $("#new-budget-item-prefix").addClass("error");
    return false

  }

  // setup the pie_chart array, the budget items info in HighCharts format ex: [['food',25],['transportation',46]]
  function setup_pie_chart_data(){
      pie_chart_array = [];
      $('.b_item_title').each(function(){
        pie_chart_array.push([$(this).text(),b_map[$(this).attr('id')]]);
      });
  }

  //setup pie chart variables
  var pie_chart;
  var pie_chart_array = [];
  // sets up the pie chart and its data
  function setup_pie_chart(){
    setup_pie_chart_data();
    pie_chart = new Highcharts.Chart({
                chart: {
                    renderTo: 'pie_chart',
                    backgroundColor: "#F2F2F2",
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false
                },
                title: {
                    text: 'Your Budget'
                },
                tooltip: {
            	    pointFormat: '{series.name}: <b>{point.percentage}%</b>',
                	percentageDecimals: 1
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true,
                            color: '#000000',
                            connectorColor: '#000000',
                            formatter: function() {
                                return '<b>'+ this.point.name +'</b>: '+ this.percentage.toFixed(2) +' %';
                            }
                        }
                    }
                },
                series: [{
                    type: 'pie',
                    name: 'Browser share',
                    data: pie_chart_array
                }]
            });
  }
  if ($('.content.panel').length != 0) {
    // setup the pie chart when the center panel loads
    $('.content.panel').ready(function(){
      setup_pie_chart();
    });
  }
});


