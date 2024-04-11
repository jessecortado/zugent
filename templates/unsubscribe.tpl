<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<head>
	<meta charset="utf-8" />
	<title>RUOPEN | Login</title>
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
	<link href="/assets/css/style.min.css" rel="stylesheet" />
	<link href="/assets/css/style-responsive.min.css" rel="stylesheet" />
	<link href="/assets/css/theme/default.css" rel="stylesheet" />
	<!-- ================== END BASE CSS STYLE ================== -->
	
	<!-- ================== BEGIN BASE JS ================== -->
	<script src="/assets/plugins/pace/pace.min.js"></script>
	<!-- ================== END BASE JS ================== -->

	<style type="text/css">
		.asdf{
			margin: -168px 0 0;
			position: absolute;
			left: 0;
			right: 0;
			top: 50%;
		}
		.asdf .msg {
			color: #2d353c;
		    font-weight: bold;
		    font-size: 45px;
		    line-height: 45px;
		    text-shadow: 5px 3px 0 rgba(0,0,0,.1);
		}
	</style>
</head>
<body class="pace-top">
	<!-- begin #page-loader -->
	<div id="page-loader" class="fade in"><span class="spinner"></span></div>
	<!-- end #page-loader -->
	
	<!-- begin #page-container -->
	<div id="page-container" class="fade">


		<div class="container">
			<div class="col-md-12 text-center asdf">
				<div class="msg">You've been succesfully unsubscribed from RUOPEN email list.</div>
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
	<!-- ================== END BASE JS ================== -->
	
	<!-- ================== BEGIN PAGE LEVEL JS ================== -->
	<script src="/assets/js/apps.min.js"></script>
	<!-- ================== END PAGE LEVEL JS ================== -->

	<script type="text/javascript">

		function getLocation() {
		    if (navigator.geolocation) {
		        navigator.geolocation.getCurrentPosition(showPosition, showError);
		    } else { 
		        $("#frm-login").submit();
		    }
		}

		function showPosition(position) {
		    lat = position.coords.latitude;
		    lon = position.coords.longitude;

		    $("#lat").val(lat.toString());
		    $("#lon").val(lon.toString());

		    return true;
		}

		function showError(error) {
		    switch(error.code) {
		        case error.PERMISSION_DENIED:
		            console.log("User denied the request for Geolocation.");
		            break;
		        case error.POSITION_UNAVAILABLE:
		            console.log("Location information is unavailable.");
		            break;
		        case error.TIMEOUT:
		            console.log("The request to get user location timed out.");
		            break;
		        case error.UNKNOWN_ERROR:
		            console.log("An unknown error occurred.");
		            break;
		    }

			$("#frm-login").submit();
		}

		$(document).ready(function() {
			App.init();

			var count = 0;
			var max = 20;

			$("#sign-in").on("click", function(){
				getLocation();
				var intervalVar = setInterval(function() {
					console.log("Please wait");
					if (count == max) {
						clearInterval(intervalVar);
						$("#frm-login").submit();
					}
					else {
						if($("#lon").val() !== ""){
							console.log("submitting");
							clearInterval(intervalVar);
							$("#frm-login").submit();
						}
						count++;
					}
				}, 200);
			});

			$("#checkbox_rme").on("click", function(){
				if($(this).is(':checked')) {
					$('#rememberme').val("true");
				}
				else {
					$('#rememberme').val("");
				}
			});

		});
	</script>
</body>
</html>
