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

    {include file="includes/company_pages/default_search_header.tpl"}
    
    {if $page_template ne ''}
        {$page_template}
    {/if}

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
    <script src="assets/js/apps.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAq8WuTeXonjSzYw_vVLiN7PCRQNqf_v_Q"></script>
    <!-- ================== END BASE JS ================== -->
    
    <script>
        $(document).ready(function() {
            App.init();

            //Google Maps JS
            //Set Map
            function initialize() {
                var myLatlng = new google.maps.LatLng(53.3333,-3.08333);
                var imagePath = 'http://m.schuepfen.ch/icons/helveticons/black/60/Pin-location.png'
                var mapOptions = {
                    zoom: 11,
                    center: myLatlng,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                }

                var map = new google.maps.Map(document.getElementById('map'), mapOptions);
            //Callout Content
            var contentString = 'Some address here..';
            //Set window width + content
            var infowindow = new google.maps.InfoWindow({
                content: contentString
            });

            //Add Marker
            var marker = new google.maps.Marker({
                position: myLatlng,
                map: map,
                icon: imagePath,
                title: 'image title'
            });

            google.maps.event.addListener(marker, 'click', function() {
                infowindow.open(map,marker);
            });

            //Resize Function
            google.maps.event.addDomListener(window, "resize", function() {
                var center = map.getCenter();
                google.maps.event.trigger(map, "resize");
                map.setCenter(center);
            });
            }

            google.maps.event.addDomListener(window, 'load', initialize);
        });
    </script>


</body>
</html>