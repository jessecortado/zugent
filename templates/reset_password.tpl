{include file="includes/header.tpl"}

<link href="assets/plugins/password-indicator/css/password-indicator.css" rel="stylesheet">

<!-- begin #content -->
<div id="content" class="content">
	<!-- begin breadcrumb -->
	<ol class="breadcrumb pull-right">
		<li><a href="/dashboard.php">Home</a></li>
		<li class="active">Change Password</li>
	</ol>
	<!-- end breadcrumb -->

	<!-- begin page-header -->
	<h1 class="page-header">Change Password <small>(Edit Password)</small></h1>
	<!-- end page-header -->
	
	<div class="panel panel-inverse" style="">
	    <div class="panel-heading">
	        <h4 class="panel-title">Change Password</h4>
	    </div>
	    <div class="panel-body" style="padding-bottom: 0;">
	        <form class="form-horizontal" data-parsley-validate="true" action="/reset_password.php" method="POST">
				<div class="form-group">
					<label class="control-label col-md-3 ui-sortable">Current Password</label>
					<div class="col-md-9 ui-sortable">
						<input type="password" name="current_password" id="password-indicator-current" class="form-control m-b-5"
							data-parsley-required="true"
					        data-parsley-remote-options='{ "type": "POST" }'
					        data-parsley-remote-validator="validatePassword"
					        data-parsley-remote-message="Current password is invalid."
					        data-parsley-remote
					    />
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3 ui-sortable">New Password</label>
					<div class="col-md-9 ui-sortable">
						<input type="password" name="new_password" id="password-indicator-newpassword" class="form-control m-b-5" data-parsley-required="true" minlength="6" />
						<div id="passwordStrength-new" class="is0 m-t-5"></div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3 ui-sortable">Confirm Password</label>
					<div class="col-md-9 ui-sortable">
						<input type="password" name="confirm_password" id="password-indicator-confirmpassword" class="form-control m-b-5" data-parsley-required="true" minlength="6" data-parsley-equalto="#password-indicator-newpassword" data-parsley-equalto-message="New Password & Confirm Password should match." />
						<div id="passwordStrength-confirm" class="is0 m-t-5"></div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-md-3 ui-sortable"></label>
					<div class="col-md-9 ui-sortable">
						<button type="submit" class="btn btn-primary pull-right"><i class="fa fa-unlock-alt"></i> Change Password</button>
					</div>
				</div>
			</form>
	    </div>
	</div>
</div>

{include file="includes/footer.tpl" company_settings_keyval="1"}