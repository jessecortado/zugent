<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
<script src="assets/plugins/sweetalert2/js/sweetalert2.all.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAq8WuTeXonjSzYw_vVLiN7PCRQNqf_v_Q"></script>

<script type="text/javascript">
  var x = document.getElementById("message");
  var user_direction = "{$user_direction}";
  var changed = false;
  {if $user_perm_drive eq 'true'}
  var perm_drive = true;
  getLocation(true);
  {else}
  var perm_drive = false;
  {/if}

  console.log(driving);

  var driving = false;
  var gmarkers = [];
  var driving_msg = "Drive mode has been enabled. ";
      driving_msg+= "Please leave this page open while driving to continuously update your location. ";
      driving_msg+= "When you're drive has completed please leave this page or click \"Stop Driving\". Your location will be refreshed in 60 seconds. ";
      driving_msg+= "Your location will be refreshed in 60 seconds.";
  var initial = true;
  var driveInterval;
  var geocoder;

  var test_ctr = 0;

  function savePosition(lat, lon) {
    $.ajax({
        type: "POST",
        url: '/ws/user/set_location',
        data: { 'lat': lat, 'lon': lon },
        dataType: "json",
        success: function(result) {
            console.log(result);
            location.reload();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
        }
    });
  }

  function getLocation(isDriving) {
    if (navigator.geolocation) {
      if(isDriving) 
        navigator.geolocation.getCurrentPosition(drive, showError);
      else
        navigator.geolocation.getCurrentPosition(showPosition, showError);
    } else { 
        x.innerHTML = "Geolocation is not supported by this browser.";
    }
  }

  function drive(position) {

    if (driving == false) {
      $("#btn-drive").html("<i class='fa fa-ban'></i> Stop Driving");
      $("#btn-drive").removeClass("btn-primary");
      $("#btn-drive").addClass("btn-danger");
      driving = true;
    }
    else {
      $("#btn-drive").html("<i class='fa fa-car'></i> Start Driving");
      $("#btn-drive").removeClass("btn-danger");
      $("#btn-drive").addClass("btn-primary");
      driving = false;
    }


    if (driving && perm_drive) {

      $("#browser-info").removeClass("hide");

      lat = position.coords.latitude;
      lon = position.coords.longitude;
      latlon = new google.maps.LatLng(lat, lon);

      mapholder = document.getElementById('map-container');
      mapholder.style.height = '300px';
      mapholder.style.width = '100%';

      var myOptions = {
        center:latlon,zoom:16,
        mapTypeId:google.maps.MapTypeId.ROADMAP,
        mapTypeControl:false,
        navigationControlOptions:{ style:google.maps.NavigationControlStyle.SMALL }
      }
      
      var map = new google.maps.Map(document.getElementById("map-container"), myOptions);

      // Get direction on agent
      if (user_direction != null && user_direction !== "") {
        var agent_icon = '/assets/img/cars/car_'+user_direction.toLowerCase()+'.png';
      }
      else {
        var agent_icon = '/assets/img/cars/car_n.png';
      }

      var marker = new google.maps.Marker({
                        // icon: 'https://maps.google.com/mapfiles/ms/micons/cabs.png',
                        icon: agent_icon,
                        position:latlon,
                        map:map,
                        title:"You are here!"
                      });

      var agentInfo =  new google.maps.InfoWindow({
        content: "<b>You are here!</b>"
      });

      marker.addListener('mouseover', function() {
        agentInfo.open(map, this);
      });

      marker.addListener('mouseout', function() {
        agentInfo.close();
      });

      if (initial) {
        getDrivingLocations(lat, lon, map, marker); //initial load
      }

      driveInterval = setInterval(function () {

        navigator.geolocation.getCurrentPosition(function(position) {
          // Get New Position
          lat = position.coords.latitude;
          lon = position.coords.longitude;

          if(locationChanged(lat,lon)) {
            getDrivingLocations(lat, lon, map, marker);
          }
        },
        function (error) {
          showError(error);
        });

      }, 1000 * 60);

      goToTop();

    }
    else if (driving) {

      swal({
        title: "You've started your drive!",
        html: driving_msg.replace('\"','"'),
        type: 'success',
        allowOutsideClick: false
      }).then(function () {

        $("#browser-info").removeClass("hide");

        lat = position.coords.latitude;
        lon = position.coords.longitude;
        latlon = new google.maps.LatLng(lat, lon);

        mapholder = document.getElementById('map-container');
        mapholder.style.height = '300px';
        mapholder.style.width = '100%';

        var myOptions = {
          center:latlon,zoom:16,
          mapTypeId:google.maps.MapTypeId.ROADMAP,
          mapTypeControl:false,
          navigationControlOptions:{ style:google.maps.NavigationControlStyle.SMALL }
        }
        
        var map = new google.maps.Map(document.getElementById("map-container"), myOptions);

        // Get direction on agent
        if (user_direction != null && user_direction !== "") {
          var agent_icon = '/assets/img/cars/car_'+user_direction.toLowerCase()+'.png';
        }
        else {
          var agent_icon = '/assets/img/cars/car_n.png';
        }

        var marker = new google.maps.Marker({
                          // icon: 'https://maps.google.com/mapfiles/ms/micons/cabs.png',
                          // icon: agent_icon,
                          icon: 'http://maps.google.com/mapfiles/marker.png',
                          position:latlon,
                          map:map,
                          title:"You are here!"
                        });

        var agentInfo =  new google.maps.InfoWindow({
          content: "<b>You are here!</b>"
        });

        marker.addListener('mouseover', function() {
          agentInfo.open(map, this);
        });

        marker.addListener('mouseout', function() {
          agentInfo.close();
        });

        if (initial) {
          getDrivingLocations(lat, lon, map, marker); //initial load
        }

        driveInterval = setInterval(function () {

            navigator.geolocation.getCurrentPosition(function(position) {
              // Get New Position
              lat = position.coords.latitude;
              lon = position.coords.longitude;

              if(locationChanged(lat,lon)) {
                getDrivingLocations(lat, lon, map, marker);
              }
            },
            function (error) {
              showError(error);
            });

        }, 1000 * 60);

        goToTop();

      }, function (dismiss) {});

    }
    else {
      swal({
        title: 'Drive Stopped',
        html: 'Your drive has been stopped and your location will no longer be updated. Thank you.',
        type: 'error',
        allowOutsideClick: false
      }).then(function () {
        $("#browser-info").addClass("hide");
        clearInterval(driveInterval);
        initial = true;
        goToTop();
      }, function (dismiss) {});
    }
  }

  function getDrivingLocations(lat, lon, map, marker) {
    $.ajax({
      type: "POST",
      url: '/ws/user/set_location',
      data: { 
        'lat': lat, 
        'lon': lon,
        'driving': 'true',
      },
      dataType: "json",
      success: function(response) {
        if (driving) {
          console.log(response);
          latlon = new google.maps.LatLng(lat, lon);
          marker.setPosition(latlon);
          
              console.log(latlon);

          // Get direction on agent
          if (response.direction != null && response.direction !== "") {
            var agent_icon = '/assets/img/cars/car_'+response.direction.toLowerCase()+'.png';
          }
          else {
            var agent_icon = '/assets/img/cars/car_e.png';
          }

          // marker.setIcon(agent_icon);
          map.setCenter(latlon);

          reqMarker = marker;
          removeAgentMarkers();
          getAgentPositions(map);
          initial = false;
        }
        else {
          $("#browser-info").addClass("hide");
          clearInterval(driveInterval);
          initial = true;
        }
      },
      error: function (XMLHttpRequest, textStatus, errorThrown) {
        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
      }
    });
  }

  function showPosition(position) {
    lat = position.coords.latitude;
    lon = position.coords.longitude;

    if (locationChanged(lat,lon)) {
      latlon = new google.maps.LatLng(lat, lon);
      mapholder = document.getElementById('map-container');
      mapholder.style.height = '300px';
      mapholder.style.width = '100%';

      var myOptions = {
        center:latlon,zoom:16,
        mapTypeId:google.maps.MapTypeId.ROADMAP,
        mapTypeControl:false,
        navigationControlOptions:{ style:google.maps.NavigationControlStyle.SMALL }
      }

      var map = new google.maps.Map(document.getElementById("map-container"), myOptions);

      // Get direction on agent
      if (user_direction != null && user_direction !== "") {
        var agent_icon = '/assets/img/cars/car_'+user_direction.toLowerCase()+'.png';
      }
      else {
        var agent_icon = '/assets/img/cars/car_n.png';
      }

      var marker = new google.maps.Marker({
                          // icon: 'https://maps.google.com/mapfiles/ms/micons/cabs.png',
                          icon: agent_icon,
                          position:latlon,
                          map:map,
                          title:"You are here!"
                        });

      var agentInfo =  new google.maps.InfoWindow({
        content: "<b>You are here!</b>"
      });

      marker.addListener('mouseover', function() {
        agentInfo.open(map, this);
      });

      marker.addListener('mouseout', function() {
        agentInfo.close();
      });

      savePosition(lat,lon);
    }
  }

  function viewPosition(latlon) {
    mapholder = document.getElementById('map-container');
    mapholder.style.height = '300px';
    mapholder.style.width = '100%';

    var myOptions = {
    center:latlon,zoom:16,
    mapTypeId:google.maps.MapTypeId.ROADMAP,
    mapTypeControl:false,
    navigationControlOptions:{ style:google.maps.NavigationControlStyle.SMALL }
    }
    
    var map = new google.maps.Map(document.getElementById("map-container"), myOptions);

    // Get direction on agent
    if (user_direction != null && user_direction !== "") {
      var agent_icon = '/assets/img/cars/car_'+user_direction.toLowerCase()+'.png';
    }
    else {
      var agent_icon = '/assets/img/cars/car_n.png';
    }

    var marker = new google.maps.Marker({
                        // icon: 'https://maps.google.com/mapfiles/ms/micons/cabs.png',
                        icon: agent_icon,
                        position:latlon,
                        map:map,
                        title:"You are here!"
                      });

    var agentInfo =  new google.maps.InfoWindow({
      content: "<b>You are here!</b>"
    });

    marker.addListener('mouseover', function() {
      agentInfo.open(map, this);
    });

    marker.addListener('mouseout', function() {
      agentInfo.close();
    });

  }

  function showAgentMarkers(map) {
    for (i = 0; i < gmarkers.length; i++) {
      gmarkers[i].setMap(map);
    }
  }

  function removeAgentMarkers(){
    console.log(gmarkers);
    for(i=0; i<gmarkers.length; i++){
      gmarkers[i].setMap(null);
    }
    gmarkers.length = 0;
  }


  function getLocationAddress() {
    geocoder = new google.maps.Geocoder();
    var latlng = new google.maps.LatLng(-34.397, 150.644);

    var myOptions = {
    center:latlng,zoom:16,
    mapTypeId:google.maps.MapTypeId.ROADMAP,
    mapTypeControl:false,
    navigationControlOptions:{ style:google.maps.NavigationControlStyle.SMALL }
    }
    
    var map = new google.maps.Map(document.getElementById("map-container"), myOptions);

    if (geocoder) {
      geocoder.geocode({
        'address': $("#location-address").val()
      }, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          if (status != google.maps.GeocoderStatus.ZERO_RESULTS) {
            map.setCenter(results[0].geometry.location);
            
            console.log(results);

            savePosition(results[0].geometry.location.lat(),results[0].geometry.location.lng());

            var infowindow = new google.maps.InfoWindow({
              content: '<b>' + $("#location-address").val() + '</b>',
              size: new google.maps.Size(150, 50)
            });

            var marker = new google.maps.Marker({
                                icon: 'https://maps.google.com/mapfiles/ms/micons/cabs.png',
                                position:results[0].geometry.location,
                                map:map,
                                title:"You are here!"
                              });

            google.maps.event.addListener(marker, 'click', function() {
              infowindow.open(map, marker);
            });

          } else {
            alert("No results found");
          }
        } else {
          alert("Geocode was not successful for the following reason: " + status);
        }
      });
    }
  }
  // google.maps.event.addDomListener(window, 'load', initialize);

  function getAgentPositions(map) {

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

              console.log(latlon);

              // Get direction on agent
              if (value.direction != null && value.direction !== "") {
                var agent_icon = '/assets/img/cars/car_'+value.direction.toLowerCase()+'.png';
              }
              else {
                var agent_icon = '/assets/img/cars/car_n.png';
              }

              var agentMarker = new google.maps.Marker({
                icon: agent_icon,
                position: latlon,
                title: ""+index
              });

              gmarkers.push(agentMarker);
              showAgentMarkers(map);
              // agentMarker.setMap(map);
            });

           //  if (markers.length > 1) {
           //    var bounds = new google.maps.LatLngBounds();
           //    for(i=0;i<markers.length;i++) {
           //     bounds.extend(markers[i].getPosition());
           //   }
           //   map.fitBounds(bounds);
           // }

          }
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
        x.innerHTML = "User denied the request for Geolocation."
        swal({
          title: 'Permission Denied',
          html: "User denied the request for Geolocation.",
          type: 'error',
          allowOutsideClick: false
        }).then(function () {
          $("#map-error").removeClass("hide");
          goToTop();
        }, function (dismiss) {});
        break;
      case error.POSITION_UNAVAILABLE:
        x.innerHTML = "Location information is unavailable."
        swal({
          title: 'Position Unavailable',
          html: "Location information is unavailable.",
          type: 'error',
          allowOutsideClick: false
        }).then(function () {
          $("#map-error").removeClass("hide");
          goToTop();
        }, function (dismiss) {});
        break;
      case error.TIMEOUT:
        x.innerHTML = "The request to get user location timed out."
        swal({
          title: 'Timeout',
          html: "The request to get user location timed out.",
          type: 'error',
          allowOutsideClick: false
        }).then(function () {
          $("#map-error").removeClass("hide");
          goToTop();
        }, function (dismiss) {});
        break;
      case error.UNKNOWN_ERROR:
        x.innerHTML = "An unknown error occurred."
        swal({
          title: 'Unknown Error',
          html: "An unknown error occurred.",
          type: 'error',
          allowOutsideClick: false
        }).then(function () {
          $("#map-error").removeClass("hide");
          goToTop();
        }, function (dismiss) {});
        break;
    }
  }

  function initMap(latitude,longitude) {
    var pos = new google.maps.LatLng(latitude, longitude);
    viewPosition(pos);
  }

  function checkPermission(result, position=null) {
    if (result) {
      swal({
        title: 'Location Set!',
        type: 'success',
        allowOutsideClick: false
      }).then(function () {
        $('#browser-error').addClass('hide');
        showPosition(position);
      }, function (dismiss) {});
    }
    else {
      $('#browser-error').removeClass('hide');
    }
  }

  function locationChanged(lat, lon) {

    // CHECK USER LOCATION
    $.ajax({
      type: "POST",
      url: '/ws/user/location_changed',
      data: { 
        'lat': lat, 
        'lon': lon
      },
      dataType: "json",
      async: false,
      success: function(response) {
        if (response) {
          changed = true;
        }
        else {
          changed = false;
        }
      },
      error: function (XMLHttpRequest, textStatus, errorThrown) {
        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
      }
    });

    return changed;
  }

  function goToTop() {
    $("html,body").animate({
      scrollTop: $("#content").offset().top
    }, 'fast');
  }

  // Geolocation API
  // https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyBuYrziPHytz3v0V6pzPDrcAFNe0wxS-GA

  $(document).ready(function() {

    $("[rel='tooltip']").tooltip();

    {if $user_locations|count eq 0}
      $('#location-not-set').css('display','block');
      $('#location-set').css('display','none');
    {else}
      $('#location-not-set').css('display','none');
      $('#location-set').css('display','block');
      initMap({$user_latitude},{$user_longitude});
    {/if}

    $(document).on("click", ".btn-view-in-map", function() { 
      if (navigator.geolocation) {
        console.log($(this).data("lat") + " , " + $(this).data("lon"))
        var pos = new google.maps.LatLng($(this).data("lat"), $(this).data("lon"));
        viewPosition(pos);
      } else { 
        x.innerHTML = "Geolocation is not supported by this browser.";
      }
    });

    $(document).on("click", "#set-location", function() {

      navigator.geolocation.getCurrentPosition(function(position) {
        checkPermission(true, position);
      },
      function (error) { 
        if (error.code)
          // checkPermission(false);
          $("#location-error").text("Error: " + error.message);
          $("#modal-get-location-address").modal("show");
      });

    });

    $("#check-in").click(function() {

      navigator.geolocation.getCurrentPosition(function(position) {
        var lat2 = position.coords.latitude;
        var lon2 = position.coords.longitude;

        if (locationChanged(lat2,lon2)) {
          swal({
            title: 'You have checked in!',
            html: 'Page will reload to apply changes',
            type: 'success',
            allowOutsideClick: false
          }).then(function () {
            savePosition(lat2, lon2);
          }, function (dismiss) {});
        }
        else {
          // swal('Same location detected', 'Your location has not been changed.', 'warning');
          swal({
            title: 'Same location detected!',
            html: 'Your location has not been changed<br>Page will reload to apply changes',
            type: 'warning',
            allowOutsideClick: false
          }).then(function () {
            savePosition(lat2, lon2);
          }, function (dismiss) {});
        }
      },
      function (error) { 
        if (error.code)
          $("#location-error").text("Error: " + error.message);
          $("#modal-get-location-address").modal("show");
      });

    });

    $("#modal-save-location-address").click(function() {
      $("#form-get-location-address").submit();
    });

    $('#modal-save-location-address').on('hide.bs.modal', function (){
      $('#form-get-location-address').parsley().reset();
    });

    $("#form-get-location-address").on("submit", function(e){
      e.preventDefault();
      if ( $(this).parsley().isValid() ) {
        getLocationAddress();
      }
    });

  });
</script>

{include file="includes/modal_contact_send_email.tpl"}