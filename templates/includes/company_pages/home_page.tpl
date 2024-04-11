<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<head>
    <meta charset="utf-8" />
    <title>{$company_data.company_name}</title>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
    <meta content="" name="description" />
    <meta content="" name="author" />
    
    <!-- ================== BEGIN BASE CSS STYLE ================== -->
    <link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
    <link href="assets/test_temp/company_pages/style.min.css" rel="stylesheet" />
    <link href="assets/test_temp/company_pages/style-responsive.min.css" rel="stylesheet" />
    <link href="assets/test_temp/company_pages/default.css" id="theme" rel="stylesheet" />
    <link href="assets/css/animate.min.css" rel="stylesheet" />
    <!-- ================== END BASE CSS STYLE ================== -->
    
    <!-- ================== BEGIN BASE JS ================== -->
    <script src="assets/plugins/pace/pace.min.js"></script>
    <!-- ================== END BASE JS ================== -->
</head>
<body>

    {include file="includes/company_pages/default_home_header.tpl"}
    
    {if $page_template ne ''}
        {$page_template}
    {/if}

    {include file="includes/company_pages/default_home_footer.tpl"}

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
    <script src="assets/plugins/jquery-cookie/jquery.cookie.js"></script>
    <script src="assets/js/apps.js"></script>
    <!-- ================== END BASE JS ================== -->
    
    <script>
        $(document).ready(function() {
            App.init();
            $('ul.banner-search-btn li').on('click', function() {
                $(this).parent().find('li.active').removeClass('active');
                $(this).addClass( 'active' );
            });
            $('#btn-buy').on('click', function() {
                $("#search-input").attr("placeholder", "Enter an address, city or ZIP code");
            });
            $('#btn-rent').on('click', function() {
                $("#search-input").attr("placeholder", "Enter a neighborhood, city or ZIP code");
            });
            $('#btn-sell').on('click', function() {
                $("#search-input").attr("placeholder", "Enter your home address");
            });
        });
    </script>
</body>
</html>