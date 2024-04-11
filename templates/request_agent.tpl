
<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<head>
    <meta charset="utf-8" />
    <title>RUOPEN | Request Agent Page</title>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
    <meta content="" name="description" />
    <meta content="" name="author" />
    
    <!-- ================== BEGIN BASE CSS STYLE ================== -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet">
    <link href="assets/plugins/jquery-ui/themes/base/minified/jquery-ui.min.css" rel="stylesheet" />
    <link href="assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
    <link href="assets/css/animate.min.css" rel="stylesheet" />
    <link href="assets/css/style.min.css" rel="stylesheet" />
    <link href="assets/css/style-responsive.min.css" rel="stylesheet" />
    <link href="assets/css/theme/default.css" rel="stylesheet" id="theme" />
    <link href="assets/css/custom.css" rel="stylesheet" />
    <!-- ================== END BASE CSS STYLE ================== -->
    
    <!-- ================== BEGIN PAGE CSS STYLE ================== -->
    <link href="assets/plugins/jquery.countdown/jquery.countdown.css" rel="stylesheet" />
    <!-- ================== END PAGE CSS STYLE ================== -->
    
    <!-- ================== BEGIN BASE JS ================== -->
    <script src="assets/plugins/pace/pace.min.js"></script>
    <link href="assets/plugins/parsley/src/parsley.css" rel="stylesheet" />
    <!-- ================== END BASE JS ================== -->
    <script src='https://www.google.com/recaptcha/api.js'></script>
</head>

<body class="bg-white p-t-0 pace-top">

<!-- begin #page-loader -->
<div id="page-loader" class="fade in"><span class="spinner"></span></div>
<!-- end #page-loader -->



<div class="container-fluid p-l-10 p-r-10" style="height:100%;">

    <style type="text/css">
        #geo-error {
            position: absolute;
            top: 10px;
            left: calc(50% - 120px);
            z-index: 1;
        }
    </style>

    {if isset($display_error_message)}
    <div id="geo-error">
        <div class="gray-content-box">
            <div class="alert alert-danger fade in m-b-0">
                <strong>Error!</strong>
                Something went wrong...
                <span class="close" data-dismiss="alert">×</span>
            </div>
        </div>
    </div>
    {/if}

    <div class="row" style="height:100%;position: relative;">
        <div id="left-shadow"></div>
        <div id="right-shadow"></div>
        <div id="map-container"></div>
        <div class="btn-req-box text-center">
            <div class="gray-content-box">
                <div id="message"></div>
                <div class="card-1 hovercard-1 hide">
                    <div class="card-1header"></div>
                    <div class="avatar">
                        <img id="agent-picture" alt="Agent Profile Picture" src="/assets/img/user-0.jpg">
                    </div>
                    <div class="info">
                        <div id="agent-name" class="title">
                            <!-- <a target="_blank" href="http://scripteden.com/"> -->
                            Script Eden
                            <!-- </a> -->
                        </div>
                        <div class="other-details">
                            <div id="agent-phone" class="desc">+639774044595</div>
                            <div id="agent-email" class="desc">johndoe@email.com</div>
                            <div id="agent-company" class="desc">RUOPEN</div>
                        </div>
                    </div>
                    <div class="bottom">
                        <a class="btn btn-card-1 btn-primary btn-twitter btn-sm" href="#"><i class="fa fa-twitter"></i></a>
                        <a class="btn btn-card-1 btn-primary btn-facebook btn-sm" rel="publisher" href="#"><i class="fa fa-facebook"></i></a>
                    </div>
                </div>
                <a href="javascript:void(0)" data-toggle="modal" id="showmap-btn" class="btn hide">Show Map</a>
                <!-- modal button -->
                <a href="#modal-request-agent" data-toggle="modal" id="req-btn" class="btn">Request an Agent</a>
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="modal-request-agent" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content text-center">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title" style="color:#fff;">Request an Agent</h4>
            </div>
            <div class="modal-body p-20">
                <p class="desc">Please fill in the required information below.</p>
                <form id="frm-request" name="frm-request" data-parsley-validate="true">
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input id="first-name" type="text" class="form-control" placeholder="First Name*" autocomplete="off" data-parsley-required="true"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input id="last-name" type="text" class="form-control" placeholder="Last Name*" autocomplete="off" data-parsley-required="true"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input id="email-address" type="text" class="form-control" placeholder="Email Address*" autocomplete="off" data-parsley-required="true"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input id="phone" type="text" class="form-control phone-us" placeholder="Mobile No.*" autocomplete="off" data-parsley-required="true"/>
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
                        <button type="submit" class="btn btn-sm btn-success"><i class="fa fa-user-secret"></i> Submit</button>
                    </div>
                    </div>
                    <p class="help-block m-b-25"><i>We don't spam. Your email address is secure with us.</i></p>
                </form>
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

<!-- ================== BEGIN PAGE LEVEL JS ================== -->
<script src="assets/plugins/jquery.countdown/jquery.plugin.js"></script>
<script src="assets/plugins/jquery.countdown/jquery.countdown.js"></script>
<script src="assets/js/coming-soon.demo.js"></script>
<script src="assets/js/apps.min.js"></script>
<!-- ================== END PAGE LEVEL JS ================== -->
<script src="assets/js/jquery.mask.js"></script>
<script src="assets/plugins/parsley/dist/parsley.js"></script>

<script type="text/javascript">

    App.init();
    getLocation(true);

    var x = document.getElementById("message");
    var markers = []; 
    var reqMarker;
    var accMarker;
    var latitude;
    var longitude;
    var map;

    function getLocation(initMap) {
        if (!initMap) {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(showPosition, showError);
            } else { 
                console.log("Geolocation is not supported by this browser.");
            }
        }
        else 
            navigator.geolocation.getCurrentPosition(initializeMap, showError);
    }

    function toRad(x) {
        return x * Math.PI / 180;
    }

    function getDistance (p1Lat, p1Lon, p2Lat, p2Lon) {
        // PSUEDO: Pass two points | then get distance bet two points in rads | then use formula | then return in meters or miles
        var meters = 6378137; 
        var miles = 3959;
        var disLat = toRad(p2Lat - p1Lat);
        var disLong = toRad(p2Lon - p1Lon);
        // Start Haversines
        var a = Math.sin(disLat / 2) * Math.sin(disLat / 2) + Math.cos(toRad(p1Lat)) * Math.cos(toRad(p2Lat)) * Math.sin(disLong / 2) * Math.sin(disLong / 2);
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        // Convert to 2 Decimal places c * miles; Scaling fix
        return Math.round((c * miles + 0.00001) * 100) / 100; 
    }

    function showPosition(position) {
        this.latitude = position.coords.latitude;
        this.longitude = position.coords.longitude;

        latlon = new google.maps.LatLng(this.latitude, this.longitude)
        mapholder = document.getElementById('map-container')
        mapholder.style.height = '100%';
        mapholder.style.width = '100%';

        var myOptions = {
            center:latlon,
            zoom:16,
            mapTypeId:google.maps.MapTypeId.ROADMAP,
            mapTypeControl:false,
            navigationControlOptions:{ style:google.maps.NavigationControlStyle.SMALL },
            gestureHandling: 'cooperative'
        }

        this.map = new google.maps.Map(document.getElementById("map-container"), myOptions);
        var marker = new google.maps.Marker({ 
                                icon: 'https://maps.google.com/mapfiles/kml/pal2/icon13.png',
                                scale: 3,
                                position:latlon,
                                map:this.map,
                                title:"You are here!" 
                            });
        reqMarker = marker;

        getAgents();
    }

    function initializeMap(position) {
        this.latitude = position.coords.latitude;
        this.longitude = position.coords.longitude;

        latlon = new google.maps.LatLng(this.latitude, this.longitude)
        mapholder = document.getElementById('map-container')
        mapholder.style.height = '100%';
        mapholder.style.width = '100%';

        var myOptions = {
            center:latlon,
            zoom:16,
            mapTypeId:google.maps.MapTypeId.ROADMAP,
            mapTypeControl:false,
            navigationControlOptions:{ style:google.maps.NavigationControlStyle.SMALL },
            gestureHandling: 'cooperative'
        }
        
        this.map = new google.maps.Map(document.getElementById("map-container"), myOptions);
        var marker = new google.maps.Marker({ 
                                icon: 'https://maps.google.com/mapfiles/kml/pal2/icon13.png',
                                scale: 3,
                                position:latlon,
                                map:this.map,
                                title:"You are here!" 
                            });
        reqMarker = marker;

        getAgentPositions();
    }

    function getAgentPositions() {

        var lat = reqMarker.getPosition().lat();
        var lon = reqMarker.getPosition().lng();

        $.ajax({
            type: "POST",
            url: '/ws/request_agent/get_agents',
            data: { 
                'latitude': lat, 
                'longitude': lon,
                'agents_only': 'true'
            },
            dataType: "json",
            success: function(result) {
                console.log(result);

                if (result.error)
                    console.log(result.message);
                else {
                    if (result.count !== 0) {
                        $.each(result.agents, function(index, value) {
                            // last_latitude, last_longitude, phone_mobile, first_name, last_name, email 

                            latlon = new google.maps.LatLng(parseFloat(value.last_latitude), parseFloat(value.last_longitude));

                            var agentMarker = new google.maps.Marker({ 
                                icon: 'https://maps.google.com/mapfiles/ms/micons/cabs.png',
                                scale: 3,
                                position: latlon,
                                title: ""+index
                            });

                            agentMarker.setMap(map);
                        });

                        if (markers.length > 1) {
                            var bounds = new google.maps.LatLngBounds();
                            for(i=0;i<markers.length;i++) {
                               bounds.extend(markers[i].getPosition());
                            }
                            map.fitBounds(bounds);
                        }

                    }
                    // else {
                    //     // alert("Sorry but there are no available agents near you.");
                    //     $("#message").html("Sorry but there are no available agents near you.");

                    //     $(".btn-req-box").hCenter();
                    //     $("#message").addClass("alert alert-warning");
                    // }
                }

            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
            }
        });
    }


    function showError(error) {
        switch(error.code) {
            case error.PERMISSION_DENIED:
                console.log ("User denied the request for Geolocation.")
                break;
            case error.POSITION_UNAVAILABLE:
                console.log("Location information is unavailable.")
                break;
            case error.TIMEOUT:
                console.log("The request to get user location timed out.")
                break;
            case error.UNKNOWN_ERROR:
                console.log("An unknown error occurred.")
                break;
        }
    }

    function clearRequestForm(){
        $("#first-name").val("");
        $("#last-name").val("");
        $("#email-address").val("");
        $("#phone").val("");
        $("#frm-request").parsley().reset();
    }

    function getAgents() {

        var lat = reqMarker.getPosition().lat();
        var lon = reqMarker.getPosition().lng();

        $.ajax({
            type: "POST",
            // url: '/services/request_agent.php',
            url: '/ws/request_agent/get_agents',
            data: { 
                'first_name': $("#first-name").val(), 
                'last_name': $("#last-name").val(), 
                'email_address': $("#email-address").val(), 
                'latitude': lat, 
                'longitude': lon, 
                'phone': $("#phone").val() 
            },
            dataType: "json",
            success: function(result) {
                console.log(result);
                $("#page-loader").addClass('hide');

                if (result.error)
                    console.log(result.message);
                else {
                    if (result.count !== 0) {
                        $("#message").html(result.count + " agent/s found near you. You'll be sent a text message as soon as someone accepts the request.");
                        $("#message").addClass("alert alert-info");

                        $(".btn-req-box").hCenter();
                        $.each(result.agents, function(index, value) {
                            // last_latitude, last_longitude, phone_mobile, first_name, last_name, email 
                            console.log(index + ": " +value);
                            latlon = new google.maps.LatLng(parseFloat(value.last_latitude), parseFloat(value.last_longitude));

                            var agentMarker = new google.maps.Marker({ 
                                icon: 'https://maps.google.com/mapfiles/ms/micons/cabs.png',
                                scale: 3,
                                position: latlon,
                                title: ""+index
                            });

                            agentMarker.setMap(map);
                            markers.push(agentMarker);
                        });

                        var bounds = new google.maps.LatLngBounds();
                        for(i=0;i<markers.length;i++) {
                           bounds.extend(markers[i].getPosition());
                        }
                        map.fitBounds(bounds);

                        var checkForResponse = setInterval(function () {

                            $.ajax({
                                type: "POST",
                                // url: '/services/request_agent.php',
                                url: '/ws/request_agent/check_response_agent',
                                data: { 
                                    'contact_id': result.id, 
                                    'phone': $("#phone").val()
                                },
                                dataType: "json",
                                success: function(response) {
                                    console.log(response);

                                    if (response.accepted) {

                                        $("#agent-details").removeClass('hide');
                                        $("#agent-details").addClass('in');
                                        $("#request-area").addClass('fade hide');
                                        $("#agent-name").html(response.agent.first_name+" "+response.agent.last_name);
                                        $("#agent-phone").html("<a href='tel:"+response.agent.phone_mobile+"'>"+response.agent.phone_mobile+"</a>");
                                        $("#agent-email").html(response.agent.email);
                                        $("#agent-company").html(response.agent.company_name);
                                        $(".btn-twitter").prop("href", ""+response.agent.url_twitter);
                                        $(".btn-facebook").prop("href", ""+response.agent.url_facebook);

                                        latlon = new google.maps.LatLng(parseFloat(response.lat), parseFloat(response.lon));
                                        $("#message").html("<strong>Success!</strong> An agent has accepted your request you can track the agent's location in the map. <br>You: Marker 1<br> Agent: Marker 2 <br>Scroll down to see the agent's details.");
                                        clearInterval(checkForResponse);
                                        $("#message").removeClass("alert-info");
                                        $("#message").addClass("alert-success");

                                        if (response.agent.is_profile_photo == 1) {
                                            $(".avatar").html('<img id="agent-picture" alt="Agent Profile Picture" src="https://s3-us-west-2.amazonaws.com/zugent/profilephotos/'+response.agent.user_id+'/original.jpg"/>');
                                        }
                                        else {
                                            $(".avatar").html('<img id="agent-picture" alt="Agent Profile Picture" src="/assets/img/user-0.jpg"/>');
                                        }


                                        $(".btn-req-box").hCenter();

                                        var agentMarker = new google.maps.Marker({ 
                                            icon: 'https://maps.google.com/mapfiles/ms/micons/cabs.png',
                                            position:latlon,
                                            title:"Agent"
                                        });

                                        accMarker = agentMarker;
                                        updateAgentPosition(response.agent_id);

                                        $(".hovercard-1").removeClass('hide');
                                        $("#req-btn").addClass('hide');
                                        $("#showmap-btn").removeClass('hide');
                                    }

                                },
                                error: function (XMLHttpRequest, textStatus, errorThrown) {
                                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
                                }
                            });
                        }, 5000);
                    }
                    else {
                        // alert("Sorry but there are no available agents near you.");
                        $("#message").html("Sorry but there are no available agents near you.");
                        $("#message").addClass("alert alert-warning");
                        $(".btn-req-box").hCenter();
                    }
                }

            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
            }
        });
    }

    function updateAgentPosition(id) {
        console.log(markers);
        accMarker.setMap(map);
        this.map.setCenter(accMarker.getPosition());
        var lat = reqMarker.getPosition().lat();
        var lon = reqMarker.getPosition().lng();

        for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(null);
        }

        var checkForResponse = setInterval(function () {

            $.ajax({
                type: "POST",
                // url: '/services/request_agent.php',
                url: '/ws/request_agent/update_agent_position',
                data: { 
                    'agent_id': id
                },
                dataType: "json",
                success: function(response) {
                    console.log("lat1: "+response.lat+", lon1: "+response.lon+", lat2: " +lat+", lon2: "+lon);
                    latlon = new google.maps.LatLng(parseFloat(response.lat), parseFloat(response.lon));
                    accMarker.setPosition(latlon);
                    $("#message").html("<strong>Success!</strong> An agent has accepted your request you can track the agent's location in the map. <br>Scroll down to see the agent's details.<br><br>Red marker = You<br> Blue Marker = Agent<br><br>Distance: "+getDistance(response.lat,response.lon,lat,lon)+" mile/s away");
                    if (getDistance(response.lat,response.lon,lat,lon) < .2) {
                        console.log('Agent has Arrived');
                        clearInterval(checkForResponse);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
                }
            });

        }, 5000);
    }

    $(document).ready(function () {

        $.fn.hCenter = function() {
            $(this).css({ 'left': ($(window).width() - $(this).outerWidth()) / 2 });
        }

        $(".btn-req-box").hCenter();

        $("#btn-request").on("click", function(){

            $(".btn-req-box").hCenter();
            $("#page-loader").removeClass('hide');
            if (navigator.geolocation) {
                getLocation(false);
            }
        });

        $("#frm-request").on('submit',function(e) {
            e.preventDefault();
            if ( $(this).parsley().isValid() ) {
                $('#modal-request-agent').modal('hide');
                $("#page-loader").removeClass('hide');
                if (navigator.geolocation) {
                    getLocation(false);
                }
                $("#btn-request").hide(1000);
                $(".btn-req-box").hCenter();
            }
        });

        $("#showmap-btn").on("click", function(){
            // $(".hovercard-1 .info .other-details").hide(1000);

            $(this).hide(300);
            $("#message").hide(1000);
            $(".hovercard-1 .bottom").hide(1000);
            $(".hovercard-1").css({
                'margin-bottom' : '0',
                'padding' : '2px'
            });
            $(".card-1header").hide(1000);
            $(".avatar").animate({
                'top' : '0px',
                'float' : 'left'
            },1000);
            $(".btn-req-box").animate({
                'bottom' : '3%',
                'left' : '3%',
                'width' : '300px'
            }, 1000);
            $(".avatar").addClass("pull-left");
            $(".info").addClass("text-right");
            $(".info").animate({
                'text-align' : 'right',
            }, 1000);

            $(".btn-req-box").hCenter();
        });

        $("#modal-request-agent").on("hidden.bs.modal", function () {
            $(".btn-req-box").show(500);
        });

        $("#req-btn").on("click", function() {
            $(".btn-req-box").hide(500);
        });
    });

</script>
    
<script type="text/javascript">

    // window.onload = function() {
    //   var recaptcha = document.forms["frm-request"]["g-recaptcha-response"];
    //   recaptcha.required = true;
    //   recaptcha.oninvalid = function(e) {
    //     // do something
    //     alert("Please complete the captcha");
    //   }
    // }

</script>

<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAq8WuTeXonjSzYw_vVLiN7PCRQNqf_v_Q"></script>

</body>
</html>
