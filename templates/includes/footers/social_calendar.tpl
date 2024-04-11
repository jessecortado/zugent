
<script src="/assets/plugins/bootstrap-daterangepicker/moment.js"></script>
<script src="/assets/plugins/bootstrap-eonasdan-datetimepicker/build/js/bootstrap-datetimepicker.min.js"></script>
<script src="assets/plugins/fullcalendar/fullcalendar.min.js" defer></script>

<script type="text/javascript">

/********* Functions *********/

    function flash_alert(element, msg) {
        $('#alert_error').addClass('hide');
        $(element+' span#msg').text(msg);
        $(element).removeClass('hide');
        $(element).css('opacity', '1');
        $(element).css('display', 'block');
        window.setTimeout(function() {
          $(element).fadeTo(500, 0).slideUp(500, function(){
              // $(this).remove();
              $(element).addClass('hide');
          });
        }, 2000);
    }

	function time_format(datetime) {
		var time = new Date(datetime);
		time = time.toLocaleTimeString('en-US', { hour: 'numeric', minute: 'numeric', hour12: true });
	    return time;
	}

	function am_pm_to_hours(date_with_ampm) {
		var date_ampm = date_with_ampm.split(" ");
		var date = date_ampm[0].split("/");
		var time = date_ampm[1].split(":");
        var hours = Number(time[0]);
        var minutes = Number(time[1]);
        var AMPM = date_ampm[2];
        
        if (AMPM == "PM" && hours < 12) hours = hours + 12;
        if (AMPM == "AM" && hours == 12) hours = hours - 12;
        
        var sHours = hours.toString();
        var sMinutes = minutes.toString();
        if (hours < 10) sHours = "0" + sHours;
        if (minutes < 10) sMinutes = "0" + sMinutes;

        // console.log(date_with_ampm);
        // console.log((date[2]+"-"+date[0]+"-"+date[1]+" "+sHours+':'+sMinutes+':00'));

        return (date[2]+"-"+date[0]+"-"+date[1]+" "+sHours+':'+sMinutes+':00');
    }

	function datepickerFormat(datetime) {
		var date = new Date(datetime),
			year = date.getFullYear(),
			month = ((date.getMonth() + 1)<10?'0'+(date.getMonth() + 1):(date.getMonth() + 1)),
			day = (date.getDate()<10?'0':'') + date.getDate(),
			hours = (date.getHours()<10?'0':'') + date.getHours(),
			minutes = (date.getMinutes()<10?'0':'') + date.getMinutes(),
			seconds = (date.getSeconds()<10?'0':'') + date.getSeconds();

    	return month + "/" + day + "/" + year + " " + hours + ":" + minutes + ":" + seconds;
	}

/********* End-Functions *********/

$(document).ready(function(){
    

    console.log("Calendar ready");

	$('#post-date').datetimepicker({
        minDate: moment().add(1, 'day').toDate()
    });
    
    var date = new Date();
    var currentYear = date.getFullYear();
    var currentMonth = date.getMonth() + 1;
        currentMonth = (currentMonth < 10) ? '0' + currentMonth : currentMonth;

    $('input[value="linkedin"]').on("click", function() {
        if ($("#subject").attr('required')) {
            $("#subject").removeAttr('required');
        } else {
            $("#subject").attr('required', true);
        }
        $(".subject").toggleClass("hide");
    });
    
    var calendar = $('#calendar').fullCalendar({
        timezone: "America/Los_Angeles",
        header: {
            left: 'month,agendaDay',
            center: 'title',
            right: 'prev,today,next '
        },
        droppable: false, // this allows things to be dropped onto the calendar
        drop: function() {
            $(this).remove();
        },
        selectable: true,
        selectHelper: true,
        dayClick: function (date, allDay, jsEvent, view) {

            console.log(date['_d']);
            console.log(date);

            $('#post-date').data("DateTimePicker").date(date);

            $('#post-date').change();
            $('#modal-schedule-post').modal('show');
            $('#calendar').fullCalendar('unselect');
            $("#form-schedule-post").data('form-action', "add");
        },
        editable: false,
        eventLimit: true, // allow "more" link when too many events
        events: 

        [

            {foreach item=row from=$contact_posts}
                {if $smarty.foreach.contact_posts.last}
                {
                    id: "$row.contact_post_id",
                    title: "{$row.body}<br>{$row.first_name} {$row.last_name} ",
                    start: '{$row.date_post|date_format:"%Y-%m-%d %H:%M:%S"}',
                    body: '{$row.contact_f_name} {$row.contact_l_name}'
                }

                {else}

                {
                    title: "{$row.body}",
                    start: '{$row.date_post|date_format:"%Y-%m-%d %H:%M:%S"}',
                    body: '{$row.first_name} {$row.last_name}'
                },
                {/if}
            {/foreach}
        ],

            eventRender: function(event, element) {
                // console.log(event.contact_name); // Writes "1"
                // console.log($(element));
                $(element).children(".fc-content").append("<span class='fc-body' style='display:none;'>"+event.body+"</span>");
                $(element).children(".fc-content").append("<span class='fc-date-post' style='display:none;'>"+new Date(event.start)+"</span>");
            }

    });

	$(document).on("click", '#modal-schedule-post #modal-save',function(){
		$("#form-schedule-post").submit();
	});

	$("#form-schedule-post").on("submit", function(e){
		e.preventDefault();
		var target = $('#form-schedule-post').closest('.panel');
		var action;
		if ($("#form-schedule-post").data('form-action') == 'add') { action = 'add'; }
		else { action = 'edit'; }
		if ( $(this).parsley().isValid() ) {
			$.ajax({
				type: "POST",
				url: '/ws/post/'+action,
				data: $(this).serialize(),
				dataType: "json",
			    beforeSend: function() {
			        if (!$(target).hasClass('panel-loading')) {
			            var targetBody = $(target).find('.panel-body');
			            var spinnerHtml = '<div class="panel-loader"><span class="spinner-small"></span></div>';
			            $(target).addClass('panel-loading');
			            $(targetBody).prepend(spinnerHtml);
			        }
			    },
				success: function(result) {
					console.log(result);
					
                    flash_alert('#alert_success_post', 'Scheduled a post.');

		            $(target).removeClass('panel-loading');
		            $(target).find('.panel-loader').remove();


                    var eventData = {
                        id: result.data,
                        body: $("#body").text(),
                        start: $("#post-date").val()
                    };

                    calendar.fullCalendar( 'renderEvent', eventData , true );

				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				},
			    complete: function() {
			    	$("#modal-schedule-post").modal('hide');
			    }
			});
		}
	});


	$(document).on("dp.change", '#post-date',function(e){
		if ($(this).val() != '') { $('#selected-post-date').val(am_pm_to_hours($(this).val())); }
		else { $('#selected-post-date').val(''); }
	});

    $(document).on("click", ".fc-content", function(){
        $("#post-details").html(
            "Body: " + $(this).children(".fc-body").html() + 
            "<br>Post Date: " + $(this).children('.fc-date-post').html() +
            "<br>Meeting Time: " + $(this).children(".fc-time").html()   );

        console.log($(".fc-time").html() + "<br>" + $(".fc-title").html() );
        $('#modal-view').modal('toggle');
        $(".modal-title").html();
    });

    // $('#modal-view').click(function(){
    //     $('.modal, .inner').hide(); 
    // });                  

    $('#modal-view').click(function(e){
       e.stopPropagation();
    });
});

</script>