	<!-- ================== BEGIN PAGE LEVEL JS ================== -->
	<script src="assets/plugins/select2/dist/js/select2.full.min.js"></script>
    <script src="assets/plugins/morris/raphael.min.js"></script>
    <script src="assets/plugins/morris/morris.js"></script>
    <script src="assets/plugins/jquery-jvectormap/jquery-jvectormap.min.js"></script>
    <script src="assets/plugins/jquery-jvectormap/jquery-jvectormap-world-merc-en.js"></script>
    <script src="assets/plugins/bootstrap-calendar/js/bootstrap_calendar.min.js"></script>
	<script src="assets/plugins/gritter/js/jquery.gritter.js"></script>
	<script src="assets/js/dashboard-v2.js"></script>
	<!-- ================== END PAGE LEVEL JS ================== -->


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

	function datetime_format(datetime) {
		var js_datetime = new Date(datetime),
	        date = js_datetime.getDate(),
	        month = "Jan,Feb,Mar,Apl,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec".split(",")[js_datetime.getMonth()];

	    return month +" "+ date + day_ordinal(date) +", "+ js_datetime.getFullYear();
	}

	var shown = 0;

		$("#show-completed").on("click", function() {
			if(shown == 0) {
				$(this).html("<i class='fa fa-minus'></i> Hide Completed Follow-Up / Contacts");
				shown++;
			}
			else {
				$(this).html("<i class='fa fa-expand'></i> Show Completed Follow-Up / Contacts");
				shown--;
			}
		});

		$("#btn-search").on("click", function(){
			var name = $("#input-search").val();

			if (name !== "") {
				$.ajax({
					type: "POST",
					url: '/ws/contact/search',
					data: { 'name': name },
					dataType: "json",
					success: function(result) {
						console.log(result);
						if (result) {
							$('#alert_process').addClass('hide');
							$("#panel-search").removeClass('hide');
							$("#table-contacts tbody").html("");
							var temp = JSON.parse(JSON.stringify(result));

							if(temp.data.length > 0) {
								$.each(temp.data, function(index, val) {
									console.log(index + " " + val.first_name + " date_activity: " + val.date_activity);
									var campaigns_append = "";
									var row_html = '';

									if (val.campaigns.length > 0) {
										$.each(val.campaigns, function(index2, campaign) {
											campaigns_append += '<span class="label label-primary">' +
											'<span class="fa fa-envelope"></span>' + campaign.campaign_name + ' (' + campaign.days_in + ' days)' +
											'</span>&nbsp;';
										});
									}

									row_html += '<tr>';
									row_html += '<td><a href="/contacts_edit.php?id='+val.contact_id+'">'+val.contact_id+'</a></td>';
									row_html += '<td class="text-center">'+val.first_name+' '+val.last_name+'</td>';
									row_html += '<td class="text-center">'+datetime_format(val.date_created)+'</td>';
									row_html += '<td class="text-center">'+datetime_format(val.date_viewed)+'</td>';
									if (val.date_last_opened_event != null) {
										row_html += '<td class="text-center">'+datetime_format(val.date_last_opened_event)+'</td>';
									}
									else {
										row_html += '<td class="text-center"></td>';
									}
									row_html += '<td class="text-center">'+campaigns_append+'</td>';
									row_html += '</tr>';
			    					row_html += '<tr>';
			    					row_html += '<td><small>&nbsp;</small></td><td colspan="5"><small>'+val.summary+'</small></td>';
			    					row_html += '</tr>';

			    					$("#table-contacts tbody").append(row_html);
								});
							}
							else {
		    					$("#table-contacts tbody").append('<tr class="no-data"><td class="text-center" colspan="6">No Data Found</td></tr>');
							}
						}
						else {
							$('#alert_process').removeClass('hide');
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus);
					}
				});
			}
		});


</script>

{include file="includes/modal_new_transaction.tpl" is_dashboard="1"}