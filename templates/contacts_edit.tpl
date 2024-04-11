{include file="includes/header.tpl"}
<link rel="stylesheet" href="assets/plugins/jquery-confirm/dist/jquery-confirm.min.css">
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
<link href="assets/plugins/bootstrap-eonasdan-datetimepicker/build/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/dropzone/min/dropzone.min.css" rel="stylesheet" />
<link href="assets/css/pages/contacts_edit.css" rel="stylesheet" />
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" />
<style>
</style>

<!-- begin #content -->
<div id="content" class="content" style="padding-bottom:50px">
	{if isset($display_error_message)}
	<div class="alert alert-danger fade in m-b-15">
		<strong>Permission Denied!</strong>
        You don't have permission to access the requested process.
		<span class="close" data-dismiss="alert">×</span>
	</div>
	{/if}

	<!-- begin breadcrumb -->
	<ol class="breadcrumb pull-right">
		<li>Home</li>
		<li><a href="/dashboard.php">Dashboard</a></li>
		<li><a href="/contacts_list.php?undefined=1">Contacts</a></li>
		<li class="active">New</li>
	</ol>
	<!-- end breadcrumb -->

	<!-- begin page-header -->
	<h1 class="page-header">Contacts <small>View / Edit</small></h1>
	<!-- end page-header -->

	{if $show_pool_claimed eq 'true'}
	<div class="alert alert-info text-center">
		<h5 style="color: #242a30">Congratulations. You have claimed this pool lead. Information from the lead has been used to create this contact and the contact has been assigned to you.<br><br>It is important to maintain a constant line of communication to your contact.</h5>
	</div>
	{/if}


	<!-- Contact Details Panel -->
	<form action="/contacts_edit.php" method="POST" data-parsley-validate="true">
		<input type="hidden" name="id" value="{$contact_data.contact_id}"/>
		<input type="hidden" name="contact_email_id" value="{$contact_data.contact_email_id}"/>
		<input type="hidden" name="contact_phone_id" value="{$contact_data.contact_id}"/>
		<input type="hidden" name="a" value="u"/>

		<div class="panel panel-inverse">
			<div class="panel-heading">
				<h4 class="panel-title">Contact Categorization</h4>
			</div>
			<div class="panel-body">
				<fieldset>
					<div class="row">
						<div class="col-md-12">
							<div class="form-group">
								<label for="bucket">Bucket</label>
								<select class="form-control" name="bucket_id" id="bucket">
									<option value="">Select Bucket</option>
									{foreach item=row from=$buckets}
									<option value="{$row.bucket_id}" {if $row.bucket_id eq $contact_data.bucket_id}SELECTED{/if} >{$row.bucket_name}</option>
									{/foreach}
								</select>
							</div>
						</div>
					</div>
				</fieldset>
			</div>
		</div>



		<div class="panel panel-inverse">
			<div class="panel-heading">
				{if $contact_data.latitude ne '' and $contact_data.longitude ne ''}
				<div class="panel-heading-btn">
					<a href="https://www.google.com/maps/dir/?api=1&destination={$contact_data.latitude},{$contact_data.longitude}" target="_blank" class="btn btn-xs btn-success m-r-5 m-b-5"><i class="fa fa-map-marker"></i> Open in Maps</a>
				</div>
				{/if}
				<h4 class="panel-title">Contact Details</h4>
			</div>
			<div class="panel-body">
				<fieldset>
					<div class="row">
						<div class="col-md-3">
							<div class="form-group">
								<label for="event_subject">First Name</label>
								<input type="text" class="form-control" value="{$contact_data.first_name}" name="first_name" id="first_name" placeholder="First Name" data-parsley-required="true" />
							</div>
						</div>
						<div class="col-md-3">
							<div class="form-group">
								<label for="event_subject">Last Name</label>
								<input type="text" class="form-control" value="{$contact_data.last_name}" name="last_name" id="last_name" placeholder="Last Name" data-parsley-required="true" />
							</div>
						</div>
						<div class="col-md-3">
							<div class="form-group">
								<label for="event_subject">Primary Phone</label>
								<input type="text" class="form-control phone-us" name="primary_phone" id="primary_phone" value="{$contact_data.primary_phone|default:'(000) 000-0000'}" placeholder="(000) 000-0000" data-parsley-required="true" />
							</div>
						</div>
						<div class="col-md-3">
							<div class="form-group">
								<label for="event_subject">Primary Email</label>
								<input type="text" class="form-control" value="{$contact_data.primary_email|default:''}" name="primary_email" id="primary_email" placeholder="user@domain.com" data-parsley-required="true" />
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-md-12">
							<div class="form-group">
								<label for="event_subject">Street Address</label>
								<input type="text" class="form-control" name="street_address" id="street_address" value="{$contact_data.street_address}" placeholder="Street Address" data-parsley-required="true" />
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-md-4">
							<div class="form-group">
								<label for="event_subject">City</label>
								<input type="text" class="form-control" name="city" id="city" placeholder="City" value="{$contact_data.city}" />
							</div>
						</div>
						<div class="col-md-3">
							<div class="form-group">
								<label for="event_subject">State</label>
								<select class="form-control" name="state" id="state" />
									<option value="">--</option>
									{include file="includes/states.tpl"}
								</select>
							</div>
						</div>
						<div class="col-md-3">
							<div class="form-group">
								<label for="event_subject">County</label>
								<input type="text" class="form-control" name="county" id="county" value="{$contact_data.county}" placeholder="County" />
							</div>
						</div>
						<div class="col-md-2">
							<div class="form-group">
								<label for="event_subject">Zip</label>
								<input type="text" class="form-control" name="zip" id="zip" placeholder="Zip Code" value="{$contact_data.zip}" />
							</div>
						</div>
					</div>

					{if $user.is_admin eq 1 or $user.is_superadmin eq 1}
					{* MLS and Is referral should only show up for admin or superadmin *}
					<div class="row">
						<div class="col-md-4">
							<div class="form-group">
								<label for="mls_number">MLS Number</label>
								<input type="text" class="form-control" name="mls_number" id="mls-number" placeholder="MLS Number" value="{$contact_data.mls_number}" data-parsley-required="false"/>
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group">
								<label for="mls_number">Contact Source</label>
								<input type="text" class="form-control" name="contact_source" id="contact_source" placeholder="Source" value="{$contact_data.contact_source}" data-parsley-required="false"/>
							</div>
						</div>

					</div>
					{/if}

					<div class="form-group">
						<label class="control-label">Summary</label>
						<textarea class="form-control" name="summary" id="summary">{$contact_data.summary}</textarea>
					</div>
				</fieldset>

				<button type="submit" class="btn btn-sm btn-primary m-r-5"><i class="fa fa-save"></i> Save Contact Details</button>

			</div>
		</div>
	</form>
	<!-- End Contact Details Panel -->

	<!-- Tabs -->
	<ul class="nav nav-pills">
		<li class="active"><a href="#nav-pills-tab-1" data-toggle="tab"><i class="fa fa-comments-o m-r-5"></i><span class="hidden-xs">Comments</span></a></li>
	</ul>
	<div class="tab-content" style="padding:0;">
		<div class="tab-pane fade active in" id="nav-pills-tab-1">
			<!-- Comments panel -->
			<div class="panel panel-inverse" id="panel-comments">
				<div class="panel-heading">
					<div class="panel-heading-btn">
						<a href="#modal-add-contact-comment" data-toggle="modal" class="btn btn-xs btn-success" style="margin-top: -1px;"><i class="fa fa-plus"></i>Add Comment</a>
					</div>
					<h4 class="panel-title">Comments<span id="comments_count" class="badge badge-primary m-l-5" style="font-size:80%;">{$contact_comments|count}</span></h4>
				</div>
                <div id="alert_success_comment" class="alert alert-success fade in hide flash">
                    <strong>Success!</strong>
                    <span id="msg"></span>
                    <span class="close" data-dismiss="alert">×</span>
                </div>
				<div class="panel-body">
					<input type="hidden" name="id" value="{$campaign.campaign_id}">
					<input type="hidden" name="action" value="n">
					<fieldset>
						<div class="row">
							<div class="col-md-12">
								<div class="table-responsive">
									<table class="table table-condensed" id="commentsTbl" name="commentsTbl">
										<thead>
											<tr>
												<th>Source</th>
												<th>Message</th>
											</tr>
										</thead>
										<tbody>
											{foreach from=$contact_comments item='comment'}
											<tr>
												<td style="width: 200px;">
													<b>{$comment.first_name} {$comment.last_name}</b><br/>
													<small>{$comment.date_added|date_format:'%b'}{$comment.date_added|date_format:" jS, "}{$comment.date_added|date_format:'%Y'}</small><br/>
												</td>
												<td style="white-space:pre;">{$comment.comment}
												</td>
											</tr>
											{foreachelse}
							            	<tr class="no-data"><td class="text-center" colspan="2">No Comments Available</td></tr>
											{/foreach}
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</fieldset>
				</div>
			</div>
			<!-- End Comments -->
		</div>

		{* If the user is not an admin and there are no referrals. Hide the referrals. *}

       	{if $company.has_referrals eq 1}
		{if ($contact_referrals|count ne 0 and $user.is_admin eq 0 and $user.is_superadmin eq 0) or ($user.is_admin eq '1' or $user.is_superadmin eq '1')}
		<div class="tab-pane fade" id="nav-pills-tab-3">
			<!-- Referrals Panel -->
			<div class="panel panel-inverse" id="panel-referrals" >
				<div class="panel-heading">
					{if $user.is_admin eq '1' or $user.is_superadmin eq '1'}
					<div class="panel-heading-btn">
						<a id="add-referral" href="#modal-add-referral" data-toggle="modal" class="btn btn-xs btn-success" style="margin-top: -1px;"><i class="fa fa-plus"></i>Add Referral</a>
					</div>
					{/if}
					<h4 class="panel-title">Referrals<span id="referrals_count" class="badge badge-primary m-l-5" style="font-size:80%;">{$contact_referrals|count+$contact_referrals_notactive|count}</span></h4>
				</div>
                <div id="alert_success_referral" class="alert alert-success fade in hide flash">
                    <strong>Success!</strong>
                    <span id="msg"></span>
                    <span class="close" data-dismiss="alert">×</span>
                </div>
				<div class="panel-body">
					<fieldset>

						<div class="row">
							<div class="col-md-12">
								<div class="table-responsive">
									<table class="table table-condensed" id="referralsTbl" name="referralsTbl">
										<thead>
											<tr>
												<th>#</th>
												<th class="text-center">Referred By</th>
												<th class="text-center">Referred To</th>
												<th class="text-center">Referral Source</th>
												<th class="text-center">Referral Date</th>
												{if $user.is_admin eq '1' or $user.is_superadmin eq '1'}
												<th class="text-center">Actions</th>
												{/if}
											</tr>
										</thead>
										<tbody>
											{foreach from=$contact_referrals item='row'}
											<tr id="rf-{$row.contact_referral_id}">
												<td>{$row.contact_referral_id}</td>
												<td class="text-center">{$row.referred_by}</td>
												<td class="text-center">{$row.referred_to}</td>
												<td class="text-center">{$row.referral_source}</td>
												<td class="text-center">{$row.date_referral|date_format:'%b'}{$row.date_referral|date_format:" jS, "}{$row.date_referral|date_format:'%Y'}</td>
											{if $user.is_admin eq '1' or $user.is_superadmin eq '1'}
											<!-- <td>
												<input type="checkbox" class="form-control m-r-5 m-b-5 mark-referral-counted" data-referral-id="{$row.contact_referral_id}" {if $row.is_counted eq '1'} checked="true" {/if}>
											</td> -->
											<td class="text-center" nowrap>
												{if $row.is_active eq '1'}
												<a href="#modal-edit-referral" class="btn btn-xs btn-info m-r-5 m-b-5 btn-edit-referral" data-referral-id="{$row.contact_referral_id}" data-user-id="{$row.user_id}" data-source="{$row.referral_source}" data-bob="{$row.referral_bob}" data-toggle="modal"><i class="glyphicon glyphicon-edit"></i>Edit</a>
												<a href="javascript:void(0)" class="btn btn-xs btn-danger m-r-5 m-b-5 deactivate-referral" data-referral-id="{$row.contact_referral_id}"><i class="glyphicon glyphicon-remove"></i>Remove Referral</a>
												{/if}
											</td>
											{/if}
											</tr>
											{foreachelse}
				                        	<tr class="no-data"><td class="text-center" colspan="6">No Referrals Available</td></tr>
											{/foreach}
										</tbody>
									</table>
								</div>
							</div>
						</div>

						{if $user.is_admin eq 1}
						<div class="panel panel-inverse" style="margin-bottom:0;display:{if $contact_referrals_notactive|count gt 0}block{else}none{/if};" id="removed-referral-panel">
							<div class="panel-heading" style="background:gray;">
								<div class="panel-heading-btn">
									<a href="javascript:void(0)" id="toggle-removed-referrals" class="btn btn-xs btn-info ellips" data-click="panel-collapse" style="margin-top: -1px;">
										<i class="fa fa-expand"></i> Show {$contact_referrals_notactive|count} Deactivated Referrals
									</a>
								</div>
								<h4 class="panel-title">Deactivated Referrals</h4>
							</div>
							<div class="panel-body" style="padding: 3px; display: none;">
								<div class="row">
									<div class="col-md-12">
										<div class="table-responsive">
											<table class="table table-condensed" id="removedReferralsTbl" name="removedReferralsTbl">
												<thead>
													<tr>
														<th class="text-left">#</th>
														<th class="text-center">Referred By</th>
														<th class="text-center">Referred To</th>
														<th class="text-center">Referral Source</th>
														<th class="text-center">Referral Date</th>
														{if $user.is_admin eq '1' or $user.is_superadmin eq '1'}
														<th class="text-center">Actions</th>
														{/if}
													</tr>
												</thead>
												<tbody>
													{foreach from=$contact_referrals_notactive item='row'}
													<tr>
														<td class="text-left">{$row.contact_referral_id}</td>
														<td class="text-center">{$row.referred_by}</td>
														<td class="text-center">{$row.referred_to}</td>
														<td class="text-center">{$row.referral_source}</td>
														<td class="text-center">{$row.date_referral|date_format:'%b'}{$row.date_referral|date_format:" jS, "}{$row.date_referral|date_format:'%Y'}</td>
														<td class="text-center">
															<a href="javascript:void(0)" class="btn btn-xs btn-primary m-r-5 m-b-5 activate-referral" data-referral-id="{$row.contact_referral_id}"><i class="glyphicon glyphicon-ok"></i>Activate Referral</a>
														</td>
													</tr>
													{/foreach}
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
						{/if}
					</fieldset>

				</div>
			</div>
			<!-- End Referrals Panel -->
		</div>
		{/if}
		{/if}


        {if $company.has_transactions eq 1}
		<div class="tab-pane fade" id="nav-pills-tab-4">
			<!-- Transaction Panel -->
			<div class="panel panel-inverse" id="panel-transaction">
				<div class="panel-heading">
					<div class="panel-heading-btn">
						<a href="#modal-add-transaction" data-toggle="modal" class="btn btn-xs btn-success" style="margin-top: -1px;" id="add-transaction"><i class="fa fa-plus"></i>Add Transaction</a>
					</div>
					<h4 class="panel-title">Transactions<span id="transaction-count" class="badge badge-primary m-l-5" style="font-size:80%;">{$transactions|count}</span></h4>
				</div>
                <div id="alert_success_transaction" class="alert alert-success fade in hide flash">
                    <strong>Success!</strong>
                    <span id="msg"></span>
                    <span class="close" data-dismiss="alert">×</span>
                </div>
				<div class="panel-body">
					<div class="table-responsive">
						<table id="transactionTbl" class="table table-striped">
							<thead>
								<tr>
									<th>#</th>
									<th class="text-center">MLS #</th>
									<th class="text-center">Date Created</th>
									<th class="text-center">Type</th>
									<th class="text-center">Status</th>
									<th class="text-center">Actions</th>
								</tr>
							</thead>
							<tbody>
								{foreach item=row from=$transactions}
								<tr>
									<td>
										{$row.transaction_id}
									</td>
									<td class="text-center">
										{if $row.is_on_mls eq 1}
											{$row.listing_number}
										{/if}
									</td>
									<td class="text-center">
										{$row.date_created|date_format:'%b'}{$row.date_created|date_format:" jS, "}{$row.date_created|date_format:'%Y'}
									</td>
									<td class="text-center">
										{$row.transaction_type}
									</td>
									<td class="text-center">
										{$row.transaction_status}
									</td>
									<td class="text-center">
										<a href="transaction/{$row.transaction_id}" class="btn btn-info btn-xs m-r-5 m-b-5 btn-delete" data-transaction-id="{$row.transaction_id}"><i class="glyphicon glyphicon-eye-open"></i>View</a>
										<!-- <a href="javascript:;" class="btn btn-danger btn-xs m-r-5 m-b-5 btn-delete" data-transaction-id="{$row.transaction_id}"><i class="glyphicon glyphicon-remove"></i>Delete</a> -->
									</td>
								</tr>
								{foreachelse}
				            	<tr class="no-data"><td class="text-center" colspan="6">No Transactions Available</td></tr>
								{/foreach}
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<!-- End Transaction -->
		</div>
		{/if}

		<div class="tab-pane fade" id="nav-pills-tab-5">
			<!-- Attached Files Panel -->
			<div class="panel panel-inverse" id="panel-contactfile">
				<div class="panel-heading">
					<div class="panel-heading-btn">
						<a href="#modal-add-contact-file" data-toggle="modal" class="btn btn-xs btn-success" style="margin-top: -1px;"><i class="fa fa-plus"></i>Attached Files</a>
					</div>
					<h4 class="panel-title">Attached Files<span class="badge badge-primary m-l-5" style="font-size:80%;">{$contact_files|count+$deleted_contact_files|count}</span></h4>
				</div>
                <div id="alert_success_attachedfile" class="alert alert-success fade in hide flash">
                    <strong>Success!</strong>
                    <span id="msg"></span>
                    <span class="close" data-dismiss="alert">×</span>
                </div>
				<div class="panel-body">
					<div class="row">
						<div class="col-md-12">
							<div class="table-responsive">
								<table class="table table-condensed" id="contactFilesTbl" name="contactFilesTbl">
									<thead>
										<tr>
											<th>File Name</th>
											<th class="text-center">File Type</th>
											<th class="text-center">Date Uploaded</th>
											<th class="text-center">Actions</th>
										</tr>
									</thead>
									<tbody>
										{foreach from=$contact_files item='row'}
										<tr id="cf-{$row.contact_file_id}">
											<td>
												<b>{$row.file_name}</b>
											</td>
											<td class="text-center">
												{$row.file_type_name}
											</td>
											<td class="text-center">
												{$row.date_uploaded|date_format:'%b'}{$row.date_uploaded|date_format:" jS, "}{$row.date_uploaded|date_format:'%Y'}
											</td>
											<td class="text-center">
												<a href="#modal-edit-file" class="btn btn-xs btn-info m-r-5 m-b-5 edit-contact-file" data-toggle="modal" data-contact-file-id="{$row.contact_file_id}" data-file-type-name="{$row.file_type_name}" data-contact-file-type="{$row.file_type_id}" data-file-name="{$row.file_name}"><i class="glyphicon glyphicon-edit"></i>Edit</a>

												<a href="https://s3-us-west-2.amazonaws.com/zugent{$row.file_key}" target="_blank" class="btn btn-xs btn-info m-r-5 m-b-5" data-file-type-name="{$row.file_type_name}" data-contact-file-id="{$row.contact_file_id}"><i class="glyphicon glyphicon-edit"></i>Download</a>

												<a data-href="javascript:void(0)" class="btn btn-xs btn-danger m-r-5 m-b-5 btn-delete-contact-file" data-contact-file-id="{$row.contact_file_id}"><i class="glyphicon glyphicon-remove"></i>Delete</a>
											</td>
										</tr>
										{foreachelse}
						            	<tr class="no-data"><td class="text-center" colspan="4">No Files Attached Available</td></tr>
										{/foreach}
									</tbody>
								</table>
							</div>
						</div>
					</div>


					{if $user.is_admin eq 1}
					<div class="panel panel-inverse" style="margin-bottom:0;display:{if $dfc_count gt 0}block{else}none{/if}" id="deleted-attachedfile-panel">
						<div class="panel-heading" style="background:gray;">
							<div class="panel-heading-btn">
								<a href="javascript:void(0)" id="toggle-deleted-files" data-toggle="modal" class="btn btn-xs btn-info ellips" data-click="panel-collapse" style="margin-top: -1px;">
									<i class="fa fa-expand"></i> Show {$dfc_count} Deleted Files
								</a>
							</div>
							<h4 class="panel-title">Deleted Files</h4>
						</div>
						<div class="panel-body" style="padding: 3px; display: none;">
							<div class="row">
								<div class="col-md-12">
									<div class="table-responsive">
										<table class="table table-condensed" id="deletedContactFilesTbl" name="deletedContactFilesTbl">
											<thead>
												<tr>
													<th>File Name</th>
													<th class="text-center">File Type</th>
													<th class="text-center">Date Uploaded</th>
													<th class="text-center">Actions</th>
												</tr>
											</thead>
											<tbody>
												{foreach from=$deleted_contact_files item='row'}
												<tr>
													<td>
														<b>{$row.file_name}</b>
													</td>
													<td class="text-center">
														{$row.file_type_name}
													</td>
													<td class="text-center">
														{$row.date_uploaded|date_format:'%b'}{$row.date_uploaded|date_format:" jS, "}{$row.date_uploaded|date_format:'%Y'}
													</td>
													<td class="text-center">
														<a data-href="javascript:void(0)" class="btn btn-xs btn-info m-r-5 m-b-5 btn-restore-contact-file" data-contact-file-id="{$row.contact_file_id}" data-btn-ok-label="Restore" data-btn-ok-icon="glyphicon glyphicon-share-alt" data-btn-ok-class="btn-info btn-sm" data-btn-cancel-label="Cancel" data-btn-cancel-icon="glyphicon glyphicon-ban-circle" data-btn-cancel-class="btn-danger btn-sm" data-toggle="confirmation" data-placement="left"><i class="glyphicon glyphicon-remove"></i>Restore</a>
													</td>
												</tr>
												{/foreach}
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
					{/if}
				</div>
			</div>
			<!-- End Attached Files -->
		</div>
		<div class="tab-pane fade" id="nav-pills-tab-6">
			<!-- MLS Searches Panel -->
			<div class="panel panel-inverse" id="panel-searches">
				<div class="panel-heading">
					{if $user.is_admin eq '1' or $user.is_superadmin eq '1'}
					<div class="panel-heading-btn">
						<a id="add-searches" href="#modal-add-searches" data-toggle="modal" class="btn btn-xs btn-success" style="margin-top: -1px;"><i class="fa fa-plus"></i>Add Search</a>
					</div>
					{/if}
					<h4 class="panel-title">MLS Searches<span id="searches_count" class="badge badge-primary m-l-5" style="font-size:80%;">{$mls_searches|count}</span></h4>
				</div>
                <div id="alert_success_searches" class="alert alert-success fade in hide flash">
                    <strong>Success!</strong>
                    <span id="msg"></span>
                    <span class="close" data-dismiss="alert">×</span>
                </div>
				<div class="panel-body">
					<fieldset>
						<div class="row">
							<div class="col-md-12">
								<div class="table-responsive">
									<table class="table table-condensed" id="searchesTbl" name="searchesTbl">
										<thead>
											<tr>
												<th>#</th>
												<th class="text-center">Active</th>
												<th class="text-center">Date Modified</th>
												<th class="text-center">Bedrooms</th>
												<th class="text-center">Bathrooms</th>
												<th class="text-center">City</th>
												<th class="text-center">County</th>
												<th class="text-center">Type</th>
												{if $user.is_admin eq '1' or $user.is_superadmin eq '1'}
												<th class="text-center">Actions</th>
												{/if}
											</tr>
										</thead>
										<tbody>
											{foreach from=$mls_searches item='row'}
											<tr id="rf-{$row.contact_search_id}">
											  <td>{$row.contact_search_id}</td>
												<td class="text-center">{$row.is_active}</td>
											  <td class="text-center">{$row.date_modified}</td>
											  <td class="text-center">{$row.max_bedroom}</td>
											  <td class="text-center">{$row.max_bathroom}</td>
												<td class="text-center">{$row.city}</td>
											  <td class="text-center">{$row.county}</td>
											  <td class="text-center">{$row.listing_type}</td>
											{if $user.is_admin eq '1' or $user.is_superadmin eq '1'}
											<td class="text-center" nowrap>
											  {if $row.is_active eq '1'}
											  <a href="#modal-edit-searches" class="btn btn-xs btn-info m-r-5 m-b-5 btn-edit-searches"
												data-search-id="{$row.contact_search_id}" data-search-city="{$row.city}"
												data-search-state="{$row.state}" data-search-zip="{$row.zip}"
												data-search-county="{$row.county}" data-search-listing_class="{$row.listing_class}"
												data-search-type="{$row.listing_type}"
												data-search-min_bedroom="{$row.min_bedroom}" data-search-max_bedroom="{$row.max_bedroom}"
												data-search-min_bathroom="{$row.min_bathroom}" data-search-max_bathroom="{$row.max_bathroom}"
												data-search-min_sqft="{$row.min_sqft}" data-search-max_sqft="{$row.max_sqft}"
												data-toggle="modal"><i class="glyphicon glyphicon-edit"></i>Edit</a>
											  <a href="javascript:void(0)" class="btn btn-xs btn-danger m-r-5 m-b-5 deactivate-searches" data-searches-id="{$row.contact_search_id}"><i class="glyphicon glyphicon-remove"></i>Remove Search</a>
											  {/if}
											</td>
											{/if}
											</tr>
											{foreachelse}
											            <tr class="no-data"><td class="text-center" colspan="6">No MLS Searches Available</td></tr>
											{/foreach}
										</tbody>
									</table>
								</div>
							</div>
						</div>

					</fieldset>
				</div>
			</div>
			<!-- End MLS Searches Panel -->
		</div>

	</div>
	<!-- End Tabs -->

</div>
<!-- end #content -->

	{* Design 1

	<div class="row" style="padding-top:30px;">
      <div class="col-md-12">
        <div class="material-button-anim">
          <ul class="list-inline hidden" id="floating-options">
            <li class="option hidden">
              <a href="tel:{$contact_data.primary_phone}" class="btn material-button option1" type="button">
                <span style="padding-top: 18px;" class="fa fa-phone" aria-hidden="true"></span>
              </a>
            </li>
            <li class="option hidden">
              <button class="material-button option2" type="button">
                <span class="fa fa-envelope-o" aria-hidden="true"></span>
              </button>
            </li>
            <li class="option hidden">
              <button class="material-button option3" type="button" data-click="scroll-top">
                <span class="fa fa-angle-up" aria-hidden="true"></span>
              </button>
            </li>
            <li class="option hidden">
              <button class="material-button option4" type="button" data-click="scroll-top">
                <span class="fa fa-angle-up" aria-hidden="true"></span>
              </button>
            </li>
          </ul>
          <button class="material-button material-button-toggle" type="button">
            <span class="fa fa-plus" aria-hidden="true"></span>
          </button>
        </div>
      </div>
	</div>

	*}


{*
<div class="container-fluid">
  <div class="row">
    <div class="col-md-12">
      <div class="btn-group-sm hidden" id="mini-fab">
		{if $contact_data.is_unsubscribed eq 0}
	        <a href="#xmodal-send-message" class="btn btn-info btn-fab xbtn-sec" data-toggle="modal" rel="tooltip" data-placement="left" data-original-title="Email" title="" data-cid="{$contact_data.contact_id}" id="email">
	        	<span class="fa fa-envelope-o" aria-hidden="true"></span>
	        </a>
		{else}
			<a href="javascript:;" data-toggle="modal" rel="tooltip" data-placement="left" title="This contact has unsubscribed from emails from Zugent" class="btn btn-info btn-fab" id="email">
				<span class="fa fa-envelope-o" aria-hidden="true"></span>
			</a>
		{/if}
        <a href="#xmodal-send-letter" class="btn btn-info btn-fab xbtn-sec" data-toggle="modal" rel="tooltip" data-placement="left" data-original-title="Letter" title="" data-cid="{$contact_data.contact_id}" id="letter">
        	<span class="fa fa-envelope" aria-hidden="true"></span>
        </a>
        <a href="tel:{$contact_data.primary_phone}" class="btn btn-warning btn-fab" rel="tooltip" data-placement="left" data-original-title="Call" title="" id="call">
        	<span class="fa fa-phone" aria-hidden="true"></span>
        </a>
        <a href="#modal-add-referral" data-toggle="modal" class="btn btn-danger btn-fab" rel="tooltip" data-placement="left" data-original-title="Schedule Follow Up / Contact" title="" id="calendar">
        	<span class="fa fa-calendar" aria-hidden="true"></span>
        </a>
        <a href="javascript:;" class="btn btn-info btn-fab" data-click="scroll-top" data-placement="left" data-original-title="Back to top" title="Back to top" id="scroll-top">
        	<span class="fa fa-angle-up"></span>
        </a>
      </div>
      <div class="btn-group">
        <a href="javascript:void(0)" class="btn btn-success btn-fab" id="floating-options">
            <span class="fa fa-plus" aria-hidden="true"></span>
        </a>
      </div>
    </div>
  </div>
</div>
*}


<!-- Modals Section -->
<div class="modal fade" id="modal-add-user" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Assign a User</h4>
			</div>
			<div class="panel" style="margin-bottom:0;">
				<div class="modal-body panel-body p-20">
					<form id="form-add-user" method="post" data-parsley-validate="true">
						{* Removed due to users only being assigned from the same company

						<label class="control-label">Company</label>

						<div style="width:100%;" class="input-group">
							<select id="companies" name="company_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#companies-errors">
								<option value="">Select a Company</option>
								{foreach from=$companies item='row'}
								<option value="{$row.company_id}">{$row.company_name}</option>
								{/foreach}
							</select>
							<div id="companies-errors"></div>
						</div>

						*}

						<label class="control-label">User</label>
						<div class="form-group">
							<div style="width:100%;" class="input-group">
								<select id="select-users" name="user_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#companies-errors">
									<option value="">Select a User</option>
									{foreach from=$company_available_users item='row'}
									<option value="{$row.user_id}">{$row.first_name} {$row.last_name}</option>
									{/foreach}
								</select>
								<div id="companies-errors"></div>
							</div>
						</div>

						<input type="hidden" id="contact-id" name="contact_id" value="{$contact_data.contact_id}"/>
						<input type="hidden" id="action" name="action" value="add_user_to_contact"/>
					</form>
				</div>
			</div>
			<div class="modal-footer">
				<a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="modal-save" class="btn btn-sm btn-success"><i class="glyphicon glyphicon-plus"></i> Assign</a>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modal-add-office" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Assign an Office</h4>
			</div>
			<div class="panel" style="margin-bottom:0;">
				<div class="modal-body panel-body p-20">
					<form id="form-add-offices" data-parsley-validate="true">
						<label class="control-label">Office</label>
						<div class="form-group">
							<div style="width:100%;" class="input-group">
								<select class="form-control select2" name="offices" id="offices" data-parsley-required="true" data-parsley-errors-container="#offices-errors">
									<option value="">Select One</option>
									{foreach item=row from=$offices}
									<option value="{$row.office_id}">{$row.name}</option>
									{/foreach}
								</select>
								<div id="offices-errors"></div>
							</div>
						</div>
					</form>
				</div>
			</div>
			<div class="modal-footer">
				<a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="btn-add-office" class="btn btn-sm btn-success"><i class="glyphicon glyphicon-plus"></i> Assign</a>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modal-add-campaign" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Subscribe to a Campaign</h4>
			</div>
			<div class="panel" style="margin-bottom:0;">
				<div class="modal-body panel-body p-20">
					<form id="form-add-campaigns" data-parsley-validate="true">
						<label class="control-label">Campaign</label>
						<div class="form-group">
							<div style="width:100%;" class="input-group">
								<select class="form-control select2" name="campaigns" id="campaigns" data-parsley-required="true" data-parsley-errors-container="#campaigns-errors">
									<option value="">--</option>
									{foreach from=$campaigns item='campaign_data'}
									<option value="{$campaign_data.campaign_id}">{$campaign_data.campaign_name}</option>
									{/foreach}
								</select>
								<div id="campaigns-errors"></div>
							</div>
						</div>
					</form>
				</div>
			</div>
			<div class="modal-footer">
				<a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="btn-add-campaign" class="btn btn-sm btn-success"><i class="glyphicon glyphicon-plus"></i> Subscribe</a>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modal-add-appointment" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Schedule Follow-Up / Contact</h4>
			</div>
			<div class="panel" style="margin-bottom:0;">
				<div class="modal-body panel-body p-20">
					<form id="form-add-appointment" method="post" data-parsley-validate="true" data-form-action="">
						<label class="control-label">Date</label>

						<div class="form-group">
							<div class="input-group">
								<input id="appointment-date" type="text" class="date form-control" data-parsley-required="true"/>
								<span class="input-group-addon">
									<span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
						</div>

						<label class="control-label">Follow-Up / Contact Type</label>
						<div class="form-group">
							<div style="width:100%;" class="input-group">
								<select id="appointment-type" name="appointment_type_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#appointment-type-errors">
									{foreach from=$appointment_types item='row'}
									<option value="{$row.appointment_type_id}">{$row.appointment_type}</option>
									{/foreach}
								</select>
							</div>
							<div id="appointment-type-errors"></div>
						</div>

						<label class="control-label">Description</label>
						<div class="form-group">
							<div style="width:100%;" class="input-group">
								<textarea id="description" name="description" class="form-control" data-parsley-required="true"></textarea>
							</div>
						</div>

						<input type="hidden" name="date_appointment" id="selected-appointment-date" />
						<input type="hidden" id="appointment-type-name" name="appointment_type" value=""/>
						<input type="hidden" id="contact-id" name="contact_id" value="{$contact_data.contact_id}"/>
						<input type="hidden" id="contact-appointment-id" name="contact_appointment_id" value=""/>
					</form>
				</div>
			</div>
			<div class="modal-footer">
				<a id="close-add-modal" href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="modal-save" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modal-complete-appointment" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Complete Follow-Up / Contact</h4>
			</div>
			<div class="modal-body p-20">
				<form id="form-complete-appointment" method="post" data-parsley-validate="true">

					<label class="control-label">Completion Notes</label>
					<div class="form-group">
						<div style="width:100%;"  class="input-group">
							<textarea id="completion-notes" name="completion_notes" class="form-control" data-parsley-required="true"></textarea>
						</div>
					</div>

					<input type="hidden" id="contact-id" name="contact_id" value="{$contact_data.contact_id}"/>
					<input type="hidden" id="contact-appointment-id" name="contact_appointment_id" value=""/>
				</form>
			</div>
			<div class="modal-footer">
				<a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="complete-appointment" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modal-edit-file" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Edit Content File</h4>
			</div>
			<div class="modal-body p-20">
				<form id="form-edit-contact-file" action="/ws/contact/attached_file/edit" method="post" data-parsley-validate="true">

					<label class="control-label">File Type</label>
					<div class="form-group">
						<div style="width:100%;" class="input-group">
							<select style="width:100%;" name="file_type" class="form-control" id="modal-contact-file-type" data-parsley-required="true" data-parsley-errors-container="#file-type-errors">
								{foreach from=$file_types item='row'}
								<option value="{$row.file_type_id}">{$row.name}</option>
								{/foreach}
							</select>
						</div>
						<div id="file-type-errors"></div>
					</div>

					<label class="control-label">File Name</label>
					<div class="form-group">
						<div style="width:100%;" class="input-group">
							<input class="form-control" type="text" name="file_name" id="modal-contact-file-name" data-parsley-required="true"/>
						</div>
					</div>

					<input type="hidden" id="modal-contact-id" name="contact_id" value="{$contact_data.contact_id}"/>
					<input type="hidden" id="modal-file-type-id" name="file_type_id" value="">
					<input type="hidden" id="modal-contact-file-id" name="contact_file_id" value=""/>
				</form>
			</div>
			<div class="modal-footer">
				<a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="#form-edit-contact-file" id="save-contact-file" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modal-add-transaction" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Add Transaction</h4>
			</div>
			<div class="modal-body p-20">
				<!-- <form id="form-add-transaction" action="/services/transaction_manager.php" method="post"> -->
				<form id="form-add-transaction" method="post" data-parsley-validate="true">

					<label class="control-label">Transaction Type</label>
					<div class="form-group">
						<div style="width:100%;" class="input-group">
							<select style="width:100%;" name="transaction_type_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#tt_id_error">
								<option value="">Select a Type</option>
								{foreach from=$transaction_types item='row'}
								<option value="{$row.transaction_type_id}">{$row.transaction_type}</option>
								{/foreach}
							</select>
						</div>
						<div id="tt_id_error"></div>
					</div>

					<label class="control-label">Transaction Status</label>
					<div class="form-group">
						<div style="width:100%;" class="input-group">
							<select style="width:100%;" name="transaction_status_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#ts_id_error">
								<option value="">Select a Status</option>
								{foreach from=$transaction_status item='row'}
								<option value="{$row.transaction_status_id}">{$row.transaction_status}</option>
								{/foreach}
							</select>
						</div>
						<div id="ts_id_error"></div>
					</div>

					<label class="control-label">Description</label>
					<div class="form-group">
						<div style="width:100%;" class="input-group">
							<textarea style="width:100%;" name="description" class="form-control" data-parsley-required="true" data-parsley-errors-container="#tdesc_id_error"></textarea>
						</div>
						<div id="tdesc_id_error"></div>
					</div>

					<input type="hidden" id="contact-id" name="contact_id" value="{$contact_data.contact_id}"/>
					<!-- <input type="hidden" id="action" name="action" value="add_contact_transaction"/> -->
				</form>
			</div>
			<div class="modal-footer">
				<a id="close-add-modal" href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="btn-add-transaction" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modal-show-comments" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Follow-Up / Contact Comments<span></span></h4>
			</div>
			<div class="modal-body p-20">
				<div id="modal-comments-body"></div>
			</div>
			<div class="modal-footer">
				<form id="form-add-appointment-comment" data-parsley-validate="true">
					<div class="input-group input-group-sm">
						<input id="appointment-comment" type="text" class="form-control" placeholder="Enter appointment comment" data-parsley-required="true" data-parsley-errors-container="#appointment-comment-error">
						<div class="input-group-btn">
							<button type="button" id="add-appointment-comment" class="btn btn-success"><i class="glyphicon glyphicon-plus"></i> Add Comment </button>
						</div>
					</div>
					<div id="appointment-comment-error" style="text-align:left"></div>
					<input type="hidden" name="contact_appointment_id"/>
				</form>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modal-add-contact-comment" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Comments<span></span></h4>
			</div>
			<div class="modal-body p-20">
				<form id="form-add-contact-comment" method="post" data-parsley-validate="true">
					<label class="control-label">Message</label>
					<div class="form-group">
						<textarea class="form-control" rows=5 name="comment" id="comment" data-parsley-required="true"></textarea>
		            </div>
				</form>
			</div>
			<div class="modal-footer">
				<a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="modal-save-contact-comment" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modal-add-searches" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">MLS Search<span></span></h4>
			</div>
			<div class="modal-body p-20">
				<form id="form-add-mls-search" method="post" data-parsley-validate="true">
					<div class="row">
						<div class="form-group col-xs-6">
							<label for="usr">Class:</label>
							<input type="text" class="form-control" id="class" name="class" placeholder="Class" data-parsley-required="true">
						</div>
						<div class="form-group col-xs-6">
							<label for="usr">Type:</label>
							<input type="text" class="form-control" id="type" name="type" placeholder="Type" data-parsley-required="true">
						</div>
					</div>

					<div class="row">
						<div class="form-group col-xs-6">
							<label for="usr">City:</label>
							<input type="text" class="form-control" id="city_name" name="city_name" placeholder="City" data-parsley-required="true">
						</div>
						<div class="form-group col-xs-6">
							<label for="usr">State:</label>
							<input type="text" class="form-control" id="state_name" name="state_name" placeholder="State" data-parsley-required="true">
						</div>
					</div>

					<div class="row">
						<div class="form-group col-xs-6">
							<label for="usr">Zip:</label>
							<input type="text" class="form-control" id="zip_code" name="zip_code" placeholder="Zip">
						</div>
						<div class="form-group col-xs-6">
							<label for="usr">County:</label>
							<input type="text" class="form-control" id="county_name" name="county_name" placeholder="County">
						</div>
					</div>

					<div class="form-group">
						<div style="width:100%;" class="input-group">
							<div class="panel panel-inverse">
								<div class="panel-heading">
									<h4 class="panel-title">
										<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseBath">
											<i class="fa fa-plus"></i> Bathrooms
										</a>
									</h4>
								</div>
								<div id="collapseBath" class="panel-collapse collapse">
									<div class="panel-body">
											<div class="input-group">
										    <span class="input-group-addon" style="min-width:50px;">Min</span>
										    <input id="min_bath" type="text" class="form-control" name="min_bath" placeholder="Minimum Bathroom">
										  </div>
										<br>
											<div class="input-group">
										    <span class="input-group-addon" style="min-width:50px;">Max</span>
										    <input id="max_bath" type="text" class="form-control" name="max_bath" placeholder="Maximum Bathroom">
										  </div>
									</div>
								</div>
							</div>

							<div class="panel panel-inverse">
								<div class="panel-heading">
									<h4 class="panel-title">
										<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseBed">
											<i class="fa fa-plus"></i> Bedrooms
										</a>
									</h4>
								</div>
								<div id="collapseBed" class="panel-collapse collapse">
									<div class="panel-body">
											<div class="input-group">
										    <span class="input-group-addon" style="min-width:50px;">Min</span>
										    <input id="min_bed" type="text" class="form-control" name="min_bed" placeholder="Minimum Bedroom">
										  </div>
										<br>
											<div class="input-group">
										    <span class="input-group-addon" style="min-width:50px;">Max</span>
										    <input id="max_bed" type="text" class="form-control" name="max_bed" placeholder="Maximum Bedroom">
										  </div>
									</div>
								</div>
							</div>

							<div class="panel panel-inverse">
								<div class="panel-heading">
									<h4 class="panel-title">
										<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseSqft">
											<i class="fa fa-plus"></i> Square Footage
										</a>
									</h4>
								</div>
								<div id="collapseSqft" class="panel-collapse collapse">
									<div class="panel-body">
											<div class="input-group">
										    <span class="input-group-addon" style="min-width:50px;">Min</span>
										    <input id="min_sqft" type="text" class="form-control" name="min_sqft" placeholder="Minimum Sqft">
										  </div>
										<br>
											<div class="input-group">
										    <span class="input-group-addon" style="min-width:50px;">Max</span>
										    <input id="max_sqft" type="text" class="form-control" name="max_sqft" placeholder="Maximum Sqft">
										  </div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="modal-save-mls-search" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modal-edit-searches" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">MLS Search<span></span></h4>
			</div>
			<div class="modal-body p-20">

				<form id="form-edit-mls-search" method="post" data-parsley-validate="true">
					<input type="hidden" class="form-control" id="search_mls_id" name="search_mls_id">
					<div class="row">
						<div class="form-group col-xs-6">
							<label for="usr">Class:</label>
							<input type="text" class="form-control" id="edit_class" name="edit_class" placeholder="Class" data-parsley-required="true">
						</div>
						<div class="form-group col-xs-6">
							<label for="usr">Type:</label>
							<input type="text" class="form-control" id="edit_type" name="edit_type" placeholder="Type" data-parsley-required="true">
						</div>
					</div>

					<div class="row">
						<div class="form-group col-xs-6">
							<label for="usr">City:</label>
							<input type="text" class="form-control" id="edit_city" name="edit_city" placeholder="City" data-parsley-required="true">
						</div>
						<div class="form-group col-xs-6">
							<label for="usr">State:</label>
							<input type="text" class="form-control" id="edit_state" name="edit_state" placeholder="State" data-parsley-required="true">
						</div>
					</div>

					<div class="row">
						<div class="form-group col-xs-6">
							<label for="usr">Zip:</label>
							<input type="text" class="form-control" id="edit_zip" name="edit_zip">
						</div>
						<div class="form-group col-xs-6">
							<label for="usr">County:</label>
							<input type="text" class="form-control" id="edit_county" name="edit_county">
						</div>
					</div>

					<div class="form-group">
							<div style="width:100%;" class="input-group">

								<div class="panel panel-inverse">
									<div class="panel-heading">
										<h4 class="panel-title">
											<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseEditBath">
												<i class="fa fa-plus"></i> Bathrooms
											</a>
										</h4>
									</div>
									<div id="collapseEditBath" class="panel-collapse collapse">
										<div class="panel-body">
												<div class="input-group">
											    <span class="input-group-addon" style="min-width:50px;">Min</span>
											    <input id="edit_min_bath" type="text" class="form-control" name="edit_min_bath" placeholder="Minimum Bathroom">
											  </div>
											<br>
												<div class="input-group">
											    <span class="input-group-addon" style="min-width:50px;">Max</span>
											    <input id="edit_max_bath" type="text" class="form-control" name="edit_max_bath" placeholder="Maximum Bathroom">
											  </div>
										</div>
									</div>
								</div>

								<div class="panel panel-inverse">
									<div class="panel-heading">
										<h4 class="panel-title">
											<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseEditBed">
												<i class="fa fa-plus"></i> Bedrooms
											</a>
										</h4>
									</div>
									<div id="collapseEditBed" class="panel-collapse collapse">
										<div class="panel-body">
												<div class="input-group">
											    <span class="input-group-addon" style="min-width:50px;">Min</span>
											    <input id="edit_min_bed" type="text" class="form-control" name="edit_min_bed" placeholder="Minimum Bedroom">
											  </div>
											<br>
												<div class="input-group">
											    <span class="input-group-addon" style="min-width:50px;">Max</span>
											    <input id="edit_max_bed" type="text" class="form-control" name="edit_max_bed" placeholder="Maximum Bedroom">
											  </div>
										</div>
									</div>
								</div>

								<div class="panel panel-inverse">
									<div class="panel-heading">
										<h4 class="panel-title">
											<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseEditSqft">
												<i class="fa fa-plus"></i> Square Footage
											</a>
										</h4>
									</div>
									<div id="collapseEditSqft" class="panel-collapse collapse">
										<div class="panel-body">
												<div class="input-group">
											    <span class="input-group-addon" style="min-width:50px;">Min</span>
											    <input id="edit_min_sqft" type="text" class="form-control" name="edit_min_sqft" placeholder="Minimum Sqft">
											  </div>
											<br>
												<div class="input-group">
											    <span class="input-group-addon" style="min-width:50px;">Max</span>
											    <input id="edit_max_sqft" type="text" class="form-control" name="edit_max_sqft" placeholder="Maximum Sqft">
											  </div>
										</div>
									</div>
								</div>
							</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="modal-edit-mls-search" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modal-add-contact-file" data-backdrop="static" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Attach Files<span></span></h4>
			</div>
			<div class="panel" style="margin-bottom:0;">
				<div class="modal-body panel-body p-20">
					<div id="dropzone" class="text-center">
						<form id="my-dropzone" action="/ws/contact/attached_file/upload" class="dropzone needsclick dz-clickable" enctype="multipart/form-data" method="post">
							<div class="dz-message needsclick">
								Drop files here or click to browse.<br>

								<div class="fallback">
									<input name="file" type="file" />
								</div>
							</div>

							<input type="hidden" name="contact_id" value="{$contact_data.contact_id}">
							<input type="hidden" id="file-type-id" name="file_type_id" value="">
						</form>
						<p id="no-file-uploaded" class="hide" style="color:red;margin-bottom:0;margin-top:5px">Please choose a file to be uploaded</p>
						<br/>
					</div>

					<label class="control-label">File Type</label>
					<select id="contact-file-type" name="file_type" class="text-center form-control" style="width:100%;">
						<option value="">Select a file type</option>
						{foreach from=$file_types item='row'}
						<option value="{$row.file_type_id}">{$row.name}</option>
						{/foreach}
					</select>
					<p id="no-file-type" class="hide" style="color:red;margin-bottom:0;margin-top:5px">Please choose a file type</p>
				</div>
			</div>
			<div class="modal-footer">
				<a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="upload-file" class="btn btn-sm btn-success"><i class="fa fa-cloud-upload"></i>Upload File</a>
			</div>
		</div>
	</div>
</div>

{*
{if $user.is_admin eq '1' or $user.is_superadmin eq '1'}
<div class="modal fade" id="modal-add-referral" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">New Referral</h4>
			</div>
			<div class="modal-body p-20">
				<form id="form-add-referral" method="post" data-parsley-validate="true">

					<label class="control-label">Originally Referred to User</label>
					<div class="form-group">
						<div style="width:100%;" class="input-group">
							<select id="select-referral-users" name="user_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#referral-users-error">
								<option value="">Select a User</option>
								{foreach from=$users_list item='row'}
								<option value="{$row.user_id}">{$row.first_name} {$row.last_name}</option>
								{/foreach}
							</select>
							<div id="referral-users-error"></div>
						</div>
					</div>

					<label class="control-label">Source</label>
					<div class="form-group">
						<input type="text" id="referral_add_source" name="referral_source" class="form-control" data-parsley-required="true">
					</div>

					<input type="hidden" name="contact_id" value="{$contact_data.contact_id}"/>
				</form>
			</div>
			<div class="modal-footer">
				<a id="close-add-modal" href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="btn-add-referral" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modal-edit-referral" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Edit Referral</h4>
			</div>
			<div class="modal-body p-20">
				<form id="form-edit-referral" action="/ws/contact/edit_referral_from_contact" method="post" data-parsley-validate="true">

					<label class="control-label">User</label>
					<div class="form-group">
						<div style="width:100%;" class="input-group">
							<select id="select-edit-referral-users" name="user_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#edit-referral-users-error">
								<option value="">Select a User</option>
								{foreach from=$users_list item='row'}
								<option value="{$row.user_id}">{$row.first_name} {$row.last_name}</option>
								{/foreach}
							</select>
							<div id="edit-referral-users-error"></div>
						</div>
					</div>

					<label class="control-label">Referral Source</label>
					<div class="form-group">
						<div style="width:100%;" class="input-group">
							<input type="text" id="referral_edit_source" name="referral_source" class="form-control" data-parsley-required="true">
						</div>
					</div>

					<input type="hidden" id="referral-id" name="referral_id" value="{$contact_data.contact_id}"/>
					<input type="hidden" name="contact_id" value="{$contact_data.contact_id}"/>
				</form>
			</div>
			<div class="modal-footer">
				<a id="close-add-modal" href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="btn-save-referral" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
			</div>
		</div>
	</div>
</div>
{/if}

<div class="modal fade" id="modal-set-time-to-action" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Set Time To Action</h4>
			</div>
			<div class="panel" style="margin-bottom:0;">
				<div class="modal-body panel-body p-20">
					<form id="form-set-time-to-action" method="post" data-parsley-validate="true" data-form-action="">

						<div id="error-time-to-action" class="alert alert-danger fade in hide flash">
							<strong>Error!</strong>
							<span class="msg"></span>
							<span class="close" data-dismiss="alert">×</span>
						</div>

						<label class="control-label">Month/s</label>
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="months" class="date form-control" data-parsley-group="time-to-action"/>
								<span class="input-group-addon">
									<span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
						</div>

						<label class="control-label">Week/s</label>
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="weeks" class="date form-control" data-parsley-group="time-to-action"/>
								<span class="input-group-addon">
									<span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
						</div>

						<label class="control-label">Day/s</label>
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="days" class="date form-control" data-parsley-group="time-to-action"/>
								<span class="input-group-addon">
									<span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
						</div>

						<input type="hidden" id="contact-id" name="contact_id" value="{$contact_data.contact_id}"/>

					</form>
				</div>
			</div>
			<div class="modal-footer">
				<a id="close-add-modal" href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="btn-set-time-to-action" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
			</div>
		</div>
	</div>
</div>
<!-- End Modals Section -->
*}


{include file="includes/footer.tpl"}
