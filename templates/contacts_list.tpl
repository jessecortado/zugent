{include file="includes/header.tpl"}
<link rel="stylesheet" type="text/css" href="assets/plugins/DataTables/datatables.min.css"/>

<style type="text/css">
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
</style>

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
				<div class="stats-number">
					<a href="/campaign_list.php" class="dash-view-all" style="padding: 0;">{$total_campaigns}</a>
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

	<!-- begin row -->
	<div class="row">
		<div class="col-md-12">
			<p>
				<a href="/contacts_new.php" class="btn btn-success m-r-5"><i class="fa fa-comment"></i> New Contact</a>
			</p>

			{if $name ne 'overdue' and $name ne 'upcoming'}
			<div class="input-group control-group search-area m-t-20 m-b-15">
				<input type="text" id="input-search" class="form-control" placeholder="Search a specific contact">
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
        							{if $company.has_campaigns eq 1}
									<th class="text-center">Campaigns</th>
									{/if}
								</tr>
							</thead>
							<tbody>
								
							</tbody>
						</table>
					</div>
				</div>
			</div>
			{/if}

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
									{if $active_page eq 'company_contacts'}
									<th class="text-center">Assigned Agent</th>
									{/if}
									<th class="text-center">Last Viewed</th>
									<th class="text-center">Last Active</th>
        							{if $company.has_campaigns eq 1}
									<th class="text-center">Campaigns</th>
									{/if}
								</tr>
							</thead>
							<tbody>
								{foreach from=$contact_items_1 item='contact'}
								<tr>
									<td><a href="/contacts_edit.php?id={$contact.contact_id}">{$contact.contact_id}</a></td>
									<td class="text-center">{$contact.first_name} {$contact.last_name}</td>
									<td class="text-center">{$contact.date_created|date_format}</td>
									{if $active_page eq 'company_contacts'}
									<td class="text-center">{$contact.primary_user}</td>
									{/if}
									<td class="text-center">{if $contact.date_viewed ne ''}{$contact.date_viewed|date_format}{/if}</td>
									<td class="text-center">{if $contact.last_opened_event_id}{$contact.date_last_opened_event|date_format}{/if}</td>
        							{if $company.has_campaigns eq 1}
									<td class="text-center">
										{foreach from=$contact['campaigns'] item='cdata'}
											<span class="label label-primary">
												<span class="fa fa-envelope"></span> {$cdata.campaign_name} ({$cdata.days_in} days)
											</span>&nbsp;
										{/foreach}
									</td>
									{/if}
								</tr>
								<tr>
									<td><small>&nbsp;</small></td><td colspan="5"><small>{$contact.summary|linefeeds}</small></td>
								</tr>
								{/foreach}
							</tbody>
						</table>
					</div>
				</div>
			</div>
			{/foreach}
			<!-- end panel -->
		</div>
	</div>
	<!-- end #row -->
</div>
<!-- end #content -->




{include file="includes/footer.tpl" footer_js="includes/footers/contacts_list_footer.tpl"}

