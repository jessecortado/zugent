{include file="includes/header.tpl" active_page="company_contacts"}

<!-- begin #content -->
<div id="content" class="content">

    <div id="alert_process" class="alert alert-danger fade in m-b-15 hide">
        <strong>Permission Denied!</strong>
        You don't have permission to access the requested process.
        <span class="close" data-dismiss="alert">×</span>
    </div>

	<!-- begin breadcrumb -->
	<ol class="breadcrumb pull-right">
		<li><a href="javascript:;">Home</a></li>
		<li><a href="javascript:;">Dashboard</a></li>
		<li class="active">Contacts</li>
	</ol>
	<!-- end breadcrumb -->
	<!-- begin page-header -->
	<h1 class="page-header">Contacts | {$name}</h1>
	<!-- end page-header -->
	<!-- begin row -->
	<div class="row">
		<!-- begin col-4 -->
		<div class="col-md-4 col-sm-6">
			<div class="widget widget-stats bg-green">
				<div class="stats-icon stats-icon-lg"><i class="fa fa-globe fa-fw"></i></div>
				<div class="stats-title">YOUR DISPLAYED CONTACTS</div>
				<div class="stats-number">{$total_count}</div>
			</div>
		</div>
		<!-- end col-4 -->
		<!-- begin col-4 -->
		<div class="col-md-4 col-sm-6">
			<div class="widget widget-stats bg-blue">
				<div class="stats-icon stats-icon-lg"><i class="fa fa-tags fa-fw"></i></div>
				<div class="stats-title">ACTIVE CAMPAIGNS</div>
				<div class="stats-number">{$total_campaigns}</div>
			</div>
		</div>
		<!-- end col-4 -->
		<!-- begin col-4 -->
		<div class="col-md-4 col-sm-6">
			<div class="widget widget-stats bg-black">
				<div class="stats-icon stats-icon-lg"><i class="fa fa-comments fa-fw"></i></div>
				<div class="stats-title">MESSAGES DELIVERED</div>
				<div class="stats-number">{$total_messages}</div>
			</div>
		</div>
		<!-- end col-3 -->
	</div>
	<!-- end row -->

	<!-- begin row -->
	<div class="row">

		<div class="col-md-12 col-sm-12">
			<p>
				<a href="/contacts_new.php" class="btn btn-success m-r-5"><i class="fa fa-comment"></i> New Contact</a>
			</p>
			<div class="input-group control-group search-area m-t-20 m-b-15">
				<input type="text" id="input-search" class="form-control" placeholder="{if $filtered}Search a specific contact{else}Search from all your company's contacts{/if}">
				<div class="input-group-btn"> 
					<button class="btn btn-success add-more" id="btn-search" type="button"><i class="fa fa-search"></i> Search</button>
				</div>
			</div>

			<!-- begin panel -->
			<div id="panel-search" class="panel panel-inverse hide" data-sortable-id="new-contacts">
				<div class="panel-heading">
					<h4 class="panel-title">Searched Contacts</h4>
				</div>
				<div class="panel-body">
					<div class="table-responsive">
						<table id="table-contacts" class="table table-striped">
							<thead>
								<tr>
									<th>#</th>
									<th class="text-center">Name</th>
									<th class="text-center">Added</th>
									<th class="text-center">Last Viewed</th>
									<th class="text-center">Last Active</th>
									<th class="text-center">Campaigns</th>
								</tr>
							</thead>
							<tbody>
								
							</tbody>
						</table>
					</div>
				</div>
			</div>
			

			{foreach from=$contacts key='k' item='contact_items_1'}
			<!-- begin panel -->
			<div class="panel panel-inverse" data-sortable-id="new-contacts">
				<div class="panel-heading">
					<h4 class="panel-title">List of Contacts</h4>
				</div>
				<div class="panel-body">
					<div class="table-responsive">
						<table id="table-{$k}" class="table table-striped data-table">
							<thead>
								<tr>
									<th>#</th>
									<th class="text-center">Name</th>
									<th class="text-center">Added</th>
									<th class="text-center">Assigned Agent</th>
									<th class="text-center">Last Viewed</th>
									<th class="text-center">Last Active</th>
									<th class="text-center">Campaigns</th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$contact_items_1 item='contact'}
								<tr>
									<td><a href="/contacts_edit.php?id={$contact.contact_id}">{$contact.contact_id}</a></td>
									<td class="text-center">{$contact.first_name} {$contact.last_name}</td>
									<td class="text-center">{$contact.date_created|date_format}</td>
									<td class="text-center">{$contact.primary_user}</td>
									<td class="text-center">{if $contact.date_viewed ne ''}{$contact.date_viewed|date_format}{/if}</td>
									<td class="text-center">{if $contact.last_opened_event_id}{$contact.date_last_opened_event|date_format}{/if}</td>
									<td class="text-center">
										{foreach from=$contact['campaigns'] item='cdata'}
										<span class="label label-primary">
											<span class="fa fa-envelope"></span> {$cdata.campaign_name} ({$cdata.days_in} days)
										</span>&nbsp;
										{/foreach}
									</td>
								</tr>
								<tr>
									<td><small>&nbsp;</small></td><td colspan="5"><small>{$contact.summary|linefeeds}</small></td>
								</tr>
								{foreachelse}
					            <tr class="no-data"><td class="text-center" colspan="7">No Contacts Available</td></tr>
								{/foreach}

							</tbody>
						</table>
						{/foreach}
					</div>
				</div>
			</div>
			<!-- end panel -->


		</div>
	</div>
	<!-- end #row -->



</div>
<!-- end #content -->


<script src="assets/plugins/DataTables/media/js/jquery.dataTables.js" defer></script>
<script src="assets/plugins/DataTables/media/js/dataTables.bootstrap.min.js" defer></script>
<script src="assets/plugins/DataTables/extensions/Responsive/js/dataTables.responsive.min.js" defer></script>

<script>

	defer(deferred_method);

	function defer(method){
		if (window.jQuery)
			method();
		else
			setTimeout(function() { defer(method) }, 500);
	}
	
	var shown = 0;

	function deferred_method(){
		$("#btn-search").on("click", function(){
			var name = $("#input-search").val();

			var process_url = "";
			var data_to_send = "";
			
			{if $filtered}
			var data_filtered = {
				'name': name,
				'search_name': '{$search_name}',
				'search_id': '{$search_id}'
			};
			process_url = "/ws/contact/filtered_company_search";
			data_to_send = data_filtered;
			{else}
			var data_not_filtered = { 'name': name };
			process_url = "/ws/contact/company_search";
			data_to_send = data_not_filtered;
			{/if}
			
			if (name !== "") {
				console.log(process_url);
				console.log(data_to_send);
				$.ajax({
					type: "POST",
					 url: process_url,
					data: data_to_send,
				dataType: "json",
				success: function(result) {
					console.log(result);
					if (result) {
						$('#alert_process').addClass('hide');
						$("#panel-search").removeClass('hide');
						$("#table-contacts tbody").html("");
						var temp = JSON.parse(JSON.stringify(result));
						var row_html = "";
						if(temp.data.length > 0) {
							$.each(temp.data, function(index, val) {
								console.log(index + " " + val.first_name + " date_activity: " + val.date_activity);
								var campaigns_append = "";
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

	}

</script>

{include file="includes/footer.tpl" footer_js="includes/footers/dashboard.tpl"}

