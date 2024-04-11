{include file="includes/header.tpl" active_page="dashboard"}

<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">

<style type="text/css">
	.info-notice {
		border: none;
	    -webkit-box-shadow: none;
	    box-shadow: none;
	    -webkit-border-radius: 3px;
	    -moz-border-radius: 3px;
	    border-radius: 3px;
		margin-bottom: 20px;
	    background-color: #fff;
	}
	.dtimeline-notify {
	    background-color: #f3f6fb;
	    border-bottom: none;
	    border-color: #e7eaec;
	    border-image: none;
	    border-width: 1px 0;
	    font-size: 15px;
	    clear: both;
	    text-align: center;
	}
	.dtimeline-notify.no-data {
	    border-bottom-right-radius: 3px;
    	border-bottom-left-radius: 3px;
	}
	.dtimeline-notify,
	.dtimeline-notify h3 {
	    color: #fff;
	}
	a.dash-view-all {
		padding: 10px;
		display: block;
		color: #fff;
	    border-bottom-right-radius: 3px;
    	border-bottom-left-radius: 3px;
		-webkit-transition: all .1s linear;
	    -moz-transition: all .1s linear;
	    transition: all .1s linear;
	    text-decoration: none;
	}
	/*a.dash-view-all:hover {
		background-color: #348fe2;
		text-decoration: none;
		color: #fff;
	}*/
	@media (min-width: 767px) {
		.visible-lg, .visible-md, .visible-sm, .visible-xs {
		     display: block!important;
		}
	}
</style>
<!-- begin #content -->
<div id="content" class="content">
	{if isset($display_error_message)}
	<div class="alert alert-danger fade in m-b-15">
		<strong>Access Forbidden!</strong>
		You don't have permission to access the requested {$error_content|default:'directory'}.
		<span class="close" data-dismiss="alert">×</span>
	</div>
	{/if}

	<div id="alert_process" class="alert alert-danger fade in m-b-15 hide">
		<strong>Permission Denied!</strong>
		You don't have permission to access the requested process.
		<span class="close" data-dismiss="alert">×</span>
	</div>

	<!-- begin breadcrumb -->
	<ol class="breadcrumb pull-right">
		<li>Home</li>
		<li class="active">Dashboard</li>
	</ol>
	<!-- end breadcrumb -->
	<!-- begin page-header -->
	<!-- <h1 class="page-header">Contacts <small>Active</small></h1> -->
	<h1 class="page-header">Dashboard</h1>
	<!-- end page-header -->
	<!-- begin row -->
	<div class="row">
		<!-- begin col-4 -->
		<div class="col-md-4 col-sm-6">
			<div class="widget widget-stats bg-green">
				<div class="stats-icon stats-icon-lg"><i class="fa fa-globe fa-fw"></i></div>
				<div class="stats-title">YOUR ASSIGNED CONTACTS</div>
				<div class="stats-number">
					<a href="/contacts_list.php?undefined=1" class="dash-view-all" style="padding: 0;">{$total_contacts}</a>
				</div>
			</div>
		</div>
		<!-- end col-4 -->
		<!-- begin col-4 -->
		<div class="col-md-4 col-sm-6">
			<div class="widget widget-stats bg-blue">
				<div class="stats-icon stats-icon-lg"><i class="fa fa-tags fa-fw"></i></div>
				<div class="stats-title">ACTIVE CAMPAIGNS</div>
				<div class="stats-number">
					<a href="/campaign_active.php" class="dash-view-all" style="padding: 0;">{$total_campaigns}</a>
				</div>
			</div>
		</div>
		<!-- end col-4 -->
		<!-- begin col-4 -->
		<div class="col-md-4 col-sm-6">
			<div class="widget widget-stats bg-black">
				<div class="stats-icon stats-icon-lg"><i class="fa fa-comments fa-fw"></i></div>
				<div class="stats-title">MESSAGES DELIVERED</div>
				<div class="stats-number">
					<a href="/campaign_message.php" class="dash-view-all" style="padding: 0;">{$total_messages}</a>
				</div>
			</div>
		</div>
		<!-- end col-3 -->
	</div>
	<!-- end row -->

	<div class="row">
		<div class="col-md-12">
			<p>
				<a href="/contacts_new.php" class="btn btn-success m-r-5"><i class="fa fa-comment"></i> New Contact</a>
			</p>
		</div>
	</div>

	<div class="row">

		<div class="col-md-4">
			<!-- begin overdue follow-ups panel -->
			<div class="info-notice panel-inverse">
				<div class="panel-body p-0">
					{if $overdue_appointments|count gt 0}
						<div class="dtimeline-notify bg-orange">
							<a href="/contacts_list.php?overdue=1" class="dash-view-all"><i class="fa fa-bookmark"></i> You have {$total_overdue} overdue follow-ups. View All</a>
	                    </div>
						<div class="table-responsive">
							<table class="table">
								<thead>
									<tr>
										<th>Name</th>
										<th class="text-center">Phone</th>
										<th class="text-center">Date</th>
									</tr>
								</thead>
								<tbody>
									{foreach from=$overdue_appointments item="appointment"}
									<tr >
										<td><a href="/contacts_edit.php?id={$appointment.contact_id}"><i class="fa {$appointment.appointment_icon}"></i> {$appointment.first_name} {$appointment.last_name}</a></td>
										<td class="text-center">{if $appointment.phone_number ne ''}{$appointment.phone_number}{else}n/a{/if}</td>
										<td class="text-right">{$appointment.date_appointment|date_format} <small class="text-danger">{$appointment.time_elapsed}</small></td>
									</tr>
									{/foreach}
								</tbody>
							</table>
						</div>
					{else}
						<div class="dtimeline-notify p-4 no-data bg-blue">
							<h3 class="m-t-3 m-b-3 text-center">No Overdue Follow-Ups</h3>
						</div>
					{/if}
				</div>
			</div>
			<!-- end panel -->
		</div>

		<div class="col-md-4">
			<!-- begin panel -->
			<div class="info-notice panel-inverse">
				<div class="panel-body p-0">
					{if $upcoming_appointments|count gt 0}
						<div class="dtimeline-notify bg-green">
							<a href="/contacts_list.php?overdue=1" class="dash-view-all"><i class="fa fa-bookmark"></i> You have {$total_upcoming} upcoming appointment/s. View All</a>
	                    </div>

						<div class="table-responsive">
							<table class="table">
								<thead>
									<tr>
										<th>Name</th>
										<th class="text-center">Phone</th>
										<th class="text-center">Date</th>
									</tr>
								</thead>
								<tbody>
									{foreach from=$upcoming_appointments item="appointment"}
									<tr >
										<td><a href="/contacts_edit.php?id={$appointment.contact_id}"><i class="fa {$appointment.appointment_icon}"></i> {$appointment.first_name} {$appointment.last_name}</a></td>
										<td class="text-center">{if $appointment.phone_number ne ''}{$appointment.phone_number}{else}n/a{/if}</td>
										<td class="text-right">{$appointment.date_appointment|date_format} <small class="text-danger">{$appointment.time_elapsed}</small></td>
									</tr>
									{/foreach}
								</tbody>
							</table>
						</div>
					{else}
						<div class="dtimeline-notify p-4 no-data bg-blue">
							<h3 class="m-t-0 m-b-3 text-center">No Upcoming Follow-Ups</h3>
						</div>
					{/if}
				</div>
			</div>
			<!-- end panel -->
		</div>

		<div class="col-md-4">
			<!-- begin panel -->
			<div class="info-notice panel-inverse">
				<!-- <div class="panel-heading">
					<h4 class="panel-title">Undefined Contacts</h4>
				</div> -->
				<div class="panel-body p-0">
					{if $undefined_appointments|count gt 0}
						<div class="dtimeline-notify bg-red">
							<a href="/contacts_list.php?overdue=1" class="dash-view-all"><i class="fa fa-bookmark-o"></i> You have {$total_undefined} uncategorized contact/s. View All</a>
	                    </div>
						<div class="table-responsive">
							<table class="table">
								<thead>
									<tr>
										<th>Name</th>
										<th class="text-center">Date Assigned</th>
									</tr>
								</thead>
								<tbody>
									{foreach from=$undefined_appointments item="appointment"}
									<tr >
										<td><a href="/contacts_edit.php?id={$appointment.contact_id}">{$appointment.first_name} {$appointment.last_name}</a></td>
										<td class="text-right">{$appointment.date_assigned|date_format}</td>
									</tr>
									{/foreach}
								</tbody>
							</table>
						</div>
					{else}
						<div class="dtimeline-notify p-4 no-data bg-blue">
							<h3 class="m-t-0 m-b-3 text-center">No Uncategorized Contacts</h3>
						</div>
					{/if}
				</div>
			</div>
			<!-- end panel -->
		</div>

		{*
		{if $user.is_transaction_coordinator eq 1 and $company.has_transactions eq 1}
		<div class="col-md-12">
			<!-- begin panel -->
			<div class="info-notice panel-inverse">
				<div class="panel-heading">
					<h4 class="panel-title">Transaction Alerts</h4>
				</div>
				<div class="panel-body p-0">
					<div class="table-responsive">
						<table class="table" name="transactionAlerts" id="transactionAlerts">
							<thead>
								<tr>
									<th>MLS</th>
									<th class="text-center">Listing Number</th>
									<th class="text-center">Status</th>
									<th class="text-center">Date</th>
									<th class="text-center">Address</th>
									<th class="text-center">City</th>
									<th class="text-center">State</th>
									<th class="text-center">Office</th>
									<th class="text-center">Agent</th>
									<th class="text-center">Actions</th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$transaction_alerts item="ta_data"}
								<tr>
									<td>{$ta_data.mls_name}</td>
									<td class="text-center">{$ta_data.listing_number}</td>
									<td class="text-center">{$ta_data.status}</td>
									{if $ta_data.status eq 'Closed'}
										<td class="text-center">{$ta_data.date_sold|date_format:'%b'}{$ta_data.date_sold|date_format:" jS, "}{$ta_data.date_sold|date_format:'%Y'}</td>
									{else}
										<td class="text-center">{$ta_data.date_listed|date_format:'%b'}{$ta_data.date_listed|date_format:" jS, "}{$ta_data.date_listed|date_format:'%Y'}</td>
									{/if}
									<td class="text-center">{$ta_data.address}</td>
									<td class="text-center">{$ta_data.city}</td>
									<td class="text-center">{$ta_data.state}</td>
									{if $ta_data.is_selling_side eq 1}
										<td class="text-center">{$ta_data.selling_office_name}</td>
										<td class="text-center">{$ta_data.selling_agent_name}</td>
									{else}
										<td class="text-center">{$ta_data.list_office_name}</td>
										<td class="text-center">{$ta_data.list_agent_name}</td>
									{/if}
									<td>
        								<a href="#modal-new-transaction" class="btn btn-xs btn-success mnt" data-toggle="modal" style="margin-top: -1px;" data-transaction-alert-id="{$ta_data.transaction_alert_id}"
        								data-listing-number="{$ta_data.listing_number}"
        								data-mls-id="{$ta_data.mls_id}">
        									<i class="fa fa-plus-circle"></i> Add Transaction
        								</a>
									</td>
								</tr>
								{foreachelse}
								<tr class="no-data"><td class="text-center" colspan="9">No Transaction Alerts Available</td></tr>
								{/foreach}
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<!-- end panel -->
		</div>
		{/if}
		*}

	</div>
	<!-- end #row -->
</div>
<!-- end #content -->


{include file="includes/footer.tpl" footer_js="includes/footers/dashboard.tpl"}
