

<script type="text/javascript">

var shown = 0;

	$("#btn-search").on("click", function(){
		var name = $("#input-search").val();
		var process_url = "";

		{if $active_page eq 'company_contacts'}
			process_url = "/ws/contact/filtered_company_search";
		{else}
			process_url = "/ws/contact/filtered_search";
		{/if}

		if (name !== "") {
			$.ajax({
				type: "POST",
				url: process_url,
				data: { 'name': name, 'search_name': '{$search_name}', 'search_id': '{$search_id}' },
				dataType: "json",
				success: function(result) {
					console.log(result);
					if (result.msg) {
						$('#alert_process').addClass('hide');
						$("#panel-search").removeClass('hide');
						$("#table-contacts tbody").html("");
						var temp = JSON.parse(JSON.stringify(result.data));

						if(temp != '') {
							$.each(temp, function(index, val) {
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
								row_html += '<td class="text-center">'+val.date_created+'</td>';
								row_html += '<td class="text-center">'+val.date_viewed+'</td>';
								row_html += '<td class="text-center">'+val.date_last_opened_event+'</td>';
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