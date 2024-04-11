<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<head>
	<meta charset="utf-8" />
	<title>RUOPEN</title>
	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
	<meta content="" name="description" />
	<meta content="" name="author" />

	<link rel="icon" href="assets/favicon/favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" href="assets/favicon/favicon.ico" type="image/x-icon" />
	<link rel="apple-touch-icon" sizes="57x57" href="assets/favicon/apple-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="assets/favicon/apple-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="72x72" href="assets/favicon/apple-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="76x76" href="assets/favicon/apple-icon-76x76.png">
	<link rel="apple-touch-icon" sizes="114x114" href="assets/favicon/apple-icon-114x114.png">
	<link rel="apple-touch-icon" sizes="120x120" href="assets/favicon/apple-icon-120x120.png">
	<link rel="apple-touch-icon" sizes="144x144" href="assets/favicon/apple-icon-144x144.png">
	<link rel="apple-touch-icon" sizes="152x152" href="assets/favicon/apple-icon-152x152.png">
	<link rel="apple-touch-icon" sizes="180x180" href="assets/favicon/apple-icon-180x180.png">
	<link rel="icon" type="image/png" sizes="192x192"  href="assets/favicon/android-icon-192x192.png">
	<link rel="icon" type="image/png" sizes="32x32" href="assets/favicon/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="96x96" href="assets/favicon/favicon-96x96.png">
	<link rel="icon" type="image/png" sizes="16x16" href="assets/favicon/favicon-16x16.png">
	<link rel="manifest" href="assets/favicon/manifest.json">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="assets/favicon/ms-icon-144x144.png">
	<meta name="theme-color" content="#ffffff">
	
	<!-- ================== BEGIN BASE CSS STYLE ================== -->
	<!-- <link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet"> -->
	<link href="assets/plugins/jquery-ui/themes/base/minified/jquery-ui.min.css" rel="stylesheet" />
	<link href="assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
	<link href="assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
	<link href="assets/css/animate.min.css" rel="stylesheet" />
	<link href="assets/css/style.css" rel="stylesheet" />
	<link href="assets/css/style-responsive.min.css" rel="stylesheet" />
	<link href="assets/css/theme/default.css" rel="stylesheet" id="theme" />
	<!-- ================== END BASE CSS STYLE ================== -->
	
	<!-- ================== BEGIN PAGE LEVEL CSS STYLE ================== -->
    <link href="assets/plugins/jquery-jvectormap/jquery-jvectormap.css" rel="stylesheet" />
    <link href="assets/plugins/bootstrap-calendar/css/bootstrap_calendar.css" rel="stylesheet" />
    <link href="assets/plugins/gritter/css/jquery.gritter.css" rel="stylesheet" />
    <link href="assets/plugins/morris/morris.css" rel="stylesheet" />
	<!-- ================== END PAGE LEVEL CSS STYLE ================== -->

	<!-- ================== BEGIN CUSTOM CSS STYLE ================== -->
	<link href="assets/css/custom.css" rel="stylesheet" />
	<link href="assets/css/mobile-forms.css" rel="stylesheet" />
	<!-- ================== END CUSTOM CSS STYLE ================== -->

	<!-- ================== BEGIN BASE JS ================== -->
	<script src="assets/plugins/pace/pace.min.js"></script>
	<link href="assets/plugins/parsley/src/parsley.css" rel="stylesheet" />
	<!-- ================== END BASE JS ================== -->
	<!-- // <script src='https://www.google.com/recaptcha/api.js'></script> -->

</head>
<body>
	<!-- begin #page-loader -->
	<div id="page-loader" class="fade in"><span class="spinner"></span></div>
	<!-- end #page-loader -->
	
	<!-- begin #page-container -->
	<div id="page-container" class="fade page-sidebar-fixed page-header-fixed">
		<!-- begin #header -->
		<div id="header" class="header navbar navbar-default navbar-fixed-top">
			<!-- begin container-fluid -->
			<div class="container-fluid">
				<!-- begin mobile sidebar expand / collapse button -->
				<div class="navbar-header">
					<a href="/dashboard.php" class="navbar-brand"><span class="navbar-logo"></span></a>
					<button type="button" class="navbar-toggle" data-click="sidebar-toggled">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
				</div>
				<!-- end mobile sidebar expand / collapse button -->
				
				<!-- begin header navigation right -->
				<ul class="nav navbar-nav navbar-right">
					{if isset($user.i_user_id)}
						<li>
							<div class="navbar-form">
								<button id="finish-impersonation" class="btn btn-danger btn-sm"><i class="fa fa-low-vision"></i>Finish Impersonation</button>
							</div>
						</li>
					{/if}
					{*
					<li>
						<form class="navbar-form full-width">
							<div class="form-group">
								<input type="text" class="form-control" placeholder="Enter keyword" />
								<button type="submit" class="btn btn-search"><i class="fa fa-search"></i></button>
							</div>
						</form>
					</li>
					<li class="dropdown">
						<a id="see-notifications" href="javascript:;" data-toggle="dropdown" class="dropdown-toggle f-s-14">
							<i class="fa fa-bell-o"></i>
							<span class="label">{$notifications.new}</span>
						</a>
						<ul id="notifications" class="dropdown-menu media-list pull-right animated fadeInDown">
                            <li class="dropdown-header">Notifications (<span id="total-notifs">{$notifications.data|count}</span>) <span class="pull-right"><a href="/notifications.php">View All</a> </span></li>
                            {foreach item=row from=$notifications.data}
                            <li class="media">
                                <a {if $row.seen eq 0}class="new"{/if} title="{$row.notification}" href="{if $row.url_action ne ''}https://{$row.url_action}{else}javascript:;{/if}">
                                    <div class="media-left"><i class="fa fa-bug media-object bg-red"></i></div>
                                    <div class="media-body">
                                    	{if $row.title eq ''}
                                        <!-- <h6 class="media-heading">{$row.notification}</h6> -->
                                        <p>{$row.notification}</p>
                                        {else}
                                        <h6 class="media-heading">{$row.title}</h6>
                                        <p>{$row.notification}</p>
                                        {/if}
                                        <div class="text-muted f-s-11">{$row.time_elapsed}</div>
                                    </div>
                                </a>
                            </li>
                            {/foreach}
                            <li class="dropdown-footer text-center">
                                <button class="btn btn-xs btn-primary" style="display: block !important; width:100%;" id="load-more-notifications">View more</button>
                            </li>
						</ul>
					</li>
					*}
					<li class="dropdown navbar-user">
						<a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown">
							<img src="{if $user.is_profile_photo == 1}https://s3-us-west-2.amazonaws.com/zugent/profilephotos/{$user.user_id}/original.jpg{else} assets/img/user-13.jpg {/if}" alt="" /> 
							<span class="hidden-xs">{if isset($user.first_name)}{$user.first_name}{/if} {if isset($user.last_name)}{$user.last_name}{/if}</span> <b class="caret"></b>
						</a>
						<ul class="dropdown-menu animated fadeInLeft">
							<li class="arrow"></li>
							<li><a href="/my_profile.php">My Profile</a></li>
							<li><a href="/reset_password.php">Change Password</a></li>
							<!-- <li><a href="javascript:;"><span class="badge badge-danger pull-right">2</span> Inbox</a></li> -->
							{if $user.is_admin eq '1' or $user.is_superadmin eq '1'}
							<li><a href="/settings.php">Company Settings</a></li>
							{/if}
							<li class="divider"></li>
							<li><a href="/services/logout.php">Log Out</a></li>
						</ul>
					</li>
				</ul>
				<!-- end header navigation right -->
			</div>
			<!-- end container-fluid -->
		</div>
		<!-- end #header -->
		
		<!-- begin #sidebar -->
		<div id="sidebar" class="sidebar">
		
			<!-- begin sidebar scrollbar -->
			<div data-scrollbar="true" data-height="100%">
				<!-- begin sidebar nav -->
				<ul class="nav">
					<li class="nav-header">Navigation</li>
					<li class="{if $active_page eq "dashboard"}active{/if}"><a href="/dashboard.php"><i class="fa fa-laptop"></i> <span>Dashboard</span></a></li>
					{if $all_contacts_count}
					<li class="has-sub {if $active_page eq "contacts"}active{/if}">
						<a href="javascript:;">
						    <b class="caret pull-right"></b>
						    <i class="fa fa-address-card"></i>
						    <span>Contacts</span>
					    </a>
						<ul class="sub-menu">
							{foreach item=row key=k from=$contacts_count}
								{foreach item=row2 key=k2 from=$row}
									{if $row2.count > 0}
						    			<li><a href="/contacts_list.php?{$k}={$row2.id}">{if $k eq 'new'}<span class="fa fa-star"></span>{/if} {$k2} <span class="badge badge-success">{$row2.count}<span></a></li>
						    		{/if}
						    	{/foreach}
							{/foreach}

							{*
							These pages don't exist yet so commenting them out.

						    <!-- <li><a href="/dashboard.php">Dashboard</a></li> -->
							<li><a href="/contacts_active.php">Active Contacts</a></li>
							<li><a href="/contacts_neglected.php">Stale Contacts</a></li>
							<li><a href="/contacts_todo.php">Followups &amp; ToDo</a></li>
							*}

						</ul>
					</li>
					{/if}
					{if $user.is_admin eq '1' or $user.is_superadmin eq '1'}
					<li class="has-sub {if $active_page eq "company_contacts"}active{/if}">
						<a href="javascript:;">
						    <b class="caret pull-right"></b>
						    <i class="fa fa-address-card-o"></i>
						    <span>Company Contacts</span>
					    </a>
						<ul class="sub-menu">
						    <li><a href="/company_contacts.php"> Search From All </a></li>
							{foreach item=row key=k from=$company_contacts_count}
								{foreach item=row2 key=k2 from=$row}
									{if $row2.count > 0}
						    		<li><a href="/contacts_list.php?{$k}={$row2.id}&c={$k2|count}">{if $k eq 'new'}<span class="fa fa-star"></span>{/if} {$k2} <span class="badge badge-success">{$row2.count}<span></a></li>
						    		{/if}
						    	{/foreach}
							{/foreach}
							{*
							These pages don't exist yet so commenting them out.

						    <!-- <li><a href="/dashboard.php">Dashboard</a></li> -->
							<li><a href="/contacts_active.php">Active Contacts</a></li>
							<li><a href="/contacts_neglected.php">Stale Contacts</a></li>
							<li><a href="/contacts_todo.php">Followups &amp; ToDo</a></li>
							*}
						</ul>
					</li>
					{/if}

					<li class="{if $active_page eq "calendar"}active{/if}"><a href="/calendar.php"><i class="fa fa-calendar"></i> <span>Appointment Calendar</span></a></li>

					{*
        			{if $company.has_social eq 1}
					<li class="{if $active_page eq "social_calendar"}active{/if}"><a href="/social_calendar.php"><i class="fa fa-calendar-plus-o"></i> <span>Social Calendar</span></a></li>
					{/if}
					
					<li class="has-sub {if $active_page eq "reports"}active{/if}">
						<a href="javascript:;">
						    <b class="caret pull-right"></b>
						    <i class="fa fa-area-chart"></i>
						    <span>Reports</span>
					    </a>
						<ul class="sub-menu">
        					{if $company.has_referrals eq 1}
							<li><a href="/referrals_report.php"><i class="fa fa-folder "></i> <span>Referrals Report</span></a></li>
							{/if}
						</ul>
					</li>
					
					<li class="has-sub {if $active_page eq "reports"}active{/if}">
						<a href="javascript:;">
						    <b class="caret pull-right"></b>
						    <i class="fa fa-wrench"></i>
						    <span>Tools</span>
					    </a>
						<ul class="sub-menu">
							<li><a href="/user_email_templates.php"><i class="fa fa-envelope"></i> <span>Email Templates</span></a></li>
        					{if $company.has_bulk_email eq 1}
							<li><a href="/bulk_email.php"><i class="fa fa-inbox"></i> <span>Bulk Email</span></a></li>
							{/if}
							<li><a href="/media_generator.php"><i class="fa fa-image "></i> <span>Media Generator</span></a></li>
						</ul>
					</li>
					*}

					{if $user.is_beta eq 1}
					
						{*
						<li class="has-sub {if $active_page eq "campaign"}active{/if}">
							<a href="javascript:;">
							    <b class="caret pull-right"></b>
							    <i class="fa fa-laptop"></i>
							    <span>Campaigns</span>
						    </a>
							<ul class="sub-menu">
								<li class="{if $active_sub_page eq "campaign_catalogue"}active{/if}"><a href="/campaign_catalogue.php">Campaign Catalogue</a></li>
							</ul>
						</li>
						*}

						
	        			{if $company.has_pools eq 1}
						<li><a href="/contact_pool.php"><i class="fa fa-users "></i> <span>Pool Leads</span></a></li>
						{/if}

						{if $company.has_transactions eq 1}
		                    {if $user.is_admin eq '1' or $user.is_transaction_coordinator eq '1'}
							<li><a href="/transactions.php"><i class="fa fa-inbox"></i> <span>Transactions</span></a></li>
							{else}
							<li><a href="/transactions.php?id={$user.user_id}"><i class="fa fa-inbox"></i> <span>Transactions</span></a></li>
							{/if}
						{/if}
						

	        			{if $company.has_drive eq 1}
						<li><a href="/drive.php"><i class="fa fa-car"></i> <span>Drive</span></a></li>
						<!-- <li><a href="/find_agent.php"><i class="fa fa-user-secret"></i> <span>Find an Agent</span></a></li> -->
						{/if}

						{*
	    				{if $company.has_broker_page eq 1}
						<li><a href="/company_page_settings.php"><i class="fa fa-code"></i> <span>Company Page Settings</span></a></li>
						{/if}
						*}

					{/if}

					{if $user.is_superadmin eq '1'}
					<li class="has-sub {if $active_page eq 'drive_monitor'}active{/if}"><a href="/drive_monitor.php"><i class="fa fa-car"></i> <span>Drive Monitor</span></a></li>
					{*
					<li class="has-sub {if $active_page eq 'drive_spoof'}active{/if}"><a href="/drive_spoof.php"><i class="fa fa-car"></i> <span>Drive Spoof</span></a></li>
					*}
					{/if}

			        <!-- begin sidebar minify button -->
					<li><a href="javascript:;" class="sidebar-minify-btn" data-click="sidebar-minify"><i class="fa fa-angle-double-left"></i></a></li>
			        <!-- end sidebar minify button -->
				</ul>
				<!-- end sidebar nav -->
			</div>
			<!-- end sidebar scrollbar -->
		</div>
		<div class="sidebar-bg"></div>
		<!-- end #sidebar -->
