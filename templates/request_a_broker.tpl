<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<head>
	<meta charset="utf-8" />
	<title>RUOPEN | Request a Broker</title>
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
	<link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet">
	<link href="/assets/plugins/jquery-ui/themes/base/minified/jquery-ui.min.css" rel="stylesheet" />
	<link href="/assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
	<link href="/assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
	<link href="/assets/css/animate.min.css" rel="stylesheet" />
	<link href="/assets/css/login.css" rel="stylesheet" />
	<link href="/assets/css/login-responsive.css" rel="stylesheet" />
	<link href="/assets/plugins/bootstrap-social/bootstrap-social.css" rel="stylesheet" />
	<!-- ================== END BASE CSS STYLE ================== -->
	
	<!-- ================== BEGIN BASE JS ================== -->
	<script src="/assets/plugins/pace/pace.min.js"></script>
	<!-- ================== END BASE JS ================== -->
</head>
<body class="pace-top bg-white">
	<!-- begin #page-loader -->
	<div id="page-loader" class="fade in"><span class="spinner"></span></div>
	<!-- end #page-loader -->
	
	<!-- begin #page-container -->
	<div id="page-container" class="fade">

		<div id="banner-box-no-border">
			<img src="/assets/img/ruopen_banner_logo.jpg" class="ruopen-logo">
		</div>

		<div style="position: absolute;left: 50%;top: 20%;">
	        <div id="request-agent-box">
                <div id="message"></div>
                <div id="request-agent-form">
		        	<p class="desc">Please fill in the required information below.</p>
		            <form id="frm-request" name="frm-request" data-parsley-validate="true">
		                <div class="form-group">
		                    <div style="width:100%;" class="input-group">
		                        <input id="first-name" type="text" class="form-control" placeholder="First Name*" autocomplete="on" data-parsley-required="true"/>
		                    </div>
		                </div>
		                <div class="form-group">
		                    <div style="width:100%;" class="input-group">
		                        <input id="last-name" type="text" class="form-control" placeholder="Last Name*" autocomplete="on" data-parsley-required="true"/>
		                    </div>
		                </div>
		                <div class="form-group">
		                    <div style="width:100%;" class="input-group">
		                        <input id="email-address" type="text" class="form-control" placeholder="Email Address*" autocomplete="on" data-parsley-required="true" data-parsley-type="email"/>
		                    </div>
		                </div>
		                <div class="form-group">
		                    <div style="width:100%;" class="input-group">
		                        <input id="phone" type="text" class="form-control phone-us" placeholder="Mobile No.*" autocomplete="on" data-parsley-required="true" data-parsley-minlength="14" data-parsley-minlength-message="Phone format is invalid."/>
		                    </div>
		                </div>
		                <div class="form-group">
		                    <div style="width:100%;" class="input-group">
		                        <input id="mls_number" type="text" class="form-control" placeholder="MLS # or Address" autocomplete="on" data-parsley-required="false"/>
		                    </div>
		                </div>
		                <!-- <div class="form-group">
		                    <div style="width:100%;" class="input-group">
		                        <div style="margin: 10px auto;" class="g-recaptcha" data-callback="capcha_filled" data-expired-callback="capcha_expired" data-sitekey="6Ld3XBMUAAAAALd0sE0QgXXU2rCQKVBGhEgjIy-V"></div>
		                    </div>
		                </div> -->
		                <div class="form-group">
		                    <!-- <a href="javascript:void(0)" id="btn-request" class="btn btn-sm btn-success"><i class="fa fa-user-secret"></i> Submit</a> -->
		                    <div style="width:100%;" class="input-group">
		                        <button type="submit" style="width:100%;" class="btn btn-sm btn-success"><i class="fa fa-user-secret"></i> Request a Member Broker</button>
		                    </div>
		                </div>
		                <p class="help-block m-b-25" style="color:white;>"<i>We don't spam. Your email address is secure with us.</i></p>
		            </form>
	            </div>
		        <div id="btn-req-box" class="text-center hide">
		            <div class="gray-content-box">
		                <div class="card-1 hovercard-1">
		                    <div class="card-1header"></div>
		                    <div class="avatar">
		                        <img id="



agent-picture" alt="Broker Profile Picture" src="/assets/img/user-0.jpg" style="max-width: 250px;">
		                    </div>
		                    <div class="info">
		                        <div id="agent-name" class="title">
		                            <!-- <a target="_blank" href="http://scripteden.com/"> -->
		                            Script Eden
		                            <!-- </a> -->
		                        </div>
		                        <div class="other-details">
		                            <div id="agent-phone" class="desc">Fetching</div>
		                            <div id="agent-email" class="desc">Fetching</div>
		                            <div id="agent-company" class="desc">RUOPEN</div>
		                        </div>
		                    </div>
		                </div>
		            </div>
		        </div>
                <div id="request-new-broker" style="width:100%;margin-top: 10px;" class="hide">
                    <button style="width:100%;" class="btn btn-sm btn-success"><i class="fa fa-user-secret"></i> Request a New Broker</button>
                </div>
	        </div>
        </div>
        
	</div>
	<!-- end page container -->
	
	<!-- ================== BEGIN BASE JS ================== -->
	<script src="/assets/plugins/jquery/jquery-1.9.1.min.js"></script>
	<script src="/assets/plugins/jquery/jquery-migrate-1.1.0.min.js"></script>
	<script src="/assets/plugins/jquery-ui/ui/minified/jquery-ui.min.js"></script>
	<script src="/assets/plugins/bootstrap/js/bootstrap.min.js"></script>
	<!--[if lt IE 9]>
		<script src="/assets/crossbrowserjs/html5shiv.js"></script>
		<script src="/assets/crossbrowserjs/respond.min.js"></script>
		<script src="/assets/crossbrowserjs/excanvas.min.js"></script>
	<![endif]-->
	<script src="/assets/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<script src="/assets/plugins/jquery-cookie/jquery.cookie.js"></script>
	<script src="assets/js/jquery.mask.js"></script>
	<script src="/assets/plugins/parsley/dist/parsley.js"></script>
	<!-- ================== END BASE JS ================== -->
	
	<!-- ================== BEGIN PAGE LEVEL JS ================== -->
	<script src="/assets/js/apps.min.js"></script>
	<!-- ================== END PAGE LEVEL JS ================== -->
    <script src="/assets/js/custom.js"></script>

	<!-- <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAq8WuTeXonjSzYw_vVLiN7PCRQNqf_v_Q"></script> -->

	<script src="/assets/js/request_broker.js"></script>

</body>
</html>
