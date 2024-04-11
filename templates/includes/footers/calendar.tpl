
<script src="/assets/plugins/bootstrap-daterangepicker/moment.js"></script>
<script src="/assets/plugins/bootstrap-eonasdan-datetimepicker/build/js/bootstrap-datetimepicker.min.js"></script>
<script src="assets/plugins/fullcalendar/fullcalendar.min.js" defer></script>
<script src="/assets/plugins/select2/dist/js/select2.full.min.js"></script>

<script type="text/javascript">

/********* Functions *********/
	// function expose_more(more_id) { 
	// 	var more_link = '#more_link_' + more_id;
	// 	var more_span = '#more_desc_' + more_id;
	// 	$(more_link).hide();
	// 	$(more_span).show();
	// 	return false;
	// }

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
    
    $("#contact-select").select2({ placeholder:'Please select one', width:'100%'});
    $("#appointment-type").select2({ placeholder:'Choose a contact', width:'100%'});

    console.log("Calendar ready");

	$('#appointment-date').datetimepicker();
    
    var calendar = $('#calendar').fullCalendar({
        header: {
            left: 'month,agendaWeek,agendaDay',
            center: 'title',
            right: 'prev,today,next '
        },
        droppable: false, // this allows things to be dropped onto the calendar
        drop: function() {
            $(this).remove();
        },
        selectable: true,
        selectHelper: true,
        dayClick: function (date, jsEvent, view) {
            var calendar_date = date.format("MM/DD/YYYY HH:mm:ss");

            $('#appointment-date').data("DateTimePicker").date(calendar_date);

            $('#appointment-date').change();
            $('#modal-add-appointment').modal('show');
            $('#calendar').fullCalendar('unselect');
            $("#form-add-appointment").data('form-action', "add");
        },
        editable: false,
        eventLimit: true, // allow "more" link when too many events
        events: 
        [
            {foreach item=row from=$contact_appointments}
                {if $smarty.foreach.contact_appointments.last}
                {
                    id: "{$row.contact_appointment_id}",
                    title: "{$row.description}<br>{$row.first_name} {$row.last_name} ",
                    start: '{$row.date_appointment|date_format:"%Y-%m-%d %H:%M:%S"}',
                    contact_name: '{$row.contact_f_name} {$row.contact_l_name}',
                }

                {else}

                {
                    id: "{$row.contact_appointment_id}",
                    title: "{$row.description}",
                    start: '{$row.date_appointment|date_format:"%Y-%m-%d %H:%M:%S"}',
                    contact_name: '{$row.first_name} {$row.last_name}',
                },
                {/if}
            {/foreach}
        ],
        eventRender: function(event, element, view) {
            // console.log(event._id);
            var event_template;
            var momentTime = moment(event.start);
            var formattedTime = momentTime.format('h:mm A');

            event_template = '<a class="fc-day-grid-event fc-h-event fc-event fc-start fc-end">';
            event_template += '<div class="fc-content" data-caid="'+event._id.replace('_fc','')+'">';
            // event_template += '<span class="fc-time">'+time_format(event.start)+' - '+ event.contact_name;
            event_template += '<span class="fc-time">'+formattedTime+' - '+ event.contact_name;
            event_template += '<small class="fc-title">'+event.title+'</small>';
            event_template += '</span>';
            event_template += '</div>';
            event_template += '</a>';

            return $(event_template);
        },

    });

	$(document).on("click", '#modal-add-appointment #modal-save',function(){
		$("#form-add-appointment").submit();
	});

	$("#form-add-appointment").on("submit", function(e){
		e.preventDefault();
		var target = $('#form-add-appointment').closest('.panel');
		var action;
		if ($("#form-add-appointment").data('form-action') == 'add') { action = 'add'; }
		else { action = 'edit'; }
		if ( $(this).parsley().isValid() ) {
			$.ajax({
				type: "POST",
				url: '/ws/contact/appointment/'+action,
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
					
                    flash_alert('#alert_success_appointment', 'Added an appointement.');

		            $(target).removeClass('panel-loading');
		            $(target).find('.panel-loader').remove();

                    var contact_name = $('#contact-select').select2('data');

                    var eventData = {
                        id: result.data[0]['contact_appointment_id'],
                        title: $("#description").val(),
                        start: $("#selected-appointment-date").val(),
                        contact_name: contact_name[0].text
                    };

                    calendar.fullCalendar( 'renderEvent', eventData , true );

                    {* add contact name after modal has been confirmed .fullCalendar( 'renderEvent', eventData , true )
                        then $('#appointment-date').data("DateTimePicker").date(new Date(start)); *}
                    {* 
                    $('#calendar').fullCalendar('renderEvent', eventData, true); // stick? = true 
                    *}
                    {* $('#appointment-date').val($.fullCalendar.moment(start).format('MM/DD/YYYY')); *}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				},
			    complete: function() {
			    	$("#modal-add-appointment").modal('hide');
			    }
			});
		}
	});


	$(document).on("dp.change", '#appointment-date',function(e){
		if ($(this).val() != '') { $('#selected-appointment-date').val(am_pm_to_hours($(this).val())); }
		else { $('#selected-appointment-date').val(''); }
	});

    $(document).on("click", ".fc-content", function(){

        console.log($(this).data("caid"));

        $.ajax({
            type: "POST",
            url: '/ws/calendar/get_appointment',
            data: { 'contact_appointment_id': $(this).data("caid") },
            dataType: "json",
            success: function(result) {
                if(result.msg) {

                    var appointment_date = moment(result.data[0]['date_appointment']).format('MMMM Do YYYY');
                    var meetingTime = moment(result.data[0]['date_appointment']).format('h:mm A');

                    var appointement;

                    appointement = "Follow-Up / Contact Date: "+appointment_date;
                    appointement += "<br>Contact Name: "+result.data[0]['first_name']+" "+result.data[0]['last_name'];
                    appointement += "<br>Appointment Type: "+result.data[0]['appointment_type'];
                    appointement += "<br>Meeting Time: "+meetingTime;
                    appointement += "<br>Description: "+result.data[0]['description'];
        
                    $("#appointment-details").html(appointement);
                    $('#modal-view').modal('toggle');
                    $(".modal-title").html();

                }
                else {
                    $("#alert_error").removeClass('hide');
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
            }
        });
    });

    $('#modal-view').click(function(e){
       e.stopPropagation();
    });
});

</script>