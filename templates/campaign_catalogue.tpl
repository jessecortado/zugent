{include file="includes/header.tpl" active_page="campaign" active_sub_page="campaign_catalogue"}

<!-- begin #content -->
<div id="content" class="content">
	<!-- begin breadcrumb -->
	<ol class="breadcrumb pull-right">
		<li>Home</li>
		<li><a href="/dashboard.php">Dashboard</a></li>
		<li class="active">Campaigns</li>
	</ol>
	<!-- end breadcrumb -->
	<!-- begin page-header -->
	<h1 class="page-header">Campaigns <small>List</small></h1>
	<!-- end page-header -->


	<!-- begin row -->
	<div class="row">
		<div class="col-md-6 ui-sortable">
		
		{assign var="ctr" value=1 }
		{foreach from=$global_campaigns item="row"}
			<!-- begin panel -->
			{if $ctr eq 1}
			<div class="panel panel-inverse" data-sortable-id="form-stuff-1">
				<div class="panel-heading">
					<h4 class="panel-title">Campaign Name: {$row.campaign_name}</h4>
				</div>
				<div class="panel-body">
					<table class="table table-condensed">
						<thead>
							<tr>
								<th>ID</th>
								<th>Cost</th>
								<th>Events</th>
								<th>Max Send After</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>{$row.campaign_id}</td>
								<td>{$row.copy_cost}</td>
								<td>{$row.events_count}</td>
								<td>{$row.max}</td>
							</tr>
							<tr>
								<td colspan="4">{$row.description}</td>
							</tr>
							<tr>
								<td colspan="4" class="text-center">
									<a href="/confirm_purchase_campaign.php?id={$row.campaign_id}" class="btn btn-sm btn-success">Purchase</a>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
				{assign var="ctr" value=0}
			{else}
				{assign var="ctr" value=1}
			{/if}
			<!-- end panel -->
		{foreachelse}

		{/foreach}
		</div>
		<div class="col-md-6 ui-sortable">
		
		{assign var="ctr" value=1}
		{foreach from=$global_campaigns item="row"}
			<!-- begin panel -->
			{if $ctr eq 0}
			<div class="panel panel-inverse" data-sortable-id="form-stuff-1">
				<div class="panel-heading">
					<h4 class="panel-title">Campaign Name: {$row.campaign_name}</h4>
				</div>
				<div class="panel-body">
					<table class="table table-condensed">
						<thead>
							<tr>
								<th>ID</th>
								<th>Cost</th>
								<th>Events</th>
								<th>Max Send After</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>{$row.campaign_id}</td>
								<td>{$row.copy_cost}</td>
								<td>{$row.events_count}</td>
								<td>{$row.max}</td>
							</tr>
							<tr>
								<td colspan="4">{$row.description}</td>
							</tr>
							<tr>
								<td colspan="4" class="text-center">
									<a href="/confirm_purchase_campaign.php?id={$row.campaign_id}" class="btn btn-sm btn-success">Purchase</a>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
				{assign var="ctr" value=1}
			{else}
				{assign var="ctr" value=0}
			{/if}
			<!-- end panel -->
		{foreachelse}

		{/foreach}
		</div>
	</div>
	<!-- end #row -->



</div>
<!-- end #content -->

<script type="text/javascript">
defer(deferred_method);

function defer(method){
	if (window.jQuery)
		method();
	else
		setTimeout(function() { defer(method) }, 50);
}

function deferred_method(){

    // $('.editable-transaction-status').on("click", function(){
    //     var id = $(this).data("company-id");
    //     console.log('clicked id:'+id);
    //     $('.editable-transaction-status').editable('option', 'source', get_transaction_status(id));
    // });

$('.editable-transaction-status, .editable-transaction-types').on("click", function(){
	$(".select2-selection__rendered").html("Select One");
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