{include file="includes/header.tpl"}

<link href="assets/plugins/summernote/summernote.css" rel="stylesheet" />

<style type="text/css">
.checkbox-css label:before,
.checkbox-css label:after {
	left: 5px !important;
	top: 0 !important;
}
</style>

<!-- begin #content -->
<div id="content" class="content">
	<div class="pull-right">
		<a href="/campaign_list.php" class="btn btn-sm btn-success m-b-5" data-toggle="modal"><i class="fa fa-envelope-open"></i> Campaign List</a>
	</div>

	<!-- start breadcrumb -->
	<h1 class="page-header">Campaign Messages 
		<ol class="breadcrumb" style="display:inline-block;font-size:12px;">
			<li class="active">Sent Emails</li>
		</ol>
	</h1>
	<!-- end breadcrumb -->

	<div id="alert_error" class="alert alert-danger fade in m-b-15 hide">
		<strong>Permission Denied!</strong>
		You don't have permission to access the requested process.
		<span class="close" data-dismiss="alert">×</span>
	</div>

	<div class="row">

		<div class="col-md-12">

			<div class="panel panel-inverse" data-sortable-id="form-stuff-1">
				<div class="panel-heading">
					<h4 class="panel-title">Campaign Messages History <span id="comments_count" class="badge badge-primary m-l-5" style="font-size:80%;">{$total_campaign_messages}</span></h4>
				</div>
				<div class="panel-body" style="padding: 3px;">
					<div class="table-responsive">
						<table id="personalTemplatesTbl" class="table"> 
							<thead>
								<tr>
									<th style="width:20%;"></th>
									<th>Contact Name</th>
									<th>Response</th>
									<th class="text-center">Date Sent</th>
									<th class="text-center">Date Opened</th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$campaigns item="row"}
								<tr class="info">
									<td colspan="5">{$row.campaign_name} : {$row.event_subject}</td>
								</tr>
									{foreach from=$campaign_messages item="message"}
									{if $row.campaign_event_id eq $message.campaign_event_id}
									<tr>
										<td style="width:20%;"></td>
										<td><a href="/contacts_edit.php?id={$message.contact_id}">{$message.first_name} {$message.last_name}</a></td>
										<td>{$message.response}</td>
										<td class="text-center">{$message.date_sent|date_format}</td>
										<td class="text-center">{$message.date_opened|date_format}</td>
									</tr>
									{/if}
									{/foreach}
								{foreachelse}
								<tr><td class="text-center" colspan="5">No Messages Available</td></tr>
								{/foreach}
							</tbody>
						</table>
					</div>
				</div>
			</div>
			
		</div>

	</div>

</div>
<!-- end #content -->

{include file="includes/footer.tpl"}