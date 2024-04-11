<script src="assets/plugins/sweetalert2/js/sweetalert2.all.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAq8WuTeXonjSzYw_vVLiN7PCRQNqf_v_Q"></script>

<script type="text/javascript">
  getLocation();

  var markers = [];
  var geocoder;
  var map;
  var meMarker;
  var currentInfoWindow = null;
  var address_location = "";
  var duration = "";

  function getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(initMap, showError);
      $('#browser-error').addClass('hide');
    } else {
      x.innerHTML = "Geolocation is not supported by this browser.";
    }
  }

  function showAgentMarkers(map) {
    for (i = 0; i < markers.length; i++) {
      markers[i].setMap(map);
    }
  }

  function removeAgentMarkers() {
    console.log(markers);
    for(i=0; i<markers.length; i++){
      markers[i].setMap(null);
    }
    markers.length = 0;
  }

  function getAgentPositions(reqMarker, check_in) {

    var lat = reqMarker.getPosition().lat();
    var lon = reqMarker.getPosition().lng();

    $.ajax({
      type: "POST",
      url: '/ws/request_agent/get_all_active_agents',
      data: { 
        'latitude': lat,
        'longitude': lon,
        'all_agents': 'true',
        'check_in_duration': check_in
      },
      dataType: "json",
      success: function(result) {
        console.log(result);

        if (result.error)
          console.log(result.message);
        else {
          if (result.count !== 0) {

            removeAgentMarkers();

            $.each(result.agents, function(index, value) {
              // last_latitude, last_longitude, phone_mobile, first_name, last_name, email 

              latlon = new google.maps.LatLng(parseFloat(value.last_latitude), parseFloat(value.last_longitude));

              var agentMarker = new google.maps.Marker({
                // icon: 'http://maps.google.com/mapfiles/ms/micons/blue-pushpin.png',
                icon: 'https://maps.google.com/mapfiles/ms/micons/cabs.png',
                scale: 4,
                position: latlon
              });

              var agentInfo =  new google.maps.InfoWindow({
                content: customMarker(value)
              });

              agentMarker.addListener('click', function() {
                if (currentInfoWindow != null) {
                  currentInfoWindow.close();
                }
                agentInfo.open(map, this);
                currentInfoWindow = agentInfo; 
              });

              // agentMarker.addListener('mouseout', function() {
              //   agentInfo.close();
              // });

              // agentMarker.setMap(map);
              markers.push(agentMarker);
            });

            showAgentMarkers(map);

            if (address_location != "") {
              // alert(address_location);
              meMarker.setPosition(address_location);
              map.setCenter(address_location);
              map.setZoom(12);
            }
            // else {
            //   meMarker.setPosition(reqMarker.LatLng());
            //   map.setCenter(reqMarker.LatLng());
            //   map.setZoom(12);
            // }

            map.addListener("click", function(event) {
              if (currentInfoWindow != null) {
                currentInfoWindow.close();
              }
            });

            // if (markers.length > 1) {
            //   var bounds = new google.maps.LatLngBounds();

            //   for(i=0;i<markers.length;i++) {
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

  function customMarker(datas) {
    var template = '';

    template += '<div class="gmap-agent-avatar">';
    if (datas.is_profile_photo == 1) {
      template += '<img height="100" alt="Agent Profile Picture" src="https://s3-us-west-2.amazonaws.com/zugent/profilephotos/'+datas.user_id+'/original.jpg" style="display: block; margin: auto;">';
    }
    else {
      template += '<img height="100" alt="Agent Profile Picture" src="/assets/img/user-0.jpg" style="display: block; margin: auto;">';
    }
    template += '</div>';
    template += '<div class="gmap-agent-info">';
    template += '<div class="gmap-agent-name">'+datas.first_name+' '+datas.last_name+'</div>';
    template += '<div class="gmap-agent-company">'+datas.company_name+'</div>';
    template += '<div class="gmap-agent-phone">'+datas.phone_mobile+'</div>';
    template += '</div>';

    return template;
  }

  function setLocation() {
    var address = document.getElementById('google-address').value;
    geocoder.geocode( { 'address': address}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {

        meMarker.setPosition(results[0].geometry.location);

        map.setCenter(results[0].geometry.location);
        map.setZoom(12);

        address_location = results[0].geometry.location;

      } else {
        alert('Geocode was not successful for the following reason: ' + status);
      }
    });
  }

  function initMap(position) {
    geocoder = new google.maps.Geocoder();
    lat = position.coords.latitude;
    lon = position.coords.longitude;
    latlon = new google.maps.LatLng(lat, lon);

    mapholder = document.getElementById("google-map");
    mapholder.style.height = '650px';
    mapholder.style.width = '100%';

    var myOptions = {
      center: latlon,
      zoom: 12,
      // minZoom: 5,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeControl: false,
      navigationControlOptions:{ style:google.maps.NavigationControlStyle.SMALL }
    }
    
    map = new google.maps.Map(document.getElementById("google-map"), myOptions);
    meMarker = new google.maps.Marker({ 
      icon: 'https://maps.google.com/mapfiles/kml/pal2/icon13.png',
      scale: 4,
      position: latlon,
      map: map
    });

    var infowindow =  new google.maps.InfoWindow({
      content: '<h5 style="margin: 1px;">You are here!</h5>'
    });

    meMarker.addListener('mouseover', function() {
      infowindow.open(map, this);
    });

    meMarker.addListener('mouseout', function() {
      infowindow.close();
    });

    getAgentPositions(meMarker, duration);

    var refreshMap = setInterval(function () {
      getAgentPositions(meMarker, duration);
    }, 60 * 1000);
  }

  function showError(error) {
    switch(error.code) {
      case error.PERMISSION_DENIED:
        swal({
          title: 'Permission Denied',
          html: "User denied the request for Geolocation.",
          type: 'error',
          allowOutsideClick: false
        }).then(function () {
          $('#browser-error').removeClass('hide');
        }, function (dismiss) {});
        break;
      case error.POSITION_UNAVAILABLE:
        swal({
          title: 'Position Unavailable',
          html: "Location information is unavailable.",
          type: 'error',
          allowOutsideClick: false
        }).then(function () {
          $('#browser-error').removeClass('hide');
        }, function (dismiss) {});
        break;
      case error.TIMEOUT:
        swal({
          title: 'Timeout',
          html: "The request to get user location timed out.",
          type: 'error',
          allowOutsideClick: false
        }).then(function () {
          $('#browser-error').removeClass('hide');
        }, function (dismiss) {});
        break;
      case error.UNKNOWN_ERROR:
        swal({
          title: 'Unknown Error',
          html: "An unknown error occurred.",
          type: 'error',
          allowOutsideClick: false
        }).then(function () {
          $('#browser-error').removeClass('hide');
        }, function (dismiss) {});
        break;
    }
  }

  $(document).ready(function() {

    $("#google-address-form").on('submit',function(e) {
      e.preventDefault();
      setLocation();
    });

    $("input[name='check_in_duration']").on('click', function(e) {
      duration = this.value;
      getLocation();
    });

  });
</script>