{include file="includes/header.tpl"}

<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">

<!-- begin #content -->
<div id="content" class="content">
	<!-- begin breadcrumb -->
	<ol class="breadcrumb pull-right">
		<li>Home</li>
		<li><a href="/dashboard.php">Dashboard</a></li>
		<li><a href="/contacts_list.php?undefined=1">Contacts</a></li>
		<li class="active">New</li>
	</ol>
	<!-- end breadcrumb -->
	<!-- begin page-header -->
	<h1 class="page-header">Contacts <small>Create a new contact</small></h1>
	<!-- end page-header -->

	<form action="/contacts_new.php" method="post" data-parsley-validate="true">
		<input type="hidden" name="action" value="n">

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
									<option></option>
									{foreach item=row from=$buckets}
									<option value="{$row.bucket_id}">{$row.bucket_name}</option>
									{/foreach}
								</select>
							</div>
						</div>
					</div>
				</fieldset>
			</div>
		</div>

		<!-- begin row -->
		<div class="row">
		    <div class="col-md-12">
		        <!-- begin panel -->
                <div class="panel panel-inverse">
                    <div class="panel-heading">
                        <h4 class="panel-title">New Contact Details</h4>
                    </div>
                    <div class="panel-body">
						<fieldset>

							<div class="row">
								<div class="col-md-3">
                                    <div class="form-group">
                                        <label for="event_subject">First Name</label>
                                        <input type="text" class="form-control" name="first_name" id="first_name" placeholder="First Name" data-parsley-required="true"/>
                                    </div>
								</div>
								<div class="col-md-3">
                                    <div class="form-group">
                                        <label for="event_subject">Last Name</label>
                                        <input type="text" class="form-control" name="last_name" id="last_name" placeholder="Last Name" data-parsley-required="true"/>
                                    </div>
								</div>
								<div class="col-md-3">
                                    <div class="form-group">
                                        <label for="event_subject">Primary Phone</label>
                                        <input type="text" class="form-control phone-us" name="primary_phone" id="primary_phone" placeholder="(000) 000-0000" data-parsley-required="true"/>
                                    </div>
								</div>
								<div class="col-md-3">
                                    <div class="form-group">
                                        <label for="event_subject">Primary Email</label>
                                        <input type="text" class="form-control" name="primary_email" id="primary_email" placeholder="user@domain.com" data-parsley-required="true"/>
                                    </div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-12">
                                    <div class="form-group">
                                        <label for="event_subject">Street Address</label>
                                        <input type="text" class="form-control" name="street_address" id="street_address" placeholder="Street Address"/>
                                    </div>
								</div>
								<div class="col-md-3">
                                    <div class="form-group">
                                        <label for="event_subject">City</label>
                                        <input type="text" class="form-control" name="city" id="city" placeholder="City" />
                                    </div>
								</div>
								<div class="col-md-3">
                                    <div class="form-group">
                                        <label for="event_subject">State</label>
											<select class="form-control" name="state" id="state">
												<option value="">--</option>
												{include file="includes/states.tpl"}
											</select>
                                    </div>
								</div>
								<div class="col-md-3">
                                    <div class="form-group">
                                        <label for="event_subject">County</label>
                                        <input type="text" class="form-control" name="county" id="county" placeholder="County" />
                                    </div>
								</div>
								<div class="col-md-3">
                                    <div class="form-group">
                                        <label for="event_subject">Zip</label>
                                        <input type="text" class="form-control" name="zip" id="zip" placeholder="Zip Code" />
                                    </div>
								</div>
							</div>										

							<div class="form-group">
								<label class="control-label">Summary</label>
								<textarea class="form-control" name="summary" id="summary"></textarea>
							</div>

							<div class="row">
							    <div class="col-md-12">
									<button type="submit" class="btn btn-sm btn-primary m-r-5"><i class="glyphicon glyphicon-plus"></i> Create Contact</button>
							    </div>
							</div>

						</fieldset>
                    </div>
                </div>
                <!-- end panel -->
		    </div>
		</div>
		<!-- end #row -->
	</form>
</div>
<!-- end #content -->

{include file="includes/footer.tpl"}