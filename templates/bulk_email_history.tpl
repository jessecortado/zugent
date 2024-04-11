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
		<a href="/bulk_email_templates.php" class="btn btn-sm btn-success m-b-5" data-toggle="modal"><i class="fa fa-envelope"></i> Email Template List</a>
		<a href="/bulk_email.php" class="btn btn-sm btn-info m-b-5" data-toggle="modal"><i class="fa fa-send"></i> Sent an Email</a>
	</div>

	<!-- start breadcrumb -->
	<h1 class="page-header">Bulk Email History 
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
					<h4 class="panel-title">Your Email History</h4>
				</div>
				<div class="panel-body" style="padding: 3px;">
					<table id="personalTemplatesTbl" class="table table-striped"> 
						<thead>
							<tr>
								<th>Template Name</th>
								<th>Filters</th>
								<th class="text-center" style="width:25%">Date Queue</th>
								<th class="text-center" style="width:25%">Date Sent</th>
							</tr>
						</thead>
						<tbody>
							{foreach from=$email_logs item="row"}
							<tr>
								<td>Happy Valentines!!</td>
								<td>
									{foreach from=$row.filters item=row key=i}
									{if $row.is_set eq 'true'}{$i} <i class="fa fa-check"></i> {if $row.value ne ''}: {$row.value}{/if}<br>{/if}
									{/foreach}
								</td>
								<td class="text-center">{$row.date_queued|date_format}</td>
								<td class="text-center">{$row.date_sent|date_format|default:'n/a'}</td>
							</tr>
							{foreachelse}
							<tr><td class="text-center" colspan="4">No Template Available</td></tr>
							{/foreach}
						</tbody>
					</table>
				</div>
			</div>
			
		</div>

	</div>

</div>
<!-- end #content -->

{include file="includes/footer.tpl"}