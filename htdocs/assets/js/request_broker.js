// REQUEST A BROKER SCRIPT
var checkForAgentResponse;

function requestBroker() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(getClientPosition);
    } else {
        console.log("Geolocation is not supported by this browser.");
    }
}

function getClientPosition(position) {

    var lat = position.coords.latitude;
    var lon = position.coords.longitude;

	console.log("Latitude: " + lat);
	console.log("Longitude: " + lon);

	$.ajax({
	    type: "POST",
	    url: '/ws/request_agent/request_a_broker',
	    data: { 
	        'first_name': $("#first-name").val(), 
	        'last_name': $("#last-name").val(), 
	        'email_address': $("#email-address").val(), 
	        'latitude': lat, 
	        'longitude': lon, 
	        'phone': $("#phone").val(), 
	        'mls_number': $("#mls_number").val() 
	    },
	    dataType: "json",
	    success: function(result) {

	    	console.log(result);

	        agentRequested = true;
	        clearInterval(checkForAgentResponse);

	        $("#page-loader").addClass('hide');

	        if (result.error)
	            console.log(result.message);
	        else {
	            if (result.count !== 0) {
	                // $("#message").html(result.count + " agents found near you. You'll be sent a text message as soon as someone accepts the request.");
	                $("#message").html("Your request has been sent. You will be notified here when a member broker has been matched.");
	                $("#message").addClass("alert alert-info");
	                $("#message").css("margin-bottom", "0px");

	                $("#request-agent-form").addClass('hide');
	                
	                checkForAgentResponse = setInterval(function() {

	                    console.log("check for response");
	                    $.ajax({
	                        type: "POST",
	                        url: '/ws/request_agent/check_response_agent',
	                        data: { 
	                            'contact_id': result.id, 
	                            'phone': $("#phone").val()
	                        },
	                        dataType: "json",
	                        success: function(response) {
	                            console.log(response);
	                
	                            if (response.accepted) {

	                                clearInterval(checkForAgentResponse);

	                                $("#agent-details").removeClass('hide');
	                                $("#agent-details").addClass('in');
	                                $("#request-area").addClass('fade hide');
	                                $("#agent-name").html(response.agent.first_name+" "+response.agent.last_name);
	                                $("#agent-phone").html("<a href='tel:"+response.agent.phone_mobile+"'>"+response.agent.phone_mobile+"</a>");
	                                $("#agent-email").html(response.agent.email);
	                                $("#agent-company").html(response.agent.company_name);

	                                $("#message").html("<strong>Success!</strong> A Member Broker has accepted your request. <br>See your matched broker details below.");
	                                $("#message").removeClass("alert-info");
	                                $("#message").addClass("alert-success");
	                                $("#message").css("margin-bottom", "20px");
	                                $('#message').removeClass('hide');
	                                $('#btn-req-box').removeClass('hide');
	                                $('#request-new-broker').removeClass('hide');

	                                if (response.agent.is_profile_photo == 1) {
	                                    $(".avatar").html('<img id="agent-picture" style="max-width: 250px;" alt="Broker Profile Picture" src="https://s3-us-west-2.amazonaws.com/zugent/profilephotos/'+response.agent.user_id+'/original.jpg"/>');
	                                }
	                                else {
	                                    $(".avatar").html('<img id="agent-picture" style="max-width: 250px;" alt="Broker Profile Picture" src="/assets/img/user-0.jpg"/>');
	                                }

	                            }
	                        },
	                        error: function (XMLHttpRequest, textStatus, errorThrown) {
	                            console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
	                        }
	                    });
	                }, 5000);
	            }
	            else {
	                $("#message").html("Sorry but there are no available brokers near you.");
	                $("#message").addClass("alert alert-warning");
	                $('#message').removeClass('hide');
	            }
	        }

	    },
	    error: function (XMLHttpRequest, textStatus, errorThrown) {
	        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
	    }
	});
}


$(document).ready(function() {

	App.init();

	$(document).find('.phone-us').mask('(000) 000-0000');

	$("#request-new-broker").on("click", function() {
		if($("#request-agent-form").hasClass("hide")) {
            $("#request-agent-form").removeClass('hide');
            $("#btn-req-box").addClass('hide');
            $("#request-new-broker").addClass('hide');
            $("#message").addClass('hide');
		}
		else {
            $("#btn-req-box").removeClass('hide');
            $("#request-new-broker").removeClass('hide');
            $("#request-agent-form").addClass('hide');
		}
	});

    $("#frm-request").on('submit',function(e) {
        e.preventDefault();
        if ( $(this).parsley().isValid() ) {

            $("#page-loader").removeClass('hide');

            if (navigator.geolocation) {
                requestBroker();
            }
        }
    });

});
