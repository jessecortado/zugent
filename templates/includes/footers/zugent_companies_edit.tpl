<script src="/assets/plugins/select2/dist/js/select2.full.min.js"></script>
<script src="/assets/plugins/bootstrap-daterangepicker/moment.js"></script>
<script src="/assets/plugins/bootstrap-eonasdan-datetimepicker/build/js/bootstrap-datetimepicker.min.js"></script>
<script src="assets/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>


<script type="text/javascript">

    function day_ordinal(day) {
		if(day>3 && day<21) return 'th';
		switch (day % 10) {
			case 1:  return "st";
			case 2:  return "nd";
			case 3:  return "rd";
			default: return "th";
		}
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

        console.log(date_with_ampm);
        console.log((date[2]+"-"+date[0]+"-"+date[1]+" "+sHours+':'+sMinutes+':00'));

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

	$('#date-free-ends').datetimepicker();
    $("#state").val('{$company.0.state}');
    $("#state").select2({ width: "100%" });
    $("#timezone").select2({ width: "100%" });

	{if $company.0.is_free eq 1}
	var date_free = '{$company.0.date_free_ends}';
	$('#date-free-ends').data("DateTimePicker").date(datepickerFormat(date_free));
	{/if}

	$(document).ready(function(){

		$('#has_transactions, #has_drive, #has_pools, #has_bulk_email, #has_referrals, #has_social, #has_broker_page, #has_campaigns, #has_offices').on('change', function() {
			var x = ($(this).attr("checked")) ? 1 : 0;
			$(this).val(x);
		});

		$('#is_free').on('change', function() {
			var x = ($(this).attr("checked")) ? 1 : 0;
			$(this).val(x);
			if (x == 0) {
				$('#date-free-ends').attr("disabled", true);
				$('#date-free-ends').val('');
				$('#selected-date-free').val('');
			}
			else {
				$('#date-free-ends').attr("disabled", false);
			}
		});

		$(document).on("dp.change", '#date-free-ends',function(e){
			if ($(this).val() != '') { $('#selected-date-free').val(am_pm_to_hours($(this).val())); }
			else { $('#selected-date-free').val(''); }
		});
	});
</script>