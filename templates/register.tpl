<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<head>
	<meta charset="utf-8" />
	<title>RUOPEN | Register</title>
	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
	<meta content="" name="description" />
	<meta content="" name="author" />

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
	<link href="assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
	<link href="assets/css/animate.min.css" rel="stylesheet" />
    <link href="assets/css/login.css" rel="stylesheet" />
    <link href="assets/css/login-responsive.css" rel="stylesheet" />
	<!-- ================== END BASE CSS STYLE ================== -->
	
	<!-- ================== BEGIN BASE JS ================== -->
	<script src="assets/plugins/pace/pace.min.js"></script>
    <link href="assets/plugins/parsley/src/parsley.css" rel="stylesheet" />
	<!-- ================== END BASE JS ================== -->
    <script src='https://www.google.com/recaptcha/api.js'></script>
</head>
<body class="pace-top bg-white">
	<!-- begin #page-loader -->
	<div id="page-loader" class="fade in"><span class="spinner"></span></div>
	<!-- end #page-loader -->
	
	<!-- begin #page-container -->
	<div id="page-container" class="fade">
	    <!-- begin register -->
        <div class="register register-with-news-feed">
            <!-- begin news-feed -->
            <div class="news-feed">
                <div class="news-image">
                    <img src="assets/img/zug_laptop_side.jpg" alt="" />
                </div>
                <div class="news-caption">
                    <h4 class="caption-title"><i class="fa fa-edit text-success"></i> Announcing RUOPEN</h4>
                    <p>
                        As a RUOPEN user manage your leads, track your business, and with a brokerage account with an IDX feed equip your brokerage with responsive search tools and insights to your clients activities. Measure yourself.
                    </p>
                </div>
            </div>
            <!-- end news-feed -->
            <!-- begin right-content -->
            <div class="right-content">
                <!-- begin register-header -->
                <h1 class="register-header">
                    <div class="brand">
                        <a href="/"><span class="logo"></span></a> RUOPEN
                        <small>Real Estate Marketing and Lead Management</small>
                    </div>
                    <hr>
                    Sign Up
                    <small>Your first step to Real Estate greatness is to sign up. We'll first create your account then pick your plan.</small>
                </h1>
                <!-- end register-header -->
                <!-- begin register-content -->
                <div class="register-content">
                    {if isset($email_exists) and $email_exists eq 'true'}
                        <div class="well well-alert text-center" style="color:rgb(200,20,20);">Email already registered</div>
                    {/if}
                    <form name="register-form" action="/register.php" method="POST" class="margin-bottom-0" data-parsley-validate="true">
                        <label class="control-label">Name <span class="text-danger">*</span></label>
                        <div class="row row-space-10">
                            <div class="col-md-6 m-b-15">
                                <input type="text" name="first_name" class="form-control" placeholder="First name" data-parsley-required="true" />
                            </div>
                            <div class="col-md-6 m-b-15">
                                <input type="text" name="last_name" class="form-control" placeholder="Last name" data-parsley-required="true" />
                            </div>
                        </div>
                        <label class="control-label">Email <span class="text-danger">*</span></label>
                        <div class="row m-b-15">
                            <div class="col-md-12">
                                <input type="text" name="email" class="form-control" placeholder="Email address" data-parsley-required="true" />
                            </div>
                        </div>
                        <label class="control-label">Re-enter Email <span class="text-danger">*</span></label>
                        <div class="row m-b-15">
                            <div class="col-md-12">
                                <input type="text" class="form-control" placeholder="Re-enter email address" data-parsley-required="true" />
                            </div>
                        </div>
                        <label class="control-label">Password <span class="text-danger">*</span></label>
                        <div class="row m-b-15">
                            <div class="col-md-12">
                                <input type="password" name="password" class="form-control" placeholder="Password" data-parsley-required="true" />
                            </div>
                        </div>

                        <label class="control-label">Company Name <span class="text-danger">*</span></label>
                        <div class="row m-b-15">
                            <div class="col-md-12">
                                <input type="text" name="company_name" class="form-control" placeholder="Enter your Company Name" data-parsley-required="true" />
                            </div>
                        </div>

                        <div class="form-group m-b-30">
                            <div class="g-recaptcha" data-callback="capcha_filled" data-expired-callback="capcha_expired" data-sitekey="{$recaptcha_key}"></div>
                            {* <div class="g-recaptcha" data-callback="capcha_filled" data-expired-callback="capcha_expired" data-sitekey="6Ld3XBMUAAAAALd0sE0QgXXU2rCQKVBGhEgjIy-V"></div> *}
                            <div id="g-recaptcha-error"></div>
                        </div>

                        <div class="register-buttons">
                            <button type="submit" class="btn btn-primary btn-block btn-lg">Continue to Billing</button>
                        </div>
                        <div class="m-t-20 m-b-40 p-b-40 text-inverse">
                            Already a member? Click <a href="/login.php">here</a> to login.
                        </div>
                        <hr />
                        <p class="text-center">
                            &copy;2016-{'Y'|date} RUOPEN. All Right Reserved 2015.
                        </p>
                    </form>
                </div>
                <!-- end register-content -->
            </div>
            <!-- end right-content -->
        </div>
        <!-- end register -->
	</div>
	<!-- end page container -->
	
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
	
	<!-- ================== BEGIN PAGE LEVEL JS ================== -->
    <script src="assets/plugins/parsley/dist/parsley.js"></script>
	<script src="assets/js/apps.min.js"></script>
	<!-- ================== END PAGE LEVEL JS ================== -->

	<script>
		$(document).ready(function() {
			App.init();
		});

        window.onload = function() {
          var recaptcha = document.forms["register-form"]["g-recaptcha-response"];
          recaptcha.required = true;
          recaptcha.oninvalid = function(e) {
            // do something
            // alert("Please complete the captcha");
            $("#g-recaptcha-error").html("This field is required.");
          }
        }
	</script>
</body>
</html>
