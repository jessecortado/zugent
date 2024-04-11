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
	    <!-- begin login -->
        <div class="login login-with-news-feed">
            <!-- begin news-feed -->
            <div class="news-feed">
                <div class="news-image">
                    <img src="/assets/img/zug_laptop_desk.jpg" data-id="login-cover-image" alt="" />
                </div>
                <div class="news-caption">
                    <h4 class="caption-title"><!-- <i class="fa fa-diamond text-success"></i> --> RUOPEN</h4>
                    <p>
                        Measure your success one lead at a time.
                    </p>
                </div>
            </div>
            <!-- end news-feed -->
            <!-- begin right-content -->
            <div class="right-content">
                <!-- begin login-header -->
                <div class="login-header">
                    <div class="brand">
                        <a href="/"><span class="logo"></span></a>
                        <small>Real Estate Marketing and Lead Management</small>
                    </div>
                    <div class="icon">
                        <i class="fa fa-sign-in"></i>
                    </div>
                </div>
                <!-- end login-header -->
                <!-- begin login-content -->
                <div class="login-content">

					<h3>We're sorry but RUOPEN is down for maintenance. Please check back soon!</h3>
						
                </div>
                <!-- end login-content -->
            </div>
            <!-- end right-container -->
        </div>
        <!-- end login -->
        
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
    <script src="/assets/js/custom.js"></script>

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
	// Geolocation API
	// https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyBuYrziPHytz3v0V6pzPDrcAFNe0wxS-GA

	// defer(deferred_method);


	// function defer(method){
	//     if (window.jQuery)
	//         method();
	//     else
	//         setTimeout(function() { defer(method) }, 50);
	// }

	// function deferred_method(){
	//     $(document).on("click", ".btn-view-in-map", function() { 
	//         if (navigator.geolocation) {
	//             console.log($(this).data("lat") + " , " + $(this).data("lon"))
	//             var pos = new google.maps.LatLng($(this).data("lat"), $(this).data("lon"));
	//             viewPosition(pos);
	//         } else { 
	//             x.innerHTML = "Geolocation is not supported by this browser.";
	//         }
	//     });
	// }
	</script>

	<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAq8WuTeXonjSzYw_vVLiN7PCRQNqf_v_Q"></script></script>
</body>
</html>
