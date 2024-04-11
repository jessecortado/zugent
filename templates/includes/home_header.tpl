<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<head>
	<meta charset="utf-8" />
	<title>Real Estate Back Office Services</title>
	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
	<meta name="description" content="ZugEnt is a real estate package suite offering full end to end real estate technical services and tools to succeed for both agents and brokers." />
	<meta name="author" content="ZugEnt" />

    <meta name="keywords" content="real estate back office transaction management lead" />

    <meta property="og:type" content="website" />
    <meta property="og:url" content="http://crm.ruopen.com"/>
    <meta property="og:description" content="ZugEnt is a real estate package suite offering full end to end real estate technical services and tools to succeed for both agents and brokers."/>
    <meta property="og:image" content="http://crm.ruopen.com/assets/img/zug_logo.png"/>

	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
	<meta name="mobile-web-app-capable" content="yes">

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
	<link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
	<link href="assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
	<link href="assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
	<link href="assets/css/animate.min.css" rel="stylesheet" />
	<!-- ================== END BASE CSS STYLE ================== -->

    <!-- ================== BEGIN LOGIN CSS STYLE ================== -->
    <link href="assets/css/home_style.css" rel="stylesheet" />
    <link href="assets/css/home_style-responsive.min.css" rel="stylesheet" />
    <!-- ================== END LOGIN CSS STYLE ================== -->
	
	<!-- ================== BEGIN BASE JS ================== -->
	<script src="assets/plugins/pace/pace.min.js"></script>
	<!-- ================== END BASE JS ================== -->
</head>
<body data-spy="scroll" data-target="#header-navbar" data-offset="51">
    <!-- begin #page-container -->
    <div id="page-container" class="fade">
        <!-- begin #header -->
        <div id="header" class="header navbar navbar-default navbar-fixed-top">
            <!-- begin container -->
            <div class="container">
                <!-- begin navbar-header -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#header-navbar">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a href="/" class="navbar-brand">
                        <span class="brand-logo"><img src="/assets/img/zug_logo.png"/></span>
                    </a>
                </div>
                <!-- end navbar-header -->
                <!-- begin navbar-collapse -->
                <div class="collapse navbar-collapse" id="header-navbar">
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="{if !$is_index}/index.php{/if}#home" {if $is_index}data-click="scroll-to-target" data-target="#" data-toggle="dropdown"{/if}>HOME</a></li>
                        <li><a href="/blog.php">BLOG</a></li>
                        <li><a href="{if !$is_index}/index.php{/if}#about" {if $is_index}data-click="scroll-to-target"{/if}>ABOUT</a></li>
                        <li><a href="{if !$is_index}/index.php{/if}#service" {if $is_index}data-click="scroll-to-target"{/if}>SERVICES</a></li>
                        {*<li><a href="{if !$is_index}/index.php{/if}#pricing" {if $is_index}data-click="scroll-to-target"{/if}>PRICING</a></li>*}
                        <li><a href="{if !$is_index}/index.php{/if}#contact" {if $is_index}data-click="scroll-to-target"{/if}>CONTACT</a></li>
                        <li><a href="/login.php">LOGIN</a></li>
                    </ul>
                </div>
                <!-- end navbar-collapse -->
            </div>
            <!-- end container -->
        </div>
        <!-- end #header -->