<script src="assets/plugins/sweetalert2/js/sweetalert2.all.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAq8WuTeXonjSzYw_vVLiN7PCRQNqf_v_Q"></script>

<script type="text/javascript">
  getLocation();
  
  setInterval(function(){
    updateTables();
  }, 1000 * 30);

  var markers = [];
  var geocoder;
  var map;
  var meMarker;
  var currentInfoWindow = null;
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

              // Get direction on agent
              if (value.direction != null && value.direction !== "") {
                var agent_icon = '/assets/img/cars/car_'+value.direction.toLowerCase()+'.png';
              }
              else {
                var agent_icon = '/assets/img/cars/car_n.png';
              }

              var agentMarker = new google.maps.Marker({
                // icon: 'http://maps.google.com/mapfiles/ms/micons/blue-pushpin.png',
                // icon: 'https://maps.google.com/mapfiles/ms/micons/cabs.png',
                icon: agent_icon,
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

  function initMap(position) {
    geocoder = new google.maps.Geocoder();
    lat = position.coords.latitude;
    lon = position.coords.longitude;
    latlon = new google.maps.LatLng(lat, lon);

    mapholder = document.getElementById("map-container");
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
    
    map = new google.maps.Map(document.getElementById("map-container"), myOptions);
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
    }, 30 * 1000);
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

  function updateTables() {
    $.ajax({
      type: "POST",
      url: '/ws/request_agent/drive_monitor',
      dataType: 'JSON',
      success: function(result) {
          console.log(result);
          updateAgentRequests(result.contacts);
          updateAgentsDriving(result.agents_driving);
          updateCounters(result);
      },
      error: function (XMLHttpRequest, textStatus, errorThrown) {
          console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
      }
    });
  }
  
  function updateCounters(data){
    $('#total-agents-div').html(data.agent_requests.length);
    $('#total-drivers-div').html(data.agents_driving.length);
    $('#total-contacts-div').html(data.accepted_reqs_ct);
  }
  function updateAgentRequests(data){
    
    $('#agent-requests-div').html('');
    var string = '';

    if(data.length > 0){
      string += '<div class="table-responsive">' +
              '<table class="table">' +
                '<thead>' +
                  '<tr>' +
                    '<th></th>' +
                    '<th>Name</th>' +
                    '<th class="text-center">Company</th>' +
                    '<th class="text-center">Phone No.</th>' +
                    '<th class="text-center">Date</th>' +
                    '<th class="text-right">Accepted</th>' +
                  '</tr>' +
                '</thead>' +
                '<tbody>';
      
      $.each(data, function(idx, elem){
        if(elem.agent_requests.length > 0){
          var date_created = '';
          if(elem.date_created != null){
            date_created = formatDate(elem.date_created);
          }
          string += '<tr class="text-bold">' +
                      '<td class="text-left">Contact: ' + elem.cfname + ' ' + elem.clname + '</td>' +
                      '<td></td>' +
                      '<td></td>' +
                      '<td></td>' +
                      '<td class="text-right">' + date_created + '</td>' +
                      '<td></td>' +                      
                    '</tr>';
        }

        $.each(elem.agent_requests, function(idx, elem2){
          var date_assigned, date_requested;
          if((elem2.accepted == 1) && (elem2.date_assigned != null)){
            date_assigned = formatDate(elem2.date_assigned);
          }else{
            date_assigned = '';
          }
          if(elem2.date_requested != null){
            date_requested = formatDate(elem2.date_requested);
          }else{
            date_requested = '';
          }
          string += '<tr >' +
                      '<td></td>' +
                      '<td class="text-left">' + elem2.first_name + ' ' + elem2.last_name + '</td>' +
                      '<td class="text-center">' + elem2.company_name + '</td>' +
                      '<td class="text-center">' + elem2.phone_mobile + '</td>' +
                      '<td class="text-center">' + date_requested + '</td>'+ 
                      '<td class="text-right">' + date_assigned + '</td>' +
                    '</tr>';
        });
      });

      string += '</tbody></table></div>'
    }else {
      string +=  '<div class="dtimeline-notify p-4 no-data bg-blue">' +
              '<h3 class="m-t-3 m-b-3 text-center">No Agent Requests</h3>' +
            '</div>';
    }
    $('#agent-requests-div').html(string);
  }


  function updateAgentsDriving(data){
    var string = '';
    $('#agents-driving-div').html('');
    if(data.length > 0) {
      string += '<div class="table-responsive">' +
              '<table class="table">' +
                '<thead>' +
                  '<tr>' +
                    '<th>Name</th>' +
                    '<th class="text-center">Company</th>' +
                    '<th class="text-center">Latitude</th>' +
                    '<th class="text-right">Longitude</th>' +
                    '<th class="text-right">Last Check-in</th>' +
                  '</tr>' +
                '</thead>' +
                '<tbody>';
      $.each(data, function(index, elem){
        
        var last_drive = '';
        if(elem.last_drive != null){
          last_drive = formatDate(elem.last_drive);
        }

        string += '<tr>' + 
                    '<td class="text-left">' + elem.first_name + ' ' + elem.last_name +'</td>' +
                    '<td class="text-center">' + elem.company_name + '</td>' +
                    '<td class="text-center">' + elem.last_latitude + '</td>' +
                    '<td class="text-right">' + elem.last_longitude + '</td>' +
                    '<td class="text-right">' + last_drive + '</td>' +
                  '</tr>';
      });
      string += '</tbody></table></div>';
      
    }else {
      string += '<div class="dtimeline-notify p-4 no-data bg-blue">' +
              '<h3 class="m-t-3 m-b-3 text-center">No Driving Agents</h3>' +
            '</div>'; 
    }
    $('#agents-driving-div').html(string);
  }

  function formatDate(d){
    var date = new Date(Date.parse(d.replace('-', '/', 'g')));
    var formattedDate; 
    if(d == '0000-00-00 00:00:00'){
      formattedDate = '0000-00-00 00:00:00';
    }else{
      var monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
      var day = date.getDate();
      var monthIdx = date.getMonth();
      var year = date.getFullYear();
      var hours = date.getHours();
      var mins = date.getMinutes();
      var indicator = 'AM';
      if(hours > 12){
        hours = hours-12;
        indicator = 'PM';
      }else if(hours == 0){
        hours = 12;
      }
      if(mins == 0){
        mins = "00";
      }  
      formattedDate = monthNames[monthIdx] + ' ' + day + ', ' + year + ' ' + hours + ':' + mins + ' ' + indicator;
      
    }

    return formattedDate;

  }
</script>