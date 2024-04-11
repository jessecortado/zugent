{include file="includes/header.tpl"}
<link href="assets/plugins/summernote/summernote.css" rel="stylesheet" />
<!-- <link rel="stylesheet" href="assets/plugins/jquery-confirm/dist/jquery-confirm.min.css"> -->

<!-- begin #content -->
<div id="content" class="content">
	<!-- begin breadcrumb -->
	<ol class="breadcrumb pull-right">
		<li>Home</li>
		<li><a href="/dashboard.php">Dashboard</a></li>
		<li><a href="/contact_pool.php">Contact Pool List</a></li>
		<li class="active">View Pool</li>
	</ol>
	<!-- end breadcrumb -->
	<!-- begin page-header -->
	<h1 class="page-header">Lead Details <small></small></h1>
	<!-- end page-header -->

	<form id="form-pool" action="services/pool_manager.php" method="POST">
		<input type="hidden" name="pool_lead_id" value="{$lead.pool_lead_id}"/>
		<input type="hidden" name="action" value="claim_lead"/>
	</form>

	<div class="col-md-3">
		<div class="row">
			<div class="panel panel-inverse">
				<div class="panel-heading">
					<h4 class="panel-title">Client Details</h4>
				</div>
				<div class="panel-body">
					<!-- Profile Image -->
					<div class="client-card">
						<div class="client-card-body">
							<h3 class="text-center" style="margin-top: 0;">{$lead.first_name} {$lead.last_name}</h3>

							<p class="text-muted text-center">Added by: {$lead.added_by}</p>

							<ul class="list-group list-group-unbordered">
								<li class="list-group-item">
									<b>Date Added</b> <a class="pull-right">{$lead.date_added|date_format}</a>
								</li>
								<li class="list-group-item">
									<b>Date Last Contacted</b> <a class="pull-right">{$lead.date_last_contacted|date_format}</a>
								</li>
							</ul>

							<strong><i class="fa fa-book margin-r-5"></i> Phone Number/s:</strong>

							<p class="text-muted">
							{if $lead.phone_0 ne ''}
								<a class="phone-call" data-num="+1{$lead.phone_0}" href="tel:+1{$lead.phone_0}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_0}">{$lead.phone_0} </a><br>
							{/if}
							{if $lead.phone_1 ne ''}
								<a class="phone-call" data-num="+1{$lead.phone_1}" href="tel:+1{$lead.phone_1}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_1}">{$lead.phone_0} </a><br>
							{/if}
							{if $lead.phone_2 ne ''}
								<a class="phone-call" data-num="+1{$lead.phone_2}" href="tel:+1{$lead.phone_2}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_2}">{$lead.phone_2} </a><br>
							{/if}
							{if $lead.phone_3 ne ''}
								<a class="phone-call" data-num="+1{$lead.phone_3}" href="tel:+1{$lead.phone_3}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_3}">{$lead.phone_3} </a><br>
							{/if}
							{if $lead.phone_4 ne ''}
								<a class="phone-call" data-num="+1{$lead.phone_4}" href="tel:+1{$lead.phone_4}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_4}">{$lead.phone_4} </a><br>
							{/if}
							{if $lead.phone_5 ne ''}
								<a class="phone-call" data-num="+1{$lead.phone_5}" href="tel:+1{$lead.phone_5}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_5}">{$lead.phone_5} </a><br>
							{/if}
							{if $lead.phone_6 ne ''}
								<a class="phone-call" data-num="+1{$lead.phone_6}" href="tel:+1{$lead.phone_6}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_6}">{$lead.phone_6} </a><br>
							{/if}
							{if $lead.phone_7 ne ''}
								<a class="phone-call" data-num="+1{$lead.phone_7}" href="tel:+1{$lead.phone_7}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_7}">{$lead.phone_7} </a><br>
							{/if}
							{if $lead.phone_8 ne ''}
								<a class="phone-call" data-num="+1{$lead.phone_8}" href="tel:+1{$lead.phone_8}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_8}">{$lead.phone_8} </a><br>
							{/if}
							{if $lead.phone_9 ne ''}
								<a class="phone-call" data-num="+1{$lead.phone_9}" href="tel:+1{$lead.phone_9}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_9}">{$lead.phone_9} </a><br>
							{/if}
							</p>

							<hr>

							<strong><i class="fa fa-envelope margin-r-5"></i> Email Address</strong>

							{if $lead.email ne ''}
							<p class="text-muted">
								<a href="mailto:{$lead.email}">{$lead.email}</a>
							</p>
							{/if}

							<hr>

							<strong><i class="fa fa-map-marker margin-r-5"></i> Location</strong>
							{if $lead.address_line_1 ne '' or $lead.address_line_2 ne ''}
							<p class="text-muted">{$lead.address_line_1}<br>{$lead.address_line_2}<br>
								{if $lead.city ne ''}
								{$lead.city}, 
								{/if}
								{if $lead.state ne ''}
								{$lead.state} 
								{/if}
								{if $lead.zip ne ''}
								{$lead.zip}
								{/if}
								{if $lead.county ne ''}
								<br>{$lead.county}
								{/if}
							</p>
							{/if}
							<hr>

							{if $lead.raw_data ne ''}
							<strong><i class="fa fa-database margin-r-5"></i> Raw Data</strong>
								{if $lead.raw_data|count_characters:true > 500}
								{$lead.raw_data_start}
								<a id="more_link_{$lead.pool_lead_id}" onclick="return expose_more({$lead.pool_lead_id});">[ more ]</a>
								<span style="display: none;" id="more_desc_{$lead.pool_lead_id}">
									{$lead.raw_data_end}
								</span>
								{else}
								<p class="text-muted">{$lead.raw_data|replace:'/\n':'<br>'}</p>
								{/if}
							<hr>
							{/if}

							<strong><i class="fa fa-file-text-o margin-r-5"></i> Lead Notes</strong>

							<p>{$lead.lead_note|default:"n/a"}</p>

							<hr>

							<a href="javascript:;" id="claim-lead" class="btn btn-success btn-block"><i class="fa fa-paperclip"></i><b>Claim Lead</b></a>
						</div>
						<!-- /.box-body -->
					</div>
					<!-- /.box -->


					{*
					<div class="row">
						<div class="col-md-5 col-md-offset-1">
							<div class="table-responsive">
								<table class="table table-profile">
									<thead>
										<tr>
											<th></th>
											<th>
												<h4>{$lead.full_name}</h4>
											</th>
										</tr>
									</thead>
									<tbody>
										{if $lead.email ne ''}
										<tr>
											<td class="field">Email</td>
											<td><i class="fa fa-mobile fa-lg m-r-5"></i> {$lead.email}</td>
										</tr>
										<tr class="divider">
											<td colspan="2"></td>
										</tr>
										{/if}
										<tr class="divider">
											<td colspan="2"></td>
										</tr>
										{if $lead.address_line_1 ne '' or $lead.address_line_2 ne ''}
										<tr>
											<td class="field">Address</td>
											<td>{$lead.address_line_1}<br>{$lead.address_line_2}</td>
										</tr>
										{/if}
										{if $lead.city ne ''}
										<tr>
											<td class="field">City</td>
											<td>{$lead.city}</td>
										</tr>
										{/if}
										{if $lead.county ne ''}
										<tr>
											<td class="field">County</td>
											<td>{$lead.county}</td>
										</tr>
										{/if}
										{if $lead.state ne ''}
										<tr>
											<td class="field">State</td>
											<td>{$lead.state}</td>
										</tr>
										{/if}
										{if $lead.zip ne ''}
										<tr>
											<td class="field">Zip</td>
											<td>{$lead.zip}</td>
										</tr>
										{/if}
										{if $lead.date_added ne ''}
										<tr>
											<td class="field">Date Added</td>
											<td>{$lead.date_added|date_format}</td>
										</tr>
										{/if}
										{if $lead.date_last_contacted ne ''}
										<tr>
											<td class="field">Date Last Contacted</td>
											<td>{$lead.date_last_contacted|date_format}</td>
										</tr>
										{/if}
										{if $lead.date_contact_made ne ''}
										<tr>
											<td class="field">Date Contact Made</td>
											<td>{$lead.date_contact_made|date_format}</td>
										</tr>
										{/if}
									</tbody>
								</table>
							</div>
						</div>
						<div class="col-md-offset-1 col-md-5">
							<div class="table-responsive">
								<table class="table table-profile">
									<thead>
										<tr>
											<th></th>
										</tr>
									</thead>
									<tbody>
										{if $lead.added_by ne ''}
										<tr>
											<td class="field">Added By</td>
											<td>{$lead.added_by}</td>
										</tr>
										{/if}
										<tr class="divider">
											<td colspan="2"></td>
										</tr>
										{if $lead.lead_note ne ''}
										<tr>
											<td class="field">Lead Note</td>
											<td>{$lead.lead_note}</td>
										</tr>
										<tr class="divider">
											<td colspan="2"></td>
										</tr>
										{/if}
										{if $lead.phone_0 ne ''}
										<tr>
											<td class="field">Phone Number/s:</td>
											<td><a class="phone-call" data-num="+1{$lead.phone_0}" href="tel:+1{$lead.phone_0}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_0}">{$lead.phone_0} </a></td>
										</tr>
										{/if}
										{if $lead.phone_1 ne ''}
										<tr>
											<td class="field"></td>
											<td><a class="phone-call" data-num="+1{$lead.phone_1}" href="tel:+1{$lead.phone_1}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_1}">{$lead.phone_1} </a></td>
										</tr>
										{/if}
										{if $lead.phone_2 ne ''}
										<tr>
											<td class="field"></td>
											<td><a class="phone-call" data-num="+1{$lead.phone_2}" href="tel:+1{$lead.phone_2}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_2}">{$lead.phone_2} </a></td>
										</tr>
										{/if}
										{if $lead.phone_3 ne ''}
										<tr>
											<td class="field"></td>
											<td><a class="phone-call" data-num="+1{$lead.phone_3}" href="tel:+1{$lead.phone_3}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_3}">{$lead.phone_3} </a></td>
										</tr>
										{/if}
										{if $lead.phone_4 ne ''}
										<tr>
											<td class="field"></td>
											<td><a class="phone-call" data-num="+1{$lead.phone_4}" href="tel:+1{$lead.phone_4}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_4}">{$lead.phone_4} </a></td>
										</tr>
										{/if}
										{if $lead.phone_5 ne ''}
										<tr>
											<td class="field"></td>
											<td><a class="phone-call" data-num="+1{$lead.phone_5}" href="tel:+1{$lead.phone_5}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_3}">{$lead.phone_5} </a></td>
										</tr>
										{/if}
										{if $lead.phone_6 ne ''}
										<tr>
											<td class="field"></td>
											<td><a class="phone-call" data-num="+1{$lead.phone_6}" href="tel:+1{$lead.phone_6}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_3}">{$lead.phone_6} </a></td>
										</tr>
										{/if}
										{if $lead.phone_7 ne ''}
										<tr>
											<td class="field"></td>
											<td><a class="phone-call" data-num="+1{$lead.phone_7}" href="tel:+1{$lead.phone_7}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_7}">{$lead.phone_7} </a></td>
										</tr>
										{/if}
										{if $lead.phone_8 ne ''}
										<tr>
											<td class="field"></td>
											<td><a class="phone-call" data-num="+1{$lead.phone_8}" href="tel:+1{$lead.phone_8}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_8}">{$lead.phone_8} </a></td>
										</tr>
										{/if}
										{if $lead.phone_9 ne ''}
										<tr>
											<td class="field"></td>
											<td><a class="phone-call" data-num="+1{$lead.phone_9}" href="tel:+1{$lead.phone_9}"><i class="fa fa-mobile fa-lg m-r-5"></i><input type="hidden" name="phones[]" value="{$lead.phone_9}">{$lead.phone_9} </a></td>
										</tr>
										{/if}
									</tbody>
								</table>
							</div>
						</div>
					</div>

					<div class="col-md-10 col-md-offset-1">
						<table class="table table-profile">
							<thead>
								<tr><th></th></tr>
							</thead>
							{if $lead.raw_data ne ''}
							<tr>
								<td class="field">Raw Data</td>
								<td>
									{if $lead.raw_data|count_characters:true > 500}
									{$lead.raw_data_start}
									<a id="more_link_{$lead.pool_lead_id}" onclick="return expose_more({$lead.pool_lead_id});">[ more ]</a>
									<span style="display: none;" id="more_desc_{$lead.pool_lead_id}">
										{$lead.raw_data_end}
									</span>
									{else}
									<p>{$lead.raw_data|replace:'/\n':'<br>'}</p>
									{/if}
								</td>
							</tr>
							{/if}
						</table>
					</div>

					<div class="col-md-12 text-center">
						<button data-toggle="confirmation" id="claim-lead" type="submit" class="btn btn-sm btn-success m-r-5">Claim Lead</button>
					</div>
					*}

				</div>
			</div>
		</div>
	</div>


	<div class="col-md-9">
		<div class="row">
			<a id="btn-contact-log-note" data-toggle="collapse" data-target="#frm-contact-log-note" href="#contact-log-note" class="btn btn-sm m-b-15 btn-success"><i class=" m-r-5 fa fa-comment"></i> Contact Log Note</a>
			
			<form id="frm-contact-log-note" class="collapse" data-parsley-validate="true">
				<div class="input-group control-group m-b-10">
					<input type="text" id="contact-log-note" class="form-control" placeholder="Enter Contact Log Note Here" data-parsley-required="true" data-parsley-errors-container="#contact-log-errors">
					<div class="input-group-btn"> 
						<button class="btn btn-success add-more" id="add-log-note" type="button"><i class="glyphicon glyphicon-plus"></i> Save Note</button>
					</div>
				</div>
				<div id="contact-log-errors"></div>
			</form>

			<div class="panel panel-inverse">
				<div class="panel-heading">
					<h4 class="panel-title">Contact Logs</h4>
				</div>
				<div class="panel-body">
					<div class="table-responsive">
						<table class="table table-compressed">	
							<thead>
								<tr>
									<th>Contacted By</th>
									<th class="text-center">Contacted On</th>
									<th class="text-center">Note</th>
									<th class="text-center">Target</th>
									<th class="text-center">Contact Method</th>
								</tr>
							</thead>

			                {foreach item=row from=$contact_log}
							<tr>
								<td>{$row.username}</td>
								<td class="text-center">{$row.date_created|date_format:'%b'}{$row.date_created|date_format:" jS, "}{$row.date_created|date_format:'%Y'}</td>
								<td class="text-center">{$row.contact_note}</td>
								<td class="text-center">{$row.contact_target}</td>
								<td class="text-center">{$row.contact_method}</td>
							</tr>
							{foreachelse}
							<tr><td class="text-center" colspan="5">No Contact Log</td></tr>
							{/foreach}
						</table>
					</div>
				</div>
			</div>

			<div class="panel panel-inverse">
				<div class="panel-heading">
					<h4 class="panel-title">Other Details</h4>
				</div>
				<div class="panel-body">
			        {foreach from=$raw_data item=row}
			        	{foreach from=$row item=val key=k}
			        		{if $val ne ''}
					        	<div class="col-md-4 text-center">
					        		<span><b>{$k}</b></span>
					        		<p>{$val}</p>
					        	</div>
			        		{/if}
			        	{/foreach}
					{/foreach}
				</div>
			</div>
		</div>
	</div>

</div>
<!-- end #content -->

<script src="assets/plugins/summernote/summernote.min.js" defer></script>
<!-- <script src="assets/plugins/jquery-confirm/dist/jquery-confirm.min.js" defer></script>
<script src="assets/js/bootstrap-confirmation.min.js" defer></script> -->
<script src="assets/plugins/sweetalert2/js/sweetalert2.all.min.js" defer></script>

<script type="text/javascript">
defer(deferred_method);

function defer(method){
	if (window.jQuery)
		method();
	else
		setTimeout(function() { defer(method) }, 500);
}

function deferred_method() {

	$('#summernote').summernote({
		placeholder: 'Give this pool a description',
		height: "300px"
	});

	$('#summernote').on('summernote.change', function(we, contents, $editable) {
		$("#bio").html(contents);
	});

	$('#save-pool').click(function(){
		console.log("help");
		$("#form-pool").submit();
	});

	$('#state').val('{$user.state}');

	// $('[data-toggle="confirmation"]').confirmation({
	// 	title: "Are you sure you want to claim this lead?",
	// 	onConfirm: function(event, element) { 
	// 		$("#page-loader, .page-loader").removeClass("hide");
	// 		$("#page-loader").append("<p style='position:absolute; top: 70%; left: 46.5%; margin: -20px 0 0 -20px;'>Processing Please Wait</p>");
	// 		console.log("confirmed");

	// 		$("#form-pool").submit();
	// 	},
	// 	onCancel: function() { }
	// });

	$("#claim-lead").on("click", function(e){
		e.preventDefault();
		swal({
            title: 'Are you sure you want to claim this lead?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, claim it!',
            cancelButtonText: 'No, cancel!',
            confirmButtonClass: 'btn btn-sm btn-success m-r-5',
            cancelButtonClass: 'btn btn-sm btn-danger',
            buttonsStyling: false,
            allowOutsideClick: false
        }).then(function () {
			$("#form-pool").submit();
        }, function (dismiss) {});
		// $(current).confirmation('show');
	});

	var phoneNumber = 0;
	var logId = 0;

	$(".phone-call").on("click", function(e) {
		e.preventDefault();

		phoneNumber = $(this).data("num");
		if (phoneNumber.includes("+1", 2) ) {
			phoneNumber = phoneNumber.substring(2);
		}

		console.log("call "+ phoneNumber);

		$.ajax({
			type: "POST",
			url: '/services/pool_manager.php',
			data: { 'pool_lead_id': '{$lead.pool_lead_id}', 'action': 'call_lead', 'number': phoneNumber},
			dataType: "json",
			success: function(result) {
				logId = result;
			},
			error: function (XMLHttpRequest, textStatus, errorThrown) {
				console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus);
			}
		});
        window.location.href="tel://"+phoneNumber;
	});

	$("#btn-contact-log-note").on("click", function() {
		$("#frm-contact-log-note").parsley().reset();
	});

	$("#add-log-note").on("click", function() {
		$("#frm-contact-log-note").submit();
	});

	$("#frm-contact-log-note").on("submit", function() {
		$.ajax({
			type: "POST",
			url: '/services/pool_manager.php',
			data: { 'pool_lead_id': '{$lead.pool_lead_id}', 'note': $("#contact-log-note").val(), 'action': 'add_log_note'},
			dataType: "json",
			success: function(result) {
				console.log(result);
				window.location.href="/pool_lead_view.php?id={$lead.pool_lead_id}";
			},
			error: function (XMLHttpRequest, textStatus, errorThrown) {
				console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus);
			}
		});
	});

}

function expose_more(more_id) { 
	var more_link = '#more_link_' + more_id;
	var more_span = '#more_desc_' + more_id;
	$(more_link).hide();
	$(more_span).show();
	return false;
}


</script>

{include file="includes/footer.tpl"}