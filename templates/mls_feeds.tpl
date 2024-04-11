{include file="includes/header.tpl"}

<!-- begin #content -->
<div id="content" class="content">

	<!-- start breadcrumb -->
	<h1 class="page-header">MLS {$mls_name|upper} LISTINGS
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

		<!-- MLS NEW LISTINGS -->
		<div class="col-md-12">

			<div class="panel panel-inverse" data-sortable-id="form-stuff-1">
				<div class="panel-heading">
					<h4 class="panel-title">NEW MLS {$mls_name|upper} <span class="badge badge-primary m-l-5" style="font-size:80%;">{$total_new_listings}</span></h4>
				</div>
				<div class="panel-body" style="padding: 3px;">
					<div class="table-responsive">
						<table id="personalTemplatesTbl" class="table"> 
							<thead>
								<tr>
									<th>Listing Number</th>
									<th>Address</th>
									<th class="text-center">Bathrooms</th>
									<th class="text-center">Bedrooms</th>
									<th class="text-center">Garage</th>
									<th class="text-center">Year</th>
									<th class="text-center">Status</th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$new_listings item="row"}
								<tr>
									<td>{$row.listing_number}</td>
									<td>{$row.address}</td>
									<td class="text-center">{$row.baths_total}</td>
									<td class="text-center">{$row.beds_total}</td>
									<td class="text-center">{if $row.has_garage}<span class="fa fa-check"></span>{else}<span class="fa fa-times"></span>{/if}</td>
									<td class="text-center">{$row.year_built}</td>
									<td class="text-center">{$row.status}</td>
								</tr>
								{foreachelse}
								<tr><td class="text-center" colspan="7">No New Listings</td></tr>
								{/foreach}
							</tbody>
						</table>
					</div>
				</div>
			</div>
			
		</div>

		<!-- MLS UPDATED LISTINGS -->
		<div class="col-md-12">

			<div class="panel panel-inverse" data-sortable-id="form-stuff-1">
				<div class="panel-heading">
					<h4 class="panel-title">UPDATED MLS {$mls_name|upper} <span class="badge badge-primary m-l-5" style="font-size:80%;">{$total_updated_listings}</span></h4>
				</div>
				<div class="panel-body" style="padding: 3px;">
					<div class="table-responsive">
						<table id="personalTemplatesTbl" class="table">  
							<thead>
								<tr>
									<th>Listing Number</th>
									<th>Address</th>
									<th class="text-center">Bathrooms</th>
									<th class="text-center">Bedrooms</th>
									<th class="text-center">Garage</th>
									<th class="text-center">Year</th>
									<th class="text-center">Status</th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$updated_listings item="row"}
								<tr>
									<td>{$row.listing_number}</td>
									<td>{$row.address}</td>
									<td class="text-center">{$row.baths_total}</td>
									<td class="text-center">{$row.beds_total}</td>
									<td class="text-center">{if $row.has_garage}<span class="fa fa-check"></span>{else}<span class="fa fa-times"></span>{/if}</td>
									<td class="text-center">{$row.year_built}</td>
									<td class="text-center">{$row.status}</td>
								</tr>
								{foreachelse}
								<tr><td class="text-center" colspan="7">No Updated Listings</td></tr>
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