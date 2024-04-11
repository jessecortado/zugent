{include file="includes/header.tpl" active_page="campaign" active_sub_page="campaign_list"}

<!-- begin #content -->
<div id="content" class="content">
	<!-- begin breadcrumb -->
	<ol class="breadcrumb pull-right">
		<li>Home</li>
		<li><a href="/dashboard.php">Dashboard</a></li>
		<li class="active"><a href="/campaign_list.php">Campaigns List</a></li>
	</ol>
	<!-- end breadcrumb -->
	<!-- begin page-header -->
	<h1 class="page-header">Campaigns <small>List</small></h1>
	<!-- end page-header -->


	<!-- begin row -->
	<div class="row">

		<div class="col-md-12 col-sm-12">
			<p>
				<a href="/campaign_new.php" class="btn btn-success m-r-5"><i class="fa fa-plus"></i> Create a New Campaign</a>
			</p>

			{*
			<!-- begin panel -->
			<div class="panel panel-inverse" data-sortable-id="new-contacts">
				<div class="panel-heading">
					<h4 class="panel-title">Your Campaigns</h4>
				</div>
				<div class="panel-body">
					<table class="table table-striped">
						<thead>
							<tr>
								<th>#</th>
								<th>Name</th>
								<th>Added</th>
								<th>Last Viewed</th>
								<th>Last Active</th>
								<th>Action(s)</th>
								<th>Type</th>
							</tr>
						</thead>
						<tbody>
							{foreach from=$my_campaigns item="data"}
							<tr>
								<td><a href="/campaign_edit.php?id={$data.campaign_id}">{$data.campaign_id}</a></td>
								<td>{$data.campaign_name}</td>
								<td>{$data.first_name} {$data.last_name}</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							{foreachelse}
							<tr><td colspan="8">You don't have any campaigns. Copy an existing campaign or create a new one!</td></tr>
							{/foreach}
						</tbody>
					</table>
				</div>
			</div>
			<!-- end panel -->

			<!-- begin panel -->
			<div class="panel panel-inverse" data-sortable-id="new-contacts">
				<div class="panel-heading">
					<h4 class="panel-title">Company Campaigns</h4>
				</div>
				<div class="panel-body">
					<table class="table table-striped">
						<thead>
							<tr>
								<th>#</th>
								<th>Name</th>
								<th>Added</th>
								<th>Last Viewed</th>
								<th>Last Active</th>
								<th>Actions</th>
								<th>Type</th>
							</tr>
						</thead>
						<tbody>
							{foreach from=$my_campaigns item="data"}
							<tr>
								<td><a href="/campaign_edit.php?id={$data.campaign_id}">{$data.campaign_id}</a></td>
								<td>{$data.campaign_name}</td>
								<td>{$data.first_name} {$data.last_name}</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							{foreachelse}
							<tr><td colspan="8">You don't have any campaigns. Copy an existing campaign or create a new one!</td></tr>
							{/foreach}
						</tbody>
					</table>
				</div>
			</div>
			<!-- end panel -->

			*}

		</div>
	</div>
	<!-- end #row -->

	<div class="row">
		<div class="col-md-12">
			<h4>Personal Campaigns</h4>
		</div>

		{assign var="ctr" value=1 }
		{foreach from=$my_campaigns item="row"}
		<div class="col-md-6">
			<!-- begin panel -->
			<div class="panel panel-inverse" data-sortable-id="form-stuff-1">
				<div class="panel-heading">
					<h4 class="panel-title">Campaign Name: {$row.campaign_name}</h4>
				</div>
				<div class="panel-body">
					<table class="table table-condensed">
						<thead>
							<tr>
								<th>ID</th>
								<th>Events</th>
								<th>Max Send After</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>{$row.campaign_id}</td>
								<td>{$row.events_count}</td>
								<td>{$row.max}</td>
							</tr>
							<tr>
								<td colspan="3">{$row.description}</td>
							</tr>
							<tr>
								<td colspan="3" class="text-center">
									<a href="/campaign_edit.php?id={$row.campaign_id}" class="btn btn-sm btn-success"><i class="fa fa-pencil"></i> Edit</a>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<!-- end panel -->
		</div>
		{foreachelse}

		{/foreach}
	</div>
	<hr>
	<div class="row">
		<div class="col-md-12">
			<h4>Company Campaigns</h4>
		</div>

		{assign var="ctr" value=1 }
		{foreach from=$company_campaigns item="row"}
		<div class="col-md-6">
			<!-- begin panel -->
			<div class="panel panel-inverse" data-sortable-id="form-stuff-1">
				<div class="panel-heading">
					<h4 class="panel-title">Campaign Name: {$row.campaign_name}</h4>
				</div>
				<div class="panel-body">
					<table class="table table-condensed">
						<thead>
							<tr>
								<th>ID</th>
								<th>Events</th>
								<th>Max Send After</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>{$row.campaign_id}</td>
								<td>{$row.events_count}</td>
								<td>{$row.max}</td>
							</tr>
							<tr>
								<td colspan="3">{$row.description}</td>
							</tr>
							<tr>
								<td colspan="3" class="text-center">
									<a href="/copy_campaign.php?id={$row.campaign_id}" class="btn btn-sm btn-success"><i class="fa fa-copy"></i> Copy</a>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<!-- end panel -->
		</div>
		{foreachelse}

		{/foreach}
	</div>



</div>
<!-- end #content -->

{include file="includes/footer.tpl"}