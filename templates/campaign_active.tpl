{include file="includes/header.tpl"}

<link href="assets/plugins/summernote/summernote.css" rel="stylesheet" />

<style type="text/css">
.checkbox-css label:before,
.checkbox-css label:after {
	left: 5px !important;
	top: 0 !important;
}
.no-pool {
	padding: 15px;
    margin: 20px 0;
    background: rgba(0, 0, 0, 0.85);
    color: #fff;
    -webkit-box-shadow: 0px 0px 15px 1px rgba(0,0,0,0.7);
    -moz-box-shadow: 0px 0px 15px 1px rgba(0,0,0,0.7);
    box-shadow: 0px 0px 15px 1px rgba(0,0,0,0.7);
    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    border-radius: 3px;
}
</style>

<!-- begin #content -->
<div id="content" class="content">
	<div class="pull-right">
		<a href="/campaign_list.php" class="btn btn-sm btn-success m-b-5" data-toggle="modal"><i class="fa fa-envelope-open"></i> Campaign List</a>
	</div>

	<!-- start breadcrumb -->
	<h1 class="page-header">Active Campaigns
		<!-- <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
			<li class="active">Sent Emails</li>
		</ol> -->
	</h1>
	<!-- end breadcrumb -->

	<div id="alert_error" class="alert alert-danger fade in m-b-15 hide">
		<strong>Permission Denied!</strong>
		You don't have permission to access the requested process.
		<span class="close" data-dismiss="alert">×</span>
	</div>

	<div class="row">

		<div class="col-md-12">

			{foreach from=$campaigns item="campaign"}
			<div class="panel panel-inverse" data-sortable-id="form-stuff-1">
				<div class="panel-heading">
					<h4 class="panel-title">{$campaign.campaign_name} <span id="comments_count" class="badge badge-primary m-l-5" style="font-size:80%;">{$total_campaign_messages}</span></h4>
				</div>
				<div class="panel-body" style="padding: 3px;">
					<div class="table-responsive">
						<table id="personalTemplatesTbl" class="table"> 
							<thead>
								<tr>
									<th>Contact Name</th>
									<th class="text-center">Street</th>
									<th class="text-center">City</th>
									<th class="text-center">State</th>
									<th class="text-center">Date Created</th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$campaign_contacts item="contact"}
								{if $campaign.campaign_id eq $contact.campaign_id}
								<tr>
									<td><a href="/contacts_edit.php?id={$contact.contact_id}">{$contact.first_name} {$contact.last_name}</a></td>
									<td class="text-center">{$contact.street_address}</td>
									<td class="text-center">{$contact.city}</td>
									<td class="text-center">{$contact.state}</td>
									<td class="text-center">{$contact.date_added|date_format}</td>
								</tr>
								{/if}
								{/foreach}
							</tbody>
						</table>
					</div>
				</div>
			</div>
			{foreachelse}
			<h5 class="text-center no-pool">No Active Campaigns</h5>
			{/foreach}
			
		</div>

	</div>

</div>
<!-- end #content -->

{include file="includes/footer.tpl"}