<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<head>
	<meta charset="utf-8" />
	<title>RUOPEN | Coming Soon Page</title>
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
	<link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet">
	<link href="assets/plugins/jquery-ui/themes/base/minified/jquery-ui.min.css" rel="stylesheet" />
	<link href="assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
	<link href="assets/css/animate.min.css" rel="stylesheet" />
	<!-- ================== END BASE CSS STYLE ================== -->

	<style>
	.vertical-center {
		min-height: 100%;  
		min-height: 100vh; 
		display: flex;
		align-items: center;
	}
	.maintenance-bg {
		background: url("assets/img/maintenance-bg-1.jpg") no-repeat;
		background-size: cover;
	}
	#maintenance-content {
		width: 80%;
		width: 80vh;
		height: 80%;
		height: 80vh;
		background: rgba(255, 255, 255, 0.8);
		display: flex;
		align-items: center;
		text-align: center;
		color: #333;
		font-weight: 100;
		font-size: 22px;
		border-radius: 10px;
	}
	.shadow {
		-webkit-box-shadow: 0px 4px 23px 9px rgba(235,235,235,1);
		-moz-box-shadow: 0px 4px 23px 9px rgba(235,235,235,1);
		box-shadow: 0px 4px 23px 9px rgba(235,235,235,1);
	}
	.btn.btn-custom {
	    color: #00acac;
	    font-weight: 600;
	    background: transparent;
	    border: 2px solid #00acac;
	    -webkit-transition: all .2s linear;
	    -moz-transition: all .2s linear;
	    transition: all .2s linear;
	}
	.btn.btn-custom:hover {
	    color: #fff;
	    background: #00acac;
	    border: 2px solid #fff;
	}
	</style>

	<?php 
		require_once($_SERVER['SITE_DIR']."/includes/common.php");
		if (isset($_SESSION['user'])) {
			session_destroy();
		}
	?>
</head>
<body class="bg-white p-t-0 pace-top">

	<div id="page-container" class="vertical-center maintenance-bg">
		<div id="maintenance-content" class="container shadow">
			<div class="col-md-12">
				<img style="width: 17%; width:30vh; height:auto" src="assets/img/ruopen_banner2.jpg" alt="RUOPEN Marketing Website Logo">
				<p class="m-t-20">We're sorry but your account has expired.</p>
				<p>Please contact billing or your administrator.</p>
				<div class="text-center">
                    <a href="/" class="btn btn-custom">Home Page</a>
                    <a href="/login.php" class="btn btn-custom">Login Page</a>
                </div>
			</div>
                
		</div>
	</div>

	<!-- ================== BEGIN BASE JS ================== -->
	<script src="assets/plugins/jquery/jquery-1.9.1.min.js"></script>
	<script src="assets/plugins/jquery/jquery-migrate-1.1.0.min.js"></script>
	<script src="assets/plugins/jquery-ui/ui/minified/jquery-ui.min.js"></script>
	<script src="assets/plugins/bootstrap/js/bootstrap.min.js"></script>
	<!--[if lt IE 9]>
		<script src="assets/crossbrowserjs/html5shiv.js"></script>
		<script src="assets/crossbrowserjs/respond.min.js"></script>
		<script src="assets/crossbrowserjs/excanvas.min.js"></script>
	<![endif]-->
	<script src="assets/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<script src="assets/plugins/jquery-cookie/jquery.cookie.js"></script>
	<!-- ================== END BASE JS ================== -->
	
	
</body>
</html>
