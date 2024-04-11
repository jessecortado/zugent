<script src="/assets/plugins/select2/dist/js/select2.full.min.js"></script>
<script src="/assets/plugins/bootstrap-daterangepicker/moment.js"></script>
<script src="/assets/plugins/bootstrap-eonasdan-datetimepicker/build/js/bootstrap-datetimepicker.min.js"></script>
<script src="assets/js/bootstrap-confirmation.min.js"></script>
<script src="assets/plugins/dropzone/dropzone.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAq8WuTeXonjSzYw_vVLiN7PCRQNqf_v_Q"></script>

<script type="text/javascript">

	/********* Functions *********/
	function expose_more(more_id) {
		var more_link = '#more_link_' + more_id;
		var more_span = '#more_desc_' + more_id;
		$(more_link).hide();
		$(more_span).show();
		return false;
	}

    function flash_alert(element, msg) {
        $('#alert_error').addClass('hide');
        $(element+' span#msg').text(msg);
        $(element).removeClass('hide');
        $(element).css('opacity', '1');
        $(element).css('display', 'block');
        window.setTimeout(function() {
          $(element).fadeTo(500, 0).slideUp(500, function(){
              // $(this).remove();
              $(element).addClass('hide');
          });
        }, 2000);
    }

	function nullCheck(data_value){
		if(data_value == null){
			return '';
		}else{
			return data_value;
		}
	}

	function refresh_counter(element_id, in_between_msg, pre_msg, post_msg) {
		var has_msg = in_between_msg || false;
		var pre_text = pre_msg || '';
		var post_text = post_msg || '';
		var old_value = $(element_id).text().replace(/[^0-9\.]/g, '') || '0';

		if(has_msg) {
			$(element_id).text(pre_text +' '+ (parseInt(old_value, 10) + 1) +' '+ post_text);
		}
		else {
			$(element_id).text(parseInt(old_value) + 1);
		}
	}

    function day_ordinal(day) {
		if(day>3 && day<21) return 'th';
		switch (day % 10) {
			case 1:  return "st";
			case 2:  return "nd";
			case 3:  return "rd";
			default: return "th";
		}
    }

	function datetime_format(datetime) {
		var js_datetime = new Date(datetime),
	        date = js_datetime.getDate(),
	        month = "Jan,Feb,Mar,Apl,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec".split(",")[js_datetime.getMonth()];

	    return month +" "+ date + day_ordinal(date) +", "+ js_datetime.getFullYear();
	}

	function time_format(datetime) {
		var time = new Date(datetime);
		time = time.toLocaleTimeString('en-US', { hour: 'numeric', minute: 'numeric', hour12: true });
	    return time;
	}

	function am_pm_to_hours(date_with_ampm) {
		var date_ampm = date_with_ampm.split(" ");
		var date = date_ampm[0].split("/");
		var time = date_ampm[1].split(":");
        var hours = Number(time[0]);
        var minutes = Number(time[1]);
        var AMPM = date_ampm[2];

        if (AMPM == "PM" && hours < 12) hours = hours + 12;
        if (AMPM == "AM" && hours == 12) hours = hours - 12;

        var sHours = hours.toString();
        var sMinutes = minutes.toString();
        if (hours < 10) sHours = "0" + sHours;
        if (minutes < 10) sMinutes = "0" + sMinutes;

        console.log(date_with_ampm);
        console.log((date[2]+"-"+date[0]+"-"+date[1]+" "+sHours+':'+sMinutes+':00'));

        return (date[2]+"-"+date[0]+"-"+date[1]+" "+sHours+':'+sMinutes+':00');
    }

	function datepickerFormat(datetime) {
		var date = new Date(datetime),
			year = date.getFullYear(),
			month = ((date.getMonth() + 1)<10?'0'+(date.getMonth() + 1):(date.getMonth() + 1)),
			day = (date.getDate()<10?'0':'') + date.getDate(),
			hours = (date.getHours()<10?'0':'') + date.getHours(),
			minutes = (date.getMinutes()<10?'0':'') + date.getMinutes(),
			seconds = (date.getSeconds()<10?'0':'') + date.getSeconds();

    	return month + "/" + day + "/" + year + " " + hours + ":" + minutes + ":" + seconds;
	}

	function scrolltoBottom() {
		window.scrollTo(0,document.body.scrollHeight);
	}

	function removeNoDataRow(element) {
		$(element).each(function() {
			if ($(element).hasClass('no-data')) {
				$(element).remove();
			}
		});
	}

	function addNoDataAvailable(element, num_span, msg) {
		if ($(element+" tr").length == 0) {
			$(element).append('<tr class="no-data"><td class="text-center" colspan="'+num_span+'">'+msg+'</td></tr>');
		}
	}

	function getURLparams(sParam) {
		var sPageURL = window.location.search.substring(1);
		var sURLvars = sPageURL.split('&');
		for(var i=0; i < sURLvars.length; i++) {
			var sParamName = sURLvars[i].split('=');
			if(sParamName[0] == sParam) {
				return decodeURIComponent(sParamName[1]);
			}
		}
	}

	function savePosition(position) {
      var lat = position.coords.latitude;
      var lon = position.coords.longitude;
	  $.ajax({
		  type: "POST",
		  url: '/ws/user/set_location',
		  data: { 'lat': lat, 'lon': lon },
		  dataType: "json",
		  success: function(result) {
			  console.log(result);
			  // location.reload();
		  },
		  error: function (XMLHttpRequest, textStatus, errorThrown) {
			  console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
		  }
	  });
	}

	function getLocation() {
	  if (navigator.geolocation) {
		  navigator.geolocation.getCurrentPosition(savePosition);
	  } else {
		  x.innerHTML = "Geolocation is not supported by this browser.";
	  }
	}

	/********* End-Functions *********/

	$(document).ready(function() {

		if (getURLparams('accept') == '1') {
			// console.log("Accept is set");
			getLocation();
		}

        $("#form-set-time-to-action [name='months'], #form-set-time-to-action [name='weeks'], #form-set-time-to-action [name='days']").keypress( function(event) {
            if(event.which != 8 && isNaN(String.fromCharCode(event.which))) {
                event.preventDefault(); //stop character from entering input
            }
        });

		/************************************************ Variables ************************************************/
		var current;
		var contact_user_id;
		var appointment_id;
		var contact_file_id;
		var shownRemovedReferrals = 0;
		var shownCompletedAppointments = 0;
		var shownCancelledAppointments = 0;
		var shownDeletedFiles = 0;
		var user_id;
		var user_name;
		/************************************************ End-Variables ************************************************/


		/************************************************ Plugin Intialization ************************************************/
		$("#state").val('{$contact_data.state}');
		$("select").select2({ placeholder:'Please select one', width:'100%'});
		$('#appointment-date').datetimepicker();
		$("#offices").select2({
			placeholder: "Select an office",
			width: "100%",
			'max-width': "100%"
		});
    	$("[rel='tooltip']").tooltip();

		cancel_appointment();
		delete_contact_file();
		restore_contact_file();
		remove_assignment();
		/************************************************ End-Plugin Intialization ************************************************/


		/************************************************ Transaction Section ************************************************/
		$("#btn-add-transaction").click(function() {
			$("#form-add-transaction").submit();
		});

		$('#modal-add-transaction').on('hide.bs.modal', function (){
			$('#form-add-transaction').parsley().reset();
		});

		$("#form-add-transaction").on("submit", function(e){
			e.preventDefault();
			if ( $(this).parsley().isValid() ) {
				var target = $('#form-add-transaction').closest('.panel');

				$.ajax({
					type: "POST",
					url: '/ws/transaction/add_contact_transaction',
					data: $(this).serialize(),
					dataType: "json",
					success: function(result) {
						console.log(result);

						if (result.msg) {
							removeNoDataRow("table#transactionTbl tbody tr");
							var row_html = '';
							row_html += '<tr>';
							row_html += '<td>'+result.data[0]['transaction_id']+'</td>';
							if (result.data[0]['is_on_mls'] == 1) {
								row_html += '<td class="text-center">'+result.data[0]['listing_number']+'</td>';
							}
							else {
								row_html += '<td class="text-center"></td>';
							}
							row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_created'])+'</td>';
							row_html += '<td class="text-center">'+result.data[0]['transaction_type']+'</td>';
							row_html += '<td class="text-center">'+result.data[0]['transaction_status']+'</td>';
							row_html += '<td class="text-center">';
							row_html += '<a href="transaction/'+result.data[0]['transaction_id']+'" class="btn btn-info btn-xs m-r-5 m-b-5 btn-delete" data-transaction-id="'+result.data[0]['transaction_id']+'"><i class="glyphicon glyphicon-eye-open"></i>View</a>';
							row_html += '</td>';
							row_html += '</tr>';

					        $('#transactionTbl tbody').append(row_html);

					        refresh_counter("#transaction-count");
                        	flash_alert('#alert_success_transaction', 'Added a transaction.');
						}
						else {
							window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					},
				    complete: function() {
				    	$("#modal-add-transaction").modal('hide');
				    }
				});
			}
		});
		/************************************************ End-Transaction Section ************************************************/


		/************************************************ Assignments Section ************************************************/
		$(document).on("click", "#modal-add-user #modal-save", function() {
			$("#form-add-user").submit();
		});

		$('#modal-add-user').on('hide.bs.modal', function (){
			$('#form-add-user').parsley().reset();
		});

		$("#form-add-user").on("submit", function(e){
			e.preventDefault();
			if ( $(this).parsley().isValid() ) {
				var target = $('#form-add-user').closest('.panel');

				$.ajax({
					type: "POST",
					url: '/ws/contact/add_user_to_contact',
					data: $(this).serialize(),
					dataType: "json",
				    beforeSend: function() {
				        if (!$(target).hasClass('panel-loading')) {
				            var targetBody = $(target).find('.panel-body');
				            var spinnerHtml = '<div class="panel-loader"><span class="spinner-small"></span></div>';
				            $(target).addClass('panel-loading');
				            $(targetBody).prepend(spinnerHtml);
				        }
				    },
					success: function(result) {
						console.log(result);

						if (result.msg) {
							var row = $("table#contactFilesTbl tbody").find('tr#cf-'+result.data[0]['contact_user_id']);
							var row_html = '';
							row_html += '<tr id="cf-'+result.data[0]['contact_user_id']+'">';
							row_html += '<td>'+result.data[0]['first_name']+' '+result.data[0]['last_name']+'</td>';
							row_html += '<td class="text-center">';
							row_html += '<a href="javascript:void(0)" class="btn btn-xs btn-info m-r-5 set-primary" data-user-id="'+result.data[0]['user_id']+'" data-is-primary="'+result.data[0]['is_primary']+'"><i class="glyphicon glyphicon-check"></i> Set Primary</a>';
							row_html += ' ';
							row_html += '<a href="javascript:void(0)" data-toggle="confirmation" class="btn btn-xs btn-danger m-r-5 btn-remove-assignment" data-contact-user-id="'+result.data[0]['contact_user_id']+'"><i class="glyphicon glyphicon-remove"></i>Remove</a>';
							row_html += '</td>';
							row_html += '</tr>';

					        $('#assignmentsTbl tbody').append(row_html);
			                $(target).removeClass('panel-loading');
			                $(target).find('.panel-loader').remove();

                        	flash_alert('#alert_success_assignment', 'Assigned a user.');
							$("#select-users").find(":selected").remove();
							remove_assignment();
						}
						else {
							window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					},
				    complete: function() {
				    	$("#modal-add-user").modal('hide');
				    }
				});
			}
		});

		$(document).on("click", ".set-primary", function() {
			current = this;

			var id = $(this).data("user-id");
			var is_primary = ($(this).data("is-primary") == '1') ? '0' : '1';

			$.ajax({
				type: "POST",
				url: '/ws/contact/set_primary',
				data: {
					'user_id': id,
					'set_primary': is_primary,
					'contact_id': {$contact_data.contact_id}
				},
				dataType: "json",
				success: function(result) {
					console.log(result);
					if(result) {
						if(window.location.href.indexOf("#panel-assignments") > -1) {
							window.location.reload();
					    }
					    else {
							window.location = "contacts_edit.php?id={$contact_data.contact_id}#panel-assignments";
							window.location.reload();
						}
					}
					else {
						window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				}
			});
		});

		$(document).on("click", ".btn-remove-assignment", function() {
			contact_user_id = $(this).data("contact-user-id");
			user_id = $(this).data('user-id');
			user_name = $(this).data('user-name');
			current = this;
		});

		function remove_assignment() {
			$('.btn-remove-assignment').confirmation({
				title: "Are you sure you want to delete this user?",
				placement: "left",
				btnOkLabel: "Yes",
				btnOkIcon: "fa fa-check",
				btnOkClass: "btn btn-sm btn-success m-r-3",
				btnCancelLabel: "No",
				btnCancelClass: "btn btn-sm btn-danger",
				onConfirm: function(event, element) {

				    $.ajax({
						type: "POST",
				        url: '/ws/contact/remove_user_from_contact',
				        data: { 'contact_user_id': contact_user_id, 'contact_id': {$contact_data.contact_id} },
						dataType: "json",
						success: function(result) {
							console.log(result);
							if (result) {
								var first = $(current).closest('tr');
								$(first).remove();

								var select = $('#select-users');
								var option = $('<option></option>').
								     attr('selected', false).
								     text(user_name).
								     val(user_id);

                        		flash_alert('#alert_success_assignment', 'Unassigned a user.');
								/* insert the option (which is already 'selected'!) into the select */
								option.appendTo(select);
								/* Let select2 do whatever it likes with this */
								select.trigger('change');
							}
							else {
								window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
							}
						},
						error: function (XMLHttpRequest, textStatus, errorThrown) {
							console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
						}
					});
				},
				onCancel: function() { }
			});
		}
		/************************************************ End-Assignments Section ************************************************/


		/************************************************ Contact Offices Section ************************************************/
		$("#btn-add-office").on("click", function() {
			$("#form-add-offices").submit();
		});

		$("#modal-add-office").on("hide.bs.modal", function() {
			$("#form-add-offices").parsley().reset();
		});

		$("#form-add-offices").on("submit", function(e){
			e.preventDefault();
			if ( $(this).parsley().isValid() ) {
				$.ajax({
					type: "POST",
					url: '/ws/contact/office/add',
					data: { 'office_id': $("#offices").val(), 'contact_id': '{$contact_data.contact_id}', 'user_id': '{$user.user_id}' },
					dataType: "json",
					success: function(result) {
						var temp = JSON.parse(JSON.stringify(result));

						if(temp.result) {
							$("#tr-no-records").remove();
							$("#officesTbl tbody").append("<tr><td>"+$("#offices").val()+"</td><td width='60%'>"+$("#offices option:selected").text()+"</td><td class='text-center'>"+'<a href="javascript:;" class="btn btn-xs btn-danger m-r-5 m-b-5 btn-unassign-office" data-toggle="confirmation" data-contact-rel-office-id="'+temp.id+'" data-office-id="'+$("#offices").val()+'" data-office-name="'+$("#offices option:selected").text()+'"><i class="glyphicon glyphicon-remove"></i>Unassign</a>'+"</td></tr>");
							$("#offices").find(":selected").remove();
                        	flash_alert('#alert_success_office', 'Assigned an office.');
                        	$('#modal-add-office').modal('hide');
						}

					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					}
				});
			}
		});

		$(document).on("click", ".btn-unassign-office",function() {
			var current = this;
			var id = $(this).data("contact-rel-office-id");

			$.ajax({
				type: "POST",
				url: '/ws/contact/office/remove',
				data: { 'contact_rel_office_id': id, 'contact_id': '{$contact_data.contact_id}', 'user_id': '{$user.user_id}' },
				dataType: "json",
				success: function(result) {
					var temp = JSON.parse(JSON.stringify(result));

					if(temp.result) {
						$("select#offices").append('<option value="'+$(current).data("office-id")+'">'+$(current).data("office-name")+'</option>');
						console.log()
						$(current).closest("tr").remove();
						addNoDataAvailable("#officesTbl tbody", "3", "Not assigned to any office");
                        flash_alert('#alert_success_office', 'Unassigned an office.');
                	}
	            },
	            error: function (XMLHttpRequest, textStatus, errorThrown) {
	            	console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
	            }
	        });
		});
		/************************************************ End-Contact Offices Section ************************************************/


		/************************************************ Contact Details Section ************************************************/
		// $("#bucket").on("change", function(){
		// 	var bucket_id = $(this).find(":selected").val();
		// 	console.log(bucket_id);
		// 	$.ajax({
		// 		type: "POST",
		// 		url: '/services/dropdown_changed.php',
		// 		data: { 'bucket_id': bucket_id},
		// 		dataType: "json",
		// 		success: function(result) {
		// 			console.log(result);
		// 			$("#status").html("");
		// 			$("#status").append('<option value="">Select Status</option>');
		// 			$("#sub-status").html("");
		// 			$("#sub-status").prop("disabled", true);
		// 			var temp = JSON.parse(JSON.stringify(result));
		// 			$.each(temp.data, function(index, val) {
		// 				console.log(index + " " + val.status);
		// 				$("#status").append('<option value=' + val.status_id + '>' + val.status + '</option>');
		// 			});
		// 		},
		// 		error: function (XMLHttpRequest, textStatus, errorThrown) {
		// 			console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus);
		// 		}
		// 	});
		// });

		// $("#status").on("change", function(){
		// 	var status_id = $(this).find(":selected").val();
		// 	console.log(status_id);
		// 	$.ajax({
		// 		type: "POST",
		// 		url: '/services/dropdown_changed.php',
		// 		data: { 'status_id': status_id },
		// 		dataType: "json",
		// 		success: function(result) {
		// 			console.log(result);
		// 			$("#sub-status").html("");
		// 			$("#sub-status").prop("disabled", false);
		// 			$("#sub-status").append('<option value="">Select Sub Status</option>');
		// 			var temp = JSON.parse(JSON.stringify(result));
		// 			$.each(temp.data, function(index, val) {
		// 				console.log(index + " " + val.sub_status);
		// 				$("#sub-status").append('<option value=' + val.sub_status_id + '>' + val.sub_status + '</option>');
		// 			});
		// 		},
		// 		error: function (XMLHttpRequest, textStatus, errorThrown) {
		// 			console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus);
		// 		}
		// 	});
		// });

		// $("#sub_status").on("change", function(){
		// 	var bucket_id = $(this).find(":selected").val();
		// 	console.log(status_id);
		// });
		/************************************************ End-Contact Details ************************************************/


		/************************************************ Referrals Section ************************************************/
		{if $user.is_admin eq '1' or $user.is_superadmin eq '1'}
		$(document).on("click", '.deactivate-referral',function(){
			var referral_id = $(this).data("referral-id");
			var first = $(this).closest('tr');
			$.ajax({
				type: "POST",
				url: '/ws/contact/set_referral_active',
				data: { 'referral_id': referral_id, 'user_id': {$user.user_id}, 'is_active': '0' },
				dataType: "json",
				success: function(result) {
					console.log(result);
					if(result.msg) {
						var row_html = '';
						$(first).remove();
						removeNoDataRow("table#commentsTbl tbody tr");

						row_html += '<tr id="rf-'+result.data[0]['contact_referral_id']+'">';
						row_html += '<td>'+result.data[0]['contact_referral_id']+'</td>';
						row_html += '<td class="text-center">'+result.data[0]['referred_by']+'</td>';
						row_html += '<td class="text-center">'+result.data[0]['referred_to']+'</td>';
						row_html += '<td class="text-center">'+result.data[0]['referral_source']+'</td>';
						row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_referral'])+'</td>';
    					row_html += '<td class="text-center" nowrap>';
    					row_html += '<a href="javascript:void(0)" class="btn btn-xs btn-primary m-r-5 m-b-5 activate-referral" data-referral-id="'+result.data[0]['contact_referral_id']+'"><i class="glyphicon glyphicon-ok"></i>Activate Referral</a>';
    					row_html += '</td>';
    					row_html += '</tr>';
    					$("#removedReferralsTbl tbody").append(row_html);

						$('#commentsTbl tr:first').after("<tr><td style='width:200px;'><b>{$user.first_name} {$user.last_name}</b><br/><small>Just Now</small></td><td>" + result.comment + "</td></tr>");

						if($("#cancelledAppointmentsTbl tbody tr").length > 0) {
							if ($("#removed-referral-panel").is( ":visible" ) && $("#removed-referral-panel .panel-body").is( ":hidden" )) {
								$("#toggle-removed-referrals").click();
							}
							else if (!$("#removed-referral-panel").is( ":visible" )) {
								$("#removed-referral-panel").css('display', 'block');
								$("#toggle-removed-referrals").click();
							}
						}
						else {
							$("#removed-referral-panel").css('display', 'none');
							$("#toggle-removed-referrals").click();
						}

						refresh_counter('#comments_count');
						addNoDataAvailable("table#referralsTbl tbody", '6', 'No Referrals Available');
                        flash_alert('#alert_success_referral', 'Deactivated a referral.');
					}
					else {
						window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				}
			});
		});

		$(document).on("click", '.activate-referral',function(){
			var referral_id = $(this).data("referral-id");
			var first = $(this).closest('tr');
			$.ajax({
				type: "POST",
				url: '/ws/contact/set_referral_active',
				data: { 'referral_id': referral_id, 'user_id': {$user.user_id}, 'is_active': '1' },
				dataType: "json",
				success: function(result) {
					console.log(result);
					if(result.msg) {
						var row_html = '';
						$(first).remove();
						removeNoDataRow("table#commentsTbl tbody tr");
						removeNoDataRow("table#referralsTbl tbody tr");

						row_html += '<tr id="rf-'+result.data[0]['contact_referral_id']+'">';
						row_html += '<td>'+result.data[0]['contact_referral_id']+'</td>';
						row_html += '<td class="text-center">'+result.data[0]['referred_by']+'</td>';
						row_html += '<td class="text-center">'+result.data[0]['referred_to']+'</td>';
						row_html += '<td class="text-center">'+result.data[0]['referral_source']+'</td>';
						row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_referral'])+'</td>';
    					row_html += '<td class="text-center" nowrap>';
    					row_html += '<a href="#modal-edit-referral" class="btn btn-xs btn-info m-r-5 m-b-5 btn-edit-referral" data-referral-id="'+result.data[0]['contact_referral_id']+'" data-user-id="'+result.data[0]['user_id']+'" data-source="'+result.data[0]['referral_source']+'" data-bob="" data-toggle="modal"><i class="glyphicon glyphicon-edit"></i>Edit</a>';
    					row_html += ' ';
    					row_html += '<a href="javascript:void(0)" class="btn btn-xs btn-danger m-r-5 m-b-5 deactivate-referral" data-referral-id="'+result.data[0]['contact_referral_id']+'"><i class="glyphicon glyphicon-remove"></i>Remove Referral</a>';
    					row_html += '</td>';
    					row_html += '</tr>';
    					$("#referralsTbl tbody").append(row_html);

						$('#commentsTbl tr:first').after("<tr><td style='width:200px;'><b>{$user.first_name} {$user.last_name}</b><br/><small>Just Now</small></td><td>" + result.comment + "</td></tr>");

						if($("#removed-referral-panel tbody tr").length > 0) {
							if ($("#removed-referral-panel").is( ":visible" ) && $("#removed-referral-panel .panel-body").is( ":hidden" )) {
								$("#toggle-removed-referrals").click();
							}
							else if (!$("#removed-referral-panel").is( ":visible" )) {
								$("#removed-referral-panel").css('display', 'block');
								$("#toggle-removed-referrals").click();
							}
						}
						else {
							$("#removed-referral-panel").css('display', 'none');
							$("#toggle-removed-referrals").click();
						}

						refresh_counter('#comments_count');
                        flash_alert('#alert_success_referral', 'Activated a referral.');
					}
					else {
						window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				}
			});
		});

		$(document).on("click", '.btn-edit-referral',function(){
			$("#form-edit-referral #referral_edit_source").val($(this).data("source"));
			$("#form-edit-referral #referral-id").val($(this).data("referral-id"));
			$("#form-edit-referral #select-edit-referral-users").val($(this).data("user-id"));
			$("#form-edit-referral #select-edit-referral-users").select2({ width:'100%', placeholder:'Please select one' });
		});

		$(document).on("click", '#btn-save-referral',function(){
			$("#form-edit-referral").submit();
		});

		$(document).on("click", '#modal-add-referral .btn-success',function(){
			$("#form-add-referral").submit();
		});

		$("#form-add-referral").on("submit", function(e){
			e.preventDefault();
			if ( $(this).parsley().isValid() ) {
				$.ajax({
					type: "POST",
					url: '/ws/contact/add_referral_to_contact',
					data: $(this).serialize(),
					dataType: "json",
					success: function(result) {
						console.log(result);

						if (result.msg) {
							removeNoDataRow("table#referralsTbl tbody tr");
							var row_html = '';
							row_html += '<tr id="rf-'+result.data[0]['contact_referral_id']+'">';
							row_html += '<td>'+result.data[0]['contact_referral_id']+'</td>';
							row_html += '<td class="text-center">'+result.data[0]['referred_by']+'</td>';
							row_html += '<td class="text-center">'+result.data[0]['referred_to']+'</td>';
							row_html += '<td class="text-center">'+result.data[0]['referral_source']+'</td>';
							row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_referral'])+'</td>';
	    					row_html += '<td class="text-center" nowrap>';
	    					row_html += '<a href="#modal-edit-referral" class="btn btn-xs btn-info m-r-5 m-b-5 btn-edit-referral" data-referral-id="'+result.data[0]['contact_referral_id']+'" data-user-id="'+result.data[0]['user_id']+'" data-source="'+result.data[0]['referral_source']+'" data-bob="" data-toggle="modal"><i class="glyphicon glyphicon-edit"></i>Edit</a>';
	    					row_html += ' ';
	    					row_html += '<a href="javascript:void(0)" class="btn btn-xs btn-danger m-r-5 m-b-5 deactivate-referral" data-referral-id="'+result.data[0]['contact_referral_id']+'"><i class="glyphicon glyphicon-remove"></i>Remove Referral</a>';
	    					row_html += '</td>';
	    					row_html += '</tr>';
	    					$("#referralsTbl tbody").append(row_html);

							refresh_counter('#referrals_count');
			    			scrolltoBottom();
                        	flash_alert('#alert_success_referral', 'Added a referral.');
						}
						else {
							window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					},
				    complete: function() {
				    	$("#modal-add-referral").modal('hide');
				    }
				});
			}
		});

		$("#form-edit-referral").on("submit", function(e){
			e.preventDefault();
			if ( $(this).parsley().isValid() ) {
				$.ajax({
					type: "POST",
					url: '/ws/contact/edit_referral_from_contact',
					data: $(this).serialize(),
					dataType: "json",
					success: function(result) {
						console.log(result);

						if (result.msg) {
							var row = $("table#referralsTbl tbody").find('tr#rf-'+result.data[0]['contact_referral_id']);
							var row_html = '';
							row_html += '<tr id="rf-'+result.data[0]['contact_referral_id']+'">';
							row_html += '<td>'+result.data[0]['contact_referral_id']+'</td>';
							row_html += '<td class="text-center">'+result.data[0]['referred_by']+'</td>';
							row_html += '<td class="text-center">'+result.data[0]['referred_to']+'</td>';
							row_html += '<td class="text-center">'+result.data[0]['referral_source']+'</td>';
							row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_referral'])+'</td>';
	    					row_html += '<td class="text-center" nowrap>';
	    					row_html += '<a href="#modal-edit-referral" class="btn btn-xs btn-info m-r-5 m-b-5 btn-edit-referral" data-referral-id="'+result.data[0]['contact_referral_id']+'" data-user-id="'+result.data[0]['user_id']+'" data-source="'+result.data[0]['referral_source']+'" data-bob="" data-toggle="modal"><i class="glyphicon glyphicon-edit"></i>Edit</a>';
	    					row_html += ' ';
	    					row_html += '<a href="javascript:void(0)" class="btn btn-xs btn-danger m-r-5 m-b-5 deactivate-referral" data-referral-id="'+result.data[0]['contact_referral_id']+'"><i class="glyphicon glyphicon-remove"></i>Remove Referral</a>';
	    					row_html += '</td>';
	    					row_html += '</tr>';
					        row.replaceWith(row_html);

							$('#commentsTbl tr:first').after("<tr><td style='width:200px;'><b>{$user.first_name} {$user.last_name}</b><br/><small>Just Now</small></td><td>" + result.comment + "</td></tr>");

							refresh_counter('#comments_count');
                        	flash_alert('#alert_success_referral', 'Updated a referral.');
						}
						else {
							window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					},
				    complete: function() {
				    	$("#modal-edit-referral").modal('hide');
				    }
				});
			}
		});

		$('#modal-add-referral').on('hide.bs.modal', function (){
	    	$('#select-referral-users').val('');
	    	$('#referral_add_source').val('');
	    	$('#form-add-referral').parsley().reset();
		});

		$('#modal-edit-referral').on('hide.bs.modal', function (){
	    	$('#select-edit-referral-users').val('');
	    	$('#referral_edit_source').val('');
	    	$('#form-edit-referral').parsley().reset();
		});

		$(document).on("click", '#toggle-removed-referrals',function(){
			if(shownRemovedReferrals == 0) {
				$(this).html('<i class="fa fa-minus"></i> Hide Deactivated Referrals');
				shownRemovedReferrals++;
			}
			else {
				$(this).html('<i class="fa fa-expand"></i> Show '+{$contact_referrals_notactive|count}+' Deactivated Referrals');
				shownRemovedReferrals--;
			}
		});

		{/if}
		/************************************************ End-Referrals ************************************************/


		/************************************************ Appointments Section ************************************************/
		$(document).on("click", '.show-completion-notes',function(){
			current = this;
			$("#modal-complete-appointment #contact-appointment-id").val($(this).data("appointment-id"));
			$("#modal-complete-appointment").modal("show");
		});

		$(document).on("click", '#complete-appointment',function(){
			$("#form-complete-appointment").submit();
		});

		$('#modal-complete-appointment').on('hide.bs.modal', function (){
			$("#form-complete-appointment").parsley().reset();
		});

		$("#form-complete-appointment").on("submit", function(e){
			e.preventDefault();
			if ($(this).parsley().isValid()) {
				$.ajax({
					type: "POST",
					url: '/ws/contact/appointment/complete',
					data: {
						'contact_appointment_id': $("#modal-complete-appointment #contact-appointment-id").val(),
						'contact_id': $("#modal-complete-appointment #contact-id").val(),
						'completion_notes': $("#modal-complete-appointment #completion-notes").val()
					},
					dataType: "json",
					success: function(result) {
						console.log(result);

						if (result.msg) {
							var first = $(current).closest('tr');
							$(first).next("tr").remove();
							$(first).remove();
							removeNoDataRow("table#commentsTbl tbody tr");

							$('#commentsTbl tr:first').after("<tr><td style='width:200px;'><b>{$user.first_name} {$user.last_name}</b><br/><small>Just Now</small></td><td>" + result.comment + "</td></tr>");

							var row_html = '';
							row_html += '<tr id="ca-'+result.data[0]['contact_appointment_id']+'">';
							row_html += '<td>'+result.data[0]['contact_appointment_id']+'</td>';
							row_html += '<td class="text-center">'+result.data[0]['first_name']+' '+result.data[0]['last_name']+'</td>';
							row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_appointment'])+'</td>';
							row_html += '<td class="text-center">'+time_format(result.data[0]['date_appointment'])+'</td>';
							row_html += '<td class="text-center">'+result.data[0]['appointment_type']+'</td>';
							row_html += '<td class="text-center">';
	    					row_html += '<a href="#modal-show-comments" class="btn btn-xs btn-info m-b-5 show-comments" data-appointment-id="'+result.data[0]['contact_appointment_id']+'" data-add-comment="no" data-toggle="modal"><i class="glyphicon glyphicon-edit"></i><span id="appointment_comment_count-'+result.data[0]['contact_appointment_id']+'">Show Comment/s</span></a>';
	    					row_html += '</td>';
	    					row_html += '</tr>';
							row_html += '<tr id="ca-desc-'+result.data[0]['contact_appointment_id']+'">';
	    					row_html += '<td colspan="7">';
	    					row_html += '<p>'+result.data[0]['description']+'</p>';
	    					row_html += '</td>';
	    					row_html += '</tr>';
	    					$("#completeAppointmentsTbl tbody").append(row_html);

							if ($("#complete-appointments-panel").is( ":visible" ) && $("#complete-appointments-panel .panel-body").is( ":hidden" )) {
								$("#toggle-completed-appointments").click();
							}

							addNoDataAvailable("table#appointmentsTbl tbody", '7', 'No Follow-Up / Contacts Available');
                        	flash_alert('#alert_success_appointment', 'Completed an appointement.');
                        	$("#modal-complete-appointment #completion-notes").val('');
                        	$("#modal-complete-appointment").modal('hide');
						}
						else {
							window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					},
				    complete: function() {
				    	scrolltoBottom();
				    }
				});
			}
		});

		$(document).on("click", '#add-appointment-comment',function(){
			$("#form-add-appointment-comment").submit();
		});

		$("#form-add-appointment-comment").on("submit", function(e){
			e.preventDefault();
			if ( $(this).parsley().isValid() ) {
				var cac_id = $("#form-add-appointment-comment [name='contact_appointment_id']").val();
				var contact_id = {$contact_data.contact_id};
				var comment = $("#modal-show-comments #appointment-comment").val();
				$.ajax({
					type: "POST",
					url: '/ws/contact/appointment/comment/add',
					data: {
						'contact_appointment_id': cac_id,
						'contact_id': contact_id,
						'comment': comment
					},
					dataType: "json",
					success: function(result) {
						console.log(result);

						if (result) {
							$('p#no-comments').remove();
							refresh_counter('#appointment_comment_count-'+cac_id, true, 'Show', 'Comment/s');
							var img = 'https://s3-us-west-2.amazonaws.com/zugent/profilephotos/'+{$user.user_id}+'/30x30.jpg';
							var comment_html = '';
							comment_html += '<li class="media media-sm">';
							comment_html += '<a href="javascript:;" class="pull-left">';
							comment_html += '<img src="'+img+'" class="media-object rounded-corner">';
							comment_html += '</a>';
							comment_html += '<div class="media-body">';
							comment_html += '<h5 class="media-heading" style="color: #00acac;font-size: 16px;font-weight: 600;">{$user.first_name} {$user.last_name}</h5>';
							comment_html += '<p>'+comment+'</p>';
	    					comment_html += '</div>';
	    					comment_html += '</li>';
	    					$("#modal-comments-body ul").append(comment_html);

							$('#modal-show-comments #appointment-comment').val("");
							$('#form-add-appointment-comment').parsley().reset();
						}
						else {
							window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					}
				});
			}
		});

		$(document).on("click", '.show-comments',function(){
			$("#modal-comments-body").html("");
			var id = $(this).data("appointment-id");
			var can_add_comment = $(this).data("add-comment");

			if (can_add_comment == 'no') {
				$("#modal-show-comments .modal-footer").hide();
			}
			else {
				$("#modal-show-comments .modal-footer").show();
			}

			$("#form-add-appointment-comment [name='contact_appointment_id']").val(id);

			$.ajax({
				type: "POST",
				url: '/ws/contact/appointment/comment/get',
				data: { 'contact_appointment_id': id },
				dataType: "json",
				success: function(result) {
					console.log(result);
					var comment_html = "";
					var ul = $('<ul class="media-list media-list-with-divider media-messaging"/>');
					if (result && result.data.length > 0) {
						var temp = JSON.parse(JSON.stringify(result));

						$.each(temp.data, function(index, val) {
							var img = 'https://s3-us-west-2.amazonaws.com/zugent/profilephotos/'+val.user_id+'/30x30.jpg';

							comment_html = '';
							comment_html += '<li class="media media-sm">';
							comment_html += '<a href="javascript:;" class="pull-left">';
							comment_html += '<img src="'+img+'" class="media-object rounded-corner">';
							comment_html += '</a>';
							comment_html += '<div class="media-body">';
							comment_html += '<h5 class="media-heading" style="color: #00acac;font-size: 16px;font-weight: 600;">'+val.first_name+' '+val.last_name+' <span style="color:#222; font-size:11px; font-weight:200;">('+ val.date_comment +')</span></h5>';
							comment_html += '<p>'+val.comment+'</p>';
	    					comment_html += '</div>';
	    					comment_html += '</li>';

	    					ul.append(comment_html);
						});

	    				$("#modal-comments-body").append(ul);
	    			}
	    			else {
						comment_html = '<p id="no-comments" class="text-center">No Comments Found</p>';
						ul.append(comment_html);
						$("#modal-comments-body").append(ul);
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				}
			});
		});

		$(document).on("click", '.btn-cancel-appointment',function(){
			appointment_id = $(this).data("appointment-id");
			current = this;
		});

		function cancel_appointment() {
			$('.btn-cancel-appointment').confirmation({
				title: "Are you sure you want to cancel appointment?",
				placement: "left",
				btnOkLabel: "Yes",
				btnOkIcon: "fa fa-check",
				btnOkClass: "btn btn-sm btn-success m-r-3",
				btnCancelLabel: "No",
				btnCancelClass: "btn btn-sm btn-danger",
				onConfirm: function(event, element) {
					console.log(element);
					$.ajax({
						type: "POST",
						url: '/ws/contact/appointment/cancel',
						data: {
							'contact_appointment_id': appointment_id,
							'contact_id': {$contact_data.contact_id}
						},
						dataType: "json",
						success: function(result) {
							console.log(result);

							if (result.msg) {
								var first = $(current).closest('tr');
								$(first).next("tr").remove();
								$(first).remove();
								removeNoDataRow("table#cancelledAppointmentsTbl tbody tr");
								removeNoDataRow("table#commentsTbl tbody tr");

								$('#commentsTbl tr:first').after("<tr><td style='width:200px;'><b>{$user.first_name} {$user.last_name}</b><br/><small>Just Now</small></td><td>" + result.comment + "</td></tr>");
								refresh_counter('#comments_count');

								var row_html = '';
								row_html += '<tr id="ca-'+result.data[0]['contact_appointment_id']+'">';
								row_html += '<td>'+result.data[0]['contact_appointment_id']+'</td>';
								row_html += '<td class="text-center">'+result.data[0]['first_name']+' '+result.data[0]['last_name']+'</td>';
								row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_appointment'])+'</td>';
								row_html += '<td class="text-center">'+time_format(result.data[0]['date_appointment'])+'</td>';
								row_html += '<td class="text-center">'+result.data[0]['appointment_type']+'</td>';
								row_html += '<td class="text-center">';
		    					row_html += '<a href="#modal-show-comments" class="btn btn-xs btn-info m-b-5 show-comments" data-appointment-id="'+result.data[0]['contact_appointment_id']+'" data-add-comment="no" data-toggle="modal"><i class="glyphicon glyphicon-edit"></i><span id="appointment_comment_count-'+result.data[0]['contact_appointment_id']+'">Show Comment/s</span></a>';
		    					row_html += '</td>';
		    					row_html += '<td class="text-center">';
		    					row_html += '<a href="javascript:void(0)" class="btn btn-xs btn-primary m-r-5 m-b-5 btn-uncancel-appointment" data-appointment-id="'+result.data[0]['contact_appointment_id']+'"><i class="glyphicon glyphicon-ok"></i> Uncancel</a>';
		    					row_html += '</td>';
		    					row_html += '</tr>';
								row_html += '<tr id="ca-desc-'+result.data[0]['contact_appointment_id']+'">';
		    					row_html += '<td colspan="7">';
		    					row_html += '<p>'+result.data[0]['description']+'</p>';
		    					row_html += '</td>';
		    					row_html += '</tr>';
		    					$("#cancelledAppointmentsTbl tbody").append(row_html);

								if($("#cancelledAppointmentsTbl tbody tr").length > 0) {
									if ($("#cancelled-appointments-panel").is( ":visible" ) && $("#cancelled-appointments-panel .panel-body").is( ":hidden" )) {
										$("#toggle-cancelled-appointments").click();
									}
									else if (!$("#cancelled-appointments-panel").is( ":visible" )) {
										$("#cancelled-appointments-panel").css('display', 'block');
										$("#toggle-cancelled-appointments").click();
									}
								}
								else {
									$("#cancelled-appointments-panel").css('display', 'none');
									$("#toggle-cancelled-appointments").click();
								}

								addNoDataAvailable("table#appointmentsTbl tbody", '7', 'No Follow-Up / Contacts Available');
                        		flash_alert('#alert_success_appointment', 'Cancelled an appointement.');
							}
							else {
								window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
							}
						},
						error: function (XMLHttpRequest, textStatus, errorThrown) {
							console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
						},
					    complete: function() {
					    	scrolltoBottom();
					    }
					});
				},
				onCancel: function() { }
			});
		}

		$(document).on("click", '.btn-uncancel-appointment',function(){
			current = this;

			$("#modal-comments-body").html("");
			var id = $(this).data("appointment-id");

			$.ajax({
				type: "POST",
				url: '/ws/contact/appointment/uncancel',
				data: {
					'contact_appointment_id': id,
					'contact_id': {$contact_data.contact_id}
				},
				dataType: "json",
				success: function(result) {
					console.log(result);

					if (result.msg) {
						var first = $(current).closest('tr');
						$(first).next("tr").remove();
						$(first).remove();
						removeNoDataRow("table#commentsTbl tbody tr");
						removeNoDataRow("table#appointmentsTbl tbody tr");

						refresh_counter('#comments_count');
						$('#commentsTbl tr:first').after("<tr><td style='width:200px;'><b>{$user.first_name} {$user.last_name}</b><br/><small>Just Now</small></td><td>" + result.comment + "</td></tr>");

						var row_html = '';
						row_html += '<tr id="ca-'+result.data[0]['contact_appointment_id']+'">';
						row_html += '<td>'+result.data[0]['contact_appointment_id']+'</td>';
						row_html += '<td class="text-center">'+result.data[0]['first_name']+' '+result.data[0]['last_name']+'</td>';
						row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_appointment'])+'</td>';
						row_html += '<td class="text-center">'+time_format(result.data[0]['date_appointment'])+'</td>';
						row_html += '<td class="text-center">'+result.data[0]['appointment_type']+'</td>';
						row_html += '<td class="text-center">';
    					row_html += '<a href="#modal-show-comments" class="btn btn-xs btn-info m-b-5 show-comments" data-appointment-id="'+result.data[0]['contact_appointment_id']+'" data-add-comment="yes" data-toggle="modal"><i class="glyphicon glyphicon-edit"></i><span id="appointment_comment_count-'+result.data[0]['contact_appointment_id']+'">Show Comment/s</span></a>';
    					row_html += '</td>';
    					row_html += '<td class="text-center" nowrap>';
    					row_html += '<a href="javascript:void(0)" class="btn btn-xs btn-info m-r-5 m-b-5 edit-appointment" data-appointment-id="'+result.data[0]['contact_appointment_id']+'" data-appointment-type="'+result.data[0]['appointment_type_id']+'" data-appointment-date="'+result.data[0]['date_appointment']+'" data-description="'+result.data[0]['description']+'"><i class="glyphicon glyphicon-edit"></i>Edit</a>';
    					row_html += ' ';
    					row_html += '<a href="javascript:void(0)" class="btn btn-xs btn-success m-r-5 m-b-5 show-completion-notes" data-appointment-id="'+result.data[0]['contact_appointment_id']+'"><i class="glyphicon glyphicon-edit"></i>Complete</a>';
    					row_html += ' ';
    					row_html += '<a data-href="#panel-referrals" class="btn btn-xs btn-danger m-b-5 btn-cancel-appointment" data-appointment-id="'+result.data[0]['contact_appointment_id']+'"><i class="glyphicon glyphicon-remove"></i>Cancel</a>';
    					row_html += '</td>';
    					row_html += '</tr>';
						row_html += '<tr id="ca-desc-'+result.data[0]['contact_appointment_id']+'">';
    					row_html += '<td colspan="6">';
    					row_html += '<p>'+result.data[0]['description']+'</p>';
    					row_html += '</td>';
    					row_html += '</tr>';
    					$("#appointmentsTbl tbody").append(row_html);

						if($("#cancelledAppointmentsTbl tbody tr").length > 0) {
							if ($("#cancelled-appointments-panel").is( ":visible" ) && $("#cancelled-appointments-panel .panel-body").is( ":hidden" )) {
								$("#toggle-cancelled-appointments").click();
							}
							else if (!$("#cancelled-appointments-panel").is( ":visible" )) {
								$("#cancelled-appointments-panel").css('display', 'block');
								$("#toggle-cancelled-appointments").click();
							}
						}
						else {
							$("#cancelled-appointments-panel").css('display', 'none');
							$("#toggle-cancelled-appointments").click();
						}

						cancel_appointment();
                        flash_alert('#alert_success_appointment', 'Uncancelled an appointement.');
					}
					else {
						window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				},
			    complete: function() {
			    	scrolltoBottom();
			    }
			});
		});

		$(document).on("click", '#modal-add-appointment #modal-save',function(){
			$("#form-add-appointment").submit();
		});

		$("#form-add-appointment").on("submit", function(e){
			e.preventDefault();
			var target = $('#form-add-appointment').closest('.panel');
			var action;
			if ($("#form-add-appointment").data('form-action') == 'add') { action = 'add'; }
			else { action = 'edit'; }
			if ( $(this).parsley().isValid() ) {
				$.ajax({
					type: "POST",
					url: '/ws/contact/appointment/'+action,
					data: $(this).serialize(),
					dataType: "json",
				    beforeSend: function() {
				        if (!$(target).hasClass('panel-loading')) {
				            var targetBody = $(target).find('.panel-body');
				            var spinnerHtml = '<div class="panel-loader"><span class="spinner-small"></span></div>';
				            $(target).addClass('panel-loading');
				            $(targetBody).prepend(spinnerHtml);
				        }
				    },
					success: function(result) {
						console.log(result);

						if (result.msg) {
							if ($("#form-add-appointment").data('form-action') == 'add') {
								removeNoDataRow("table#appointmentsTbl tbody tr");
								var row_html = '';
								row_html += '<tr id="ca-'+result.data[0]['contact_appointment_id']+'">';
								row_html += '<td>'+result.data[0]['contact_appointment_id']+'</td>';
								row_html += '<td class="text-center">'+result.data[0]['first_name']+' '+result.data[0]['last_name']+'</td>';
								row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_appointment'])+'</td>';
								row_html += '<td class="text-center">'+time_format(result.data[0]['date_appointment'])+'</td>';
								row_html += '<td class="text-center">'+result.data[0]['appointment_type']+'</td>';
								row_html += '<td class="text-center">';
		    					row_html += '<a href="#modal-show-comments" class="btn btn-xs btn-info m-b-5 show-comments" data-appointment-id="'+result.data[0]['contact_appointment_id']+'" data-add-comment="yes" data-toggle="modal"><i class="glyphicon glyphicon-edit"></i><span id="appointment_comment_count-'+result.data[0]['contact_appointment_id']+'">Show Comment/s</span></a>';
		    					row_html += '</td>';
		    					row_html += '<td class="text-center" nowrap>';
		    					row_html += '<a href="javascript:void(0)" class="btn btn-xs btn-info m-r-5 m-b-5 edit-appointment" data-appointment-id="'+result.data[0]['contact_appointment_id']+'" data-appointment-type="'+result.data[0]['appointment_type_id']+'" data-appointment-date="'+result.data[0]['date_appointment']+'" data-description="'+result.data[0]['description']+'"><i class="glyphicon glyphicon-edit"></i>Edit</a>';
		    					row_html += ' ';
		    					row_html += '<a href="javascript:void(0)" class="btn btn-xs btn-success m-r-5 m-b-5 show-completion-notes" data-appointment-id="'+result.data[0]['contact_appointment_id']+'"><i class="glyphicon glyphicon-edit"></i>Complete</a>';
		    					row_html += ' ';
		    					row_html += '<a data-href="#panel-referrals" class="btn btn-xs btn-danger m-b-5 btn-cancel-appointment" data-appointment-id="'+result.data[0]['contact_appointment_id']+'"><i class="glyphicon glyphicon-remove"></i>Cancel</a>';
		    					row_html += '</td>';
		    					row_html += '</tr>';
		    					row_html += '<tr>';
		    					row_html += '<td colspan="7">';
		    					row_html += '<p>'+result.data[0]['description']+'</p>';
		    					row_html += '</td>';
		    					row_html += '</tr>';
		    					$("#appointmentsTbl tbody").append(row_html);

								refresh_counter('#appointments_count');
		    					cancel_appointment();
                        		flash_alert('#alert_success_appointment', 'Added an appointement.');
				    			scrolltoBottom();
							}
							else {
								var row1 = $("table#appointmentsTbl tbody").find('tr#ca-'+result.data[0]['contact_appointment_id']);
								var row2 = $("table#appointmentsTbl tbody").find('tr#ca-desc-'+result.data[0]['contact_appointment_id']);

								var row1_html = '';
								var row2_html = '';

								row1_html += '<tr id="ca-'+result.data[0]['contact_appointment_id']+'">';
								row1_html += '<td>'+result.data[0]['contact_appointment_id']+'</td>';
								row1_html += '<td class="text-center">'+result.data[0]['first_name']+' '+result.data[0]['last_name']+'</td>';
								row1_html += '<td class="text-center">'+datetime_format(result.data[0]['date_appointment'])+'</td>';
								row1_html += '<td class="text-center">'+time_format(result.data[0]['date_appointment'])+'</td>';
								row1_html += '<td class="text-center">'+result.data[0]['appointment_type']+'</td>';
								row1_html += '<td class="text-center">';
		    					row1_html += '<a href="#modal-show-comments" class="btn btn-xs btn-info m-b-5 show-comments" data-appointment-id="'+result.data[0]['contact_appointment_id']+'" data-add-comment="yes" data-toggle="modal"><i class="glyphicon glyphicon-edit"></i><span id="appointment_comment_count-'+result.data[0]['contact_appointment_id']+'">Show Comment/s</span></a>';
		    					row1_html += '</td>';
		    					row1_html += '<td class="text-center" nowrap>';
		    					row1_html += '<a href="javascript:void(0)" class="btn btn-xs btn-info m-r-5 m-b-5 edit-appointment" data-appointment-id="'+result.data[0]['contact_appointment_id']+'" data-appointment-type="'+result.data[0]['appointment_type_id']+'" data-appointment-date="'+result.data[0]['date_appointment']+'" data-description="'+result.data[0]['description']+'"><i class="glyphicon glyphicon-edit"></i>Edit</a>';
		    					row1_html += ' ';
		    					row1_html += '<a href="javascript:void(0)" class="btn btn-xs btn-success m-r-5 m-b-5 show-completion-notes" data-appointment-id="'+result.data[0]['contact_appointment_id']+'"><i class="glyphicon glyphicon-edit"></i>Complete</a>';
		    					row1_html += ' ';
		    					row1_html += '<a data-href="#panel-referrals" class="btn btn-xs btn-danger m-b-5 btn-cancel-appointment" data-appointment-id="'+result.data[0]['contact_appointment_id']+'"><i class="glyphicon glyphicon-remove"></i>Cancel</a>';
		    					row1_html += '</td>';
		    					row1_html += '</tr>';

								row2_html += '<tr id="ca-desc-'+result.data[0]['contact_appointment_id']+'">';
		    					row2_html += '<td colspan="7">';
		    					row2_html += '<p>'+result.data[0]['description']+'</p>';
		    					row2_html += '</td>';
		    					row2_html += '</tr>';

						        row1.replaceWith(row1_html);
						        row2.replaceWith(row2_html);

								$('#commentsTbl tr:first').after("<tr><td style='width:200px;'><b>{$user.first_name} {$user.last_name}</b><br/><small>Just Now</small></td><td>" + result.comment + "</td></tr>");

								refresh_counter('#comments_count');
		    					cancel_appointment();
                        		flash_alert('#alert_success_appointment', 'Updated an appointement.');
							}

			                $(target).removeClass('panel-loading');
			                $(target).find('.panel-loader').remove();
						}
						else {
							window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					},
				    complete: function() {
				    	$("#modal-add-appointment").modal('hide');
				    }
				});
			}
		});

		$(document).on("click", '#add-appointment',function(){
			$("#form-add-appointment").data("form-action", "add");
			$('#appointment-date').data("DateTimePicker").clear();
		});

		$(document).on("change", '#appointment-type',function(){
			$('#appointment-type-name').val($('#appointment-type').select2('data')[0].text);
		});

		$(document).on("dp.change", '#appointment-date',function(e){
			if ($(this).val() != '') { $('#selected-appointment-date').val(am_pm_to_hours($(this).val())); }
			else { $('#selected-appointment-date').val(''); }
		});

		$(document).on("click", '.edit-appointment',function(){
			$("#modal-add-appointment").modal("show");
			$("#form-add-appointment").data("form-action", "edit");
			$("#form-add-appointment #contact-appointment-id").val($(this).data("appointment-id"));
			$("#appointment-type").val($(this).data("appointment-type")).trigger('change');
			$("#description").val($(this).data("description"));
			$('#appointment-date').data("DateTimePicker").date(datepickerFormat($(this).data("appointment-date")));
			$('#selected-appointment-date').val($(this).data("appointment-date"));
		});

		$('#modal-add-appointment').on('hide.bs.modal', function (){
			$("#form-add-appointment #contact-appointment-id").val("");
			$("#appointment-type").val("");
			$('#appointment-date').data("DateTimePicker").clear();
			$("#description").val("");
			$('#selected-appointment-date').val("");
			$("#form-add-appointment").parsley().reset();
		});

		$("#toggle-completed-appointments").on("click", function(){
			if(shownCompletedAppointments == 0) {
				$(this).html('<i class="fa fa-minus"></i> Hide Completed Follow-Up / Contacts');
				shownCompletedAppointments++;
			}
			else {
				$(this).html('<i class="fa fa-expand"></i> Show '+{$complete_appointments|count}+' Completed Follow-Up / Contacts');
				shownCompletedAppointments--;
			}
		});

		$("#toggle-cancelled-appointments").on("click", function(){
			if(shownCancelledAppointments == 0) {
				$(this).html('<i class="fa fa-minus"></i> Hide Cancelled Follow-Up / Contacts');
				shownCancelledAppointments++;
			}
			else {
				$(this).html('<i class="fa fa-expand"></i> Show '+{$cancelled_appointments|count}+' Cancelled Follow-Up / Contacts');
				shownCancelledAppointments--;
			}
		});
		/************************************************ End-Appointments Section ************************************************/

		/************************************************ MLS Searches Section ************************************************/

		$("#modal-save-mls-search").click(function() {
			$("#form-add-mls-search").submit();
		});

		$("#modal-edit-mls-search").click(function() {
			$("#form-edit-mls-search").submit();
		});

		$(document).on("click", '.deactivate-searches',function(){
			var search_id = $(this).data("searches-id");

			$.ajax({
				type: "POST",
				url: '/ws/contact/delete_mls_search',
				data: { search_id: search_id, is_deleted: '1'},
				dataType: "json",
				success: function(result) {
					console.log(result);
					if(result.msg) {
						$("table#searchesTbl tbody tr").remove();
						$.each(result.data, function(index, val) {

							var row = $("table#searchesTbl tbody").find('tr#rf-'+val.contact_search_id);
							var row_html = '';
							row_html += '<tr id="rf-'+val.contact_search_id+'">';
							row_html += '<td>'+nullCheck(val.contact_search_id)+'</td>';
							row_html += '<td class="text-center">'+nullCheck(val.is_active)+'</td>';
							row_html += '<td class="text-center">'+nullCheck(val.date_modified)+'</td>';
							row_html += '<td class="text-center">'+nullCheck(val.max_bedroom)+'</td>';
							row_html += '<td class="text-center">'+nullCheck(val.max_bathroom)+'</td>';
							row_html += '<td class="text-center">'+nullCheck(val.city)+'</td>';
							row_html += '<td class="text-center">'+nullCheck(val.county)+'</td>';
							row_html += '<td class="text-center">'+nullCheck(val.listing_type)+'</td>';

								if(nullCheck(val.is_active) != 0){
									row_html += '<td class="text-center" nowrap>';
									row_html += '<a href="#modal-edit-searches" class="btn btn-xs btn-info m-r-5 m-b-5 btn-edit-searches"'+
									'data-search-id="'+val.contact_search_id+'" data-search-city="'+val.city+'"'+
									'data-search-state="'+val.state+'" data-search-zip="'+val.zip+'"'+
									'data-search-county="'+val.county+'" data-search-listing_class="'+val.listing_class+'"'+
									'data-search-type="'+val.listing_type+'"'+
									'data-search-min_bedroom="'+val.min_bedroom+'" data-search-max_bedroom="'+val.max_bedroom+'"'+
									'data-search-min_bathroom="'+result.data[0]['min_bathroom']+'" data-search-max_bathroom="'+val.max_bathroom+'"'+
									'data-search-min_sqft="'+val.min_sqft+'" data-search-max_sqft="'+val.max_sqft+'"'+
									'data-bob="" data-toggle="modal"><i class="glyphicon glyphicon-edit"></i>Edit</a>';
									row_html += ' ';
									row_html += '<a href="javascript:void(0)" class="btn btn-xs btn-danger m-r-5 m-b-5 deactivate-searches" data-searches-id="'+val.contact_search_id+'"><i class="glyphicon glyphicon-remove"></i>Remove Search</a>';
		    					row_html += '</td>';
								}

	    				row_html += '</tr>';

							$("#searchesTbl tbody").append(row_html);
							flash_alert('#alert_success_searches', 'Deleted a Search.');
						});
					}
					else {
						//window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
					}
				}
			});

		});

		$("#form-edit-mls-search").on('submit',function(e) {
			e.preventDefault();
			var e_id = $('#search_mls_id').val();
			var e_class = $('#edit_class').val();
			var e_type = $('#edit_type').val();
			var e_city = $('#edit_city').val();
			var e_state = $('#edit_state').val();
			var e_zip = $('#edit_zip').val();
			var e_county = $('#edit_county').val();
			var e_minbath = $('#edit_min_bath').val();
			var e_maxbath = $('#edit_max_bath').val();
			var e_minbed = $('#edit_min_bed').val();
			var e_maxbed = $('#edit_max_bed').val();
			var e_minsqft = $('#edit_min_sqft').val();
			var e_maxsqft = $('#edit_max_sqft').val();

			$.ajax({
				type: "POST",
				url: '/ws/contact/edit_mls_search',
				data: { e_id: e_id, e_class: e_class, e_type: e_type, e_city: e_city, e_state: e_state, e_zip: e_zip, e_county: e_county,
								e_minbath: e_minbath, e_maxbath: e_maxbath, e_minbed: e_minbed, e_maxbed: e_maxbed, e_minsqft: e_minsqft, e_maxsqft: e_maxsqft},
				dataType: "json",
				success: function(result) {
					console.log(result);

						if (result.msg) {
							var row = $("table#searchesTbl tbody").find('tr#rf-'+result.data[0]['contact_search_id']);
							var row_html = '';
							row_html += '<tr id="rf-'+result.data[0]['contact_search_id']+'">';
							row_html += '<td>'+result.data[0]['contact_search_id']+'</td>';
							row_html += '<td class="text-center">'+result.data[0]['is_active']+'</td>';
							row_html += '<td class="text-center">'+nullCheck(result.data[0]['date_modified'])+'</td>';
							row_html += '<td class="text-center">'+result.data[0]['max_bedroom']+'</td>';
							row_html += '<td class="text-center">'+result.data[0]['max_bathroom']+'</td>';
							row_html += '<td class="text-center">'+nullCheck(result.data[0]['city'])+'</td>';
							row_html += '<td class="text-center">'+nullCheck(result.data[0]['county'])+'</td>';
							row_html += '<td class="text-center">'+nullCheck(result.data[0]['listing_type'])+'</td>';
							if(nullCheck(result.data[0]['is_active']) != 0){
								row_html += '<td class="text-center" nowrap>';
								row_html += '<a href="#modal-edit-searches" class="btn btn-xs btn-info m-r-5 m-b-5 btn-edit-searches"'+
								'data-search-id="'+result.data[0]['contact_search_id']+'" data-search-city="'+result.data[0]['city']+'"'+
								'data-search-state="'+result.data[0]['state']+'" data-search-zip="'+result.data[0]['zip']+'"'+
								'data-search-county="'+result.data[0]['county']+'" data-search-listing_class="'+result.data[0]['listing_class']+'"'+
								'data-search-type="'+result.data[0]['listing_type']+'"'+
								'data-search-min_bedroom="'+result.data[0]['min_bedroom']+'" data-search-max_bedroom="'+result.data[0]['max_bedroom']+'"'+
								'data-search-min_bathroom="'+result.data[0]['min_bathroom']+'" data-search-max_bathroom="'+result.data[0]['max_bathroom']+'"'+
								'data-search-min_sqft="'+result.data[0]['min_sqft']+'" data-search-max_sqft="'+result.data[0]['max_sqft']+'"'+
								'data-bob="" data-toggle="modal"><i class="glyphicon glyphicon-edit"></i>Edit</a>';
								row_html += ' ';
								row_html += '<a href="javascript:void(0)" class="btn btn-xs btn-danger m-r-5 m-b-5 deactivate-searches" data-searches-id="'+result.data[0]['contact_search_id']+'"><i class="glyphicon glyphicon-remove"></i>Remove Search</a>';
								row_html += '</td>';
							}
	    				row_html += '</tr>';
					        row.replaceWith(row_html);

							//$('#commentsTbl tr:first').after("<tr><td style='width:200px;'><b>{$user.first_name} {$user.last_name}</b><br/><small>Just Now</small></td><td>" + result.comment + "</td></tr>");

							//refresh_counter('#searches_count');
              flash_alert('#alert_success_searches', 'Updated a search.');
						}

					else {
						//window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
					}
				},
				complete: function() {
					$("#modal-edit-searches").modal('hide');
				}
			});

		});

		$("#form-add-mls-search").on('submit',function(e) {
			e.preventDefault();
			var listing_class = $('#class').val();
			var listing_type = $('#type').val();
			var city_name = $('#city_name').val();
			var state_name = $('#state_name').val();
			var zip_code = $('#zip_code').val();
			var county_name = $('#county_name').val();
			var min_bath = $('#min_bath').val();
			var max_bath = $('#max_bath').val();
			var min_bed = $('#min_bed').val();
			var max_bed = $('#max_bed').val();
			var min_sqft = $('#min_sqft').val();
			var max_sqft = $('#max_sqft').val();

			$.ajax({
				type: "POST",
				url: '/ws/contact/add_mls_search',
				data: { listing_class: listing_class,  listing_type: listing_type, city_name: city_name, state_name: state_name,
					zip_code: zip_code, county_name: county_name, min_bath: min_bath, max_bath: max_bath, min_bed: min_bed, max_bed: max_bed,
					min_sqft: min_sqft, max_sqft: max_sqft},
				dataType: "json",
				success: function(result) {
					console.log(result);
					if (result.msg) {
						removeNoDataRow("table#searchesTbl tbody tr");
						var row_html = '';
						row_html += '<tr id="rf-'+result.data[0]['contact_search_id']+'">';
						row_html += '<td>'+result.data[0]['contact_search_id']+'</td>';
						row_html += '<td class="text-center">'+result.data[0]['is_active']+'</td>';
						row_html += '<td class="text-center">'+nullCheck(result.data[0]['date_modified'])+'</td>';
						row_html += '<td class="text-center">'+result.data[0]['max_bedroom']+'</td>';
						row_html += '<td class="text-center">'+result.data[0]['max_bathroom']+'</td>';
						row_html += '<td class="text-center">'+nullCheck(result.data[0]['city'])+'</td>';
						row_html += '<td class="text-center">'+nullCheck(result.data[0]['county'])+'</td>';
						row_html += '<td class="text-center">'+nullCheck(result.data[0]['listing_type'])+'</td>';
						if(nullCheck(result.data[0]['is_active']) != 0){
							row_html += '<td class="text-center" nowrap>';
							row_html += '<a href="#modal-edit-searches" class="btn btn-xs btn-info m-r-5 m-b-5 btn-edit-searches"'+
							'data-search-id="'+result.data[0]['contact_search_id']+'" data-search-city="'+result.data[0]['city']+'"'+
							'data-search-state="'+result.data[0]['state']+'" data-search-zip="'+result.data[0]['zip']+'"'+
							'data-search-county="'+result.data[0]['county']+'" data-search-listing_class="'+result.data[0]['listing_class']+'"'+
							'data-search-type="'+result.data[0]['listing_type']+'"'+
							'data-search-min_bedroom="'+result.data[0]['min_bedroom']+'" data-search-max_bedroom="'+result.data[0]['max_bedroom']+'"'+
							'data-search-min_bathroom="'+result.data[0]['min_bathroom']+'" data-search-max_bathroom="'+result.data[0]['max_bathroom']+'"'+
							'data-search-min_sqft="'+result.data[0]['min_sqft']+'" data-search-max_sqft="'+result.data[0]['max_sqft']+'"'+
							'data-bob="" data-toggle="modal"><i class="glyphicon glyphicon-edit"></i>Edit</a>';
							row_html += ' ';
							row_html += '<a href="javascript:void(0)" class="btn btn-xs btn-danger m-r-5 m-b-5 deactivate-searches" data-searches-id="'+result.data[0]['contact_search_id']+'"><i class="glyphicon glyphicon-remove"></i>Remove Search</a>';
							row_html += '</td>';
						}
						row_html += '</tr>';
						$("#searchesTbl tbody").append(row_html);

						refresh_counter('#searches_count');
							scrolltoBottom();
												flash_alert('#alert_success_searches', 'Added a Search.');
					}
					else {
						//window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
					}
				},
				complete: function() {
					$("#modal-add-searches").modal('hide');
				}
			});

		});

		$(document).on("click", '.btn-edit-searches',function(){
			$("#form-edit-mls-search #edit_class").val($(this).data("search-listing_class"));
			$("#form-edit-mls-search #edit_type").val($(this).data("search-type"));
			$("#form-edit-mls-search #edit_city").val($(this).data("search-city"));
			$("#form-edit-mls-search #edit_state").val($(this).data("search-state"));
			$("#form-edit-mls-search #edit_zip").val($(this).data("search-zip"));
			$("#form-edit-mls-search #edit_county").val($(this).data("search-county"));
			$("#form-edit-mls-search #edit_min_bath").val($(this).data("search-min_bedroom"));
			$("#form-edit-mls-search #edit_max_bath").val($(this).data("search-max_bedroom"));
			$("#form-edit-mls-search #edit_min_bed").val($(this).data("search-min_bathroom"));
			$("#form-edit-mls-search #edit_max_bed").val($(this).data("search-max_bathroom"));
			$("#form-edit-mls-search #edit_min_sqft").val($(this).data("search-min_sqft"));
			$("#form-edit-mls-search #edit_max_sqft").val($(this).data("search-max_sqft"));
			$("#form-edit-mls-search #search_mls_id").val($(this).data("search-id"));

			/*$("#form-edit-referral #referral-id").val($(this).data("referral-id"));
			$("#form-edit-referral #select-edit-referral-users").val($(this).data("user-id"));
			$("#form-edit-referral #select-edit-referral-users").select2({ width:'100%', placeholder:'Please select one' });*/
		});
		/************************************************ End-MLS Searches Section ************************************************/

		/************************************************ Comments Section ************************************************/
		$("#modal-save-contact-comment").click(function() {
			$("#form-add-contact-comment").submit();
		});

		$('#modal-add-contact-comment').on('hide.bs.modal', function (){
			$("#form-add-contact-comment").parsley().reset();
		});

		$("#form-add-contact-comment").on('submit',function(e) {
			e.preventDefault(); //=== To Avoid Page Refresh and Fire the Event "Click"===
			if ( $(this).parsley().isValid() ) {
				var comment = $('#comment').val();
				$.ajax({
					type: "POST",
					url: '/ws/contact/add_comment',
					data: { 'contact_id': {$contact_data.contact_id}, comment: comment },
				dataType: "json",
					success: function(result) {
						console.log(result);
						if(result) {
							refresh_counter('#comments_count');
							$('#commentsTbl tr:first').after("<tr><td style='width:200px;'><b>{$user.first_name} {$user.last_name}</b><br/><small>Just Now</small></td><td>" + comment + "</td></tr>");
							$('#comment').val("");
							$('#form-add-contact-comment').parsley().reset();
							removeNoDataRow("table#commentsTbl tbody tr");
							$('#modal-add-contact-comment').modal('hide');
                        	flash_alert('#alert_success_comment', 'Added a comment.');
						}
						else {
							window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
						}
					}
				});
			}
		});
		/************************************************ End-Comments Section ************************************************/


		/************************************************ Attached Files Section ************************************************/
		$(document).on("click", ".edit-contact-file", function() {
			$("#modal-contact-file-name").val($(this).data("file-name"));
			$("#modal-contact-file-type").val($(this).data("contact-file-type")).trigger('change');
			$("#modal-file-type-id").val($(this).data("contact-file-type"));
			$("#modal-contact-file-id").val($(this).data("contact-file-id"));
		});

		$(document).on("click", "#save-contact-file", function() {
			$("#form-edit-contact-file").submit();
		});

		$("#form-edit-contact-file").on("submit", function(e){
			e.preventDefault();
			if ( $(this).parsley().isValid() ) {
				$.ajax({
					type: "POST",
					url: '/ws/contact/attached_file/edit',
					data: $(this).serialize(),
					dataType: "json",
					success: function(result) {
						console.log(result);

						if (result.msg) {
							var row = $("table#contactFilesTbl tbody").find('tr#cf-'+result.data[0]['contact_file_id']);
							var row_html = '';
							row_html += '<tr id="cf-'+result.data[0]['contact_file_id']+'">';
							row_html += '<td><b>'+result.data[0]['file_name']+'</b></td>';
							row_html += '<td class="text-center">'+result.data[0]['file_type_name']+'</td>';
							row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_uploaded'])+'</td>';
							row_html += '<td class="text-center">';
							row_html += '<a href="#modal-edit-file" class="btn btn-xs btn-info m-r-5 m-b-5 edit-contact-file" data-toggle="modal" data-contact-file-id="'+result.data[0]['contact_file_id']+'" data-file-type-name="'+result.data[0]['file_type_name']+'" data-contact-file-type="'+result.data[0]['file_type_id']+'" data-file-name="'+result.data[0]['file_name']+'"><i class="glyphicon glyphicon-edit"></i>Edit</a>';
							row_html += ' ';
							row_html += '<a href="https://s3-us-west-2.amazonaws.com/zugent'+result.data[0]['file_key']+'" target="_blank" class="btn btn-xs btn-info m-r-5 m-b-5" data-file-type-name="'+result.data[0]['file_type_name']+'" data-contact-file-id="'+result.data[0]['contact_file_id']+'"><i class="glyphicon glyphicon-edit"></i>Download</a>';
							row_html += ' ';
							row_html += '<a data-href="javascript:void(0)" class="btn btn-xs btn-danger m-r-5 m-b-5 btn-delete-contact-file" data-contact-file-id="'+result.data[0]['contact_file_id']+'"><i class="glyphicon glyphicon-remove"></i>Delete</a>';
							row_html += '</td>';
							row_html += '</tr>';
					        row.replaceWith(row_html);

					        delete_contact_file();
                    		flash_alert('#alert_success_attachedfile', 'Updated a file.');
						}
						else {
							window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					},
				    complete: function() {
				    	$("#modal-edit-file").modal('hide');
				    }
				});
			}
		});

		$(document).on("change", "#modal-contact-file-type", function() {
			$("#modal-file-type-id").val($(this).val());
		});

		$(document).on("click", ".btn-delete-contact-file", function(e) {
			e.preventDefault();
			current = this;
		});

		$(document).on("click", ".btn-restore-contact-file", function(e) {
			// e.preventDefault();
			current = this;
		});

		function delete_contact_file() {
			$('.btn-delete-contact-file').confirmation({
				title: "Are you sure you want to delete this file?",
				placement: "left",
				btnOkLabel: "Yes",
				btnOkIcon: "fa fa-check",
				btnOkClass: "btn btn-sm btn-success m-r-3",
				btnCancelLabel: "No",
				btnCancelClass: "btn btn-sm btn-danger",
				onConfirm: function(event, element) {
					var contact_file_id = $(current).data("contact-file-id");

				    $.ajax({
						type: "POST",
				        url: '/ws/contact/attached_file/delete',
				        data: { 'contact_file_id': contact_file_id, 'contact_id': {$contact_data.contact_id} },
						dataType: "json",
						success: function(result) {
							console.log(result);
							if (result.msg) {
								var first = $(current).closest('tr');
								$(first).remove();

								var row = $("table#contactFilesTbl tbody").find('tr#cf-'+result.data[0]['contact_file_id']);
								var row_html = '';
								row_html += '<tr id="cf-'+result.data[0]['contact_file_id']+'">';
								row_html += '<td><b>'+result.data[0]['file_name']+'</b></td>';
								row_html += '<td class="text-center">'+result.data[0]['file_type_name']+'</td>';
								row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_uploaded'])+'</td>';
								row_html += '<td class="text-center">';
								row_html += '<a data-href="javascript:void(0)" class="btn btn-xs btn-info m-r-5 m-b-5 btn-restore-contact-file" data-contact-file-id="'+result.data[0]['contact_file_id']+'" data-btn-ok-label="Restore" data-btn-ok-icon="glyphicon glyphicon-share-alt" data-btn-ok-class="btn-info btn-sm" data-btn-cancel-label="Cancel" data-btn-cancel-icon="glyphicon glyphicon-ban-circle" data-btn-cancel-class="btn-danger btn-sm" data-toggle="confirmation" data-placement="left" data-original-title="" title=""><i class="glyphicon glyphicon-remove"></i>Restore</a>';
								row_html += '</td>';
								row_html += '</tr>';

								$("#deletedContactFilesTbl tbody").append(row_html);

								if($("#deletedContactFilesTbl tbody tr").length > 0) {
									if ($("#deleted-attachedfile-panel").is( ":visible" ) && $("#deleted-attachedfile-panel .panel-body").is( ":hidden" )) {
										$("#toggle-deleted-files").click();
									}
									else if (!$("#deleted-attachedfile-panel").is( ":visible" )) {
										$("#deleted-attachedfile-panel").css('display', 'block');
										$("#toggle-deleted-files").click();
									}
								}
								else {
									$("#deleted-attachedfile-panel").css('display', 'none');
									$("#toggle-deleted-files").click();
								}

								restore_contact_file();
								addNoDataAvailable("table#contactFilesTbl tbody", '4', 'No File Attached Available');
                    			flash_alert('#alert_success_attachedfile', 'Deleted a file.');
								scrolltoBottom();
							}
							else {
								window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
							}
						},
						error: function (XMLHttpRequest, textStatus, errorThrown) {
							console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
						}
					});
				},
				onCancel: function() { }
			});
		}

		function restore_contact_file() {
			$('.btn-restore-contact-file').confirmation({
				title: "Are you sure you want to restore this file?",
				placement: "left",
				btnOkLabel: "Yes",
				btnOkIcon: "fa fa-check",
				btnOkClass: "btn btn-sm btn-success m-r-3",
				btnCancelLabel: "No",
				btnCancelClass: "btn btn-sm btn-danger",
				onConfirm: function(event, element) {
					var contact_file_id = $(current).data("contact-file-id");

				    $.ajax({
						type: "POST",
				        url: '/ws/contact/attached_file/restore',
				        data: { 'contact_file_id': contact_file_id, 'contact_id': {$contact_data.contact_id} },
						dataType: "json",
						success: function(result) {
							console.log(result);
							if (result.msg) {
								var first = $(current).closest('tr');
								$(first).remove();
								removeNoDataRow("table#contactFilesTbl tbody tr");

								var row = $("table#deletedContactFilesTbl tbody").find('tr#cf-'+result.data[0]['contact_file_id']);
								var row_html = '';
								row_html += '<tr id="cf-'+result.data[0]['contact_file_id']+'">';
								row_html += '<td><b>'+result.data[0]['file_name']+'</b></td>';
								row_html += '<td class="text-center">'+result.data[0]['file_type_name']+'</td>';
								row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_uploaded'])+'</td>';
								row_html += '<td class="text-center">';
								row_html += '<a href="#modal-edit-file" class="btn btn-xs btn-info m-r-5 m-b-5 edit-contact-file" data-toggle="modal" data-contact-file-id="'+result.data[0]['contact_file_id']+'" data-file-type-name="'+result.data[0]['file_type_name']+'" data-contact-file-type="'+result.data[0]['file_type_id']+'" data-file-name="'+result.data[0]['file_name']+'"><i class="glyphicon glyphicon-edit"></i>Edit</a>';
								row_html += ' ';
								row_html += '<a href="https://s3-us-west-2.amazonaws.com/zugent'+result.data[0]['file_key']+'" target="_blank" class="btn btn-xs btn-info m-r-5 m-b-5" data-file-type-name="'+result.data[0]['file_type_name']+'" data-contact-file-id="'+result.data[0]['contact_file_id']+'"><i class="glyphicon glyphicon-edit"></i>Download</a>';
								row_html += ' ';
								row_html += '<a data-href="javascript:void(0)" class="btn btn-xs btn-danger m-r-5 m-b-5 btn-delete-contact-file" data-contact-file-id="'+result.data[0]['contact_file_id']+'"><i class="glyphicon glyphicon-remove"></i>Delete</a>';
								row_html += '</td>';
								row_html += '</tr>';

								$("#contactFilesTbl tbody").append(row_html);

								if($("#deletedContactFilesTbl tbody tr").length > 0) {
									if ($("#deleted-attachedfile-panel").is( ":visible" ) && $("#deleted-attachedfile-panel .panel-body").is( ":hidden" )) {
										$("#toggle-deleted-files").click();
									}
									else if (!$("#deleted-attachedfile-panel").is( ":visible" )) {
										$("#deleted-attachedfile-panel").css('display', 'block');
										$("#toggle-deleted-files").click();
									}
								}
								else {
									$("#deleted-attachedfile-panel").css('display', 'none');
									$("#toggle-deleted-files").click();
								}

								delete_contact_file();
                    			flash_alert('#alert_success_attachedfile', 'Restored a file.');
								scrolltoBottom();
							}
							else {
								window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
							}
						},
						error: function (XMLHttpRequest, textStatus, errorThrown) {
							console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
						}
					});
				},
				onCancel: function() { }
			});
		}

		$(document).on("click", "#toggle-deleted-files", function() {
			if(shownDeletedFiles == 0) {
				$(this).html('<i class="fa fa-minus"></i> Hide Deleted Files');
				shownDeletedFiles++;
			}
			else {
				$(this).html('<i class="fa fa-expand"></i> Show '+{$dfc_count}+' Deleted Files');
				shownDeletedFiles--;
			}
		});

		Dropzone.options.myDropzone = {
			autoProcessQueue: false,
			uploadMultiple: false,
			maxFiles: 1,
			init: function() {
				var submitButton = $("#upload-file");
				var target = $('#my-dropzone').closest('.panel');
				myDropzone = this;
				submitButton.on("click", function() {
                    if (myDropzone.getQueuedFiles().length > 0) {
							$('#no-file-uploaded').addClass('hide');
                    	if ($("#file-type-id").val() != '') {
					        if (!$(target).hasClass('panel-loading')) {
					            var targetBody = $(target).find('.panel-body');
					            var spinnerHtml = '<div class="panel-loader"><span class="spinner-small"></span></div>';
					            $(target).addClass('panel-loading');
					            $(targetBody).prepend(spinnerHtml);
					        }
							myDropzone.processQueue();
							$('#no-file-type').addClass('hide');
                    	}
                    	else {
							$('#no-file-type').removeClass('hide');
                    	}
					}
					else {
						$('#no-file-uploaded').removeClass('hide');
					}
				});
				this.on("sending", function(file, xhr, data) {
					data.append("contact_id", "{$contact_data.contact_id}");
					data.append("contact_file_type", $("#contact-file-type").val());
				});
				this.on("addedfile", function() {
					$("#upload-image").show();
				});
			},
			success: function(file, response){
				var target = $('#my-dropzone').closest('.panel');
				var result = JSON.parse(response);
                $(target).removeClass('panel-loading');
                $(target).find('.panel-loader').remove();
                $('#modal-add-contact-file').modal('hide');
                myDropzone.removeAllFiles();
				removeNoDataRow("table#contactFilesTbl tbody tr");
                flash_alert('#alert_success_attachedfile', 'Attached a file.');

				$.each(result.data, function(index, val) {

					var row_html = '';
					row_html += '<tr id="cf-'+val.contact_file_id+'">';
					row_html += '<td><b>'+val.file_name+'</b></td>';
					row_html += '<td class="text-center">'+val.file_type_name+'</td>';
					row_html += '<td class="text-center">'+datetime_format(val.date_uploaded)+'</td>';
					row_html += '<td class="text-center">';
					row_html += '<a href="#modal-edit-file" class="btn btn-xs btn-info m-r-5 m-b-5 edit-contact-file" data-toggle="modal" data-contact-file-id="'+val.contact_file_id+'" data-file-type-name="'+val.file_type_name+'" data-contact-file-type="'+val.file_type_id+'" data-file-name="'+val.file_name+'"><i class="glyphicon glyphicon-edit"></i>Edit</a>';
					row_html += ' ';
					row_html += '<a href="https://s3-us-west-2.amazonaws.com/zugent'+val.file_key+'" target="_blank" class="btn btn-xs btn-info m-r-5 m-b-5" data-file-type-name="'+val.file_type_name+'" data-contact-file-id="'+val.contact_file_id+'"><i class="glyphicon glyphicon-edit"></i>Download</a>';
					row_html += ' ';
					row_html += '<a data-href="javascript:void(0)" class="btn btn-xs btn-danger m-r-5 m-b-5 btn-delete-contact-file" data-contact-file-id="'+val.contact_file_id+'"><i class="glyphicon glyphicon-remove"></i>Delete</a>';
					row_html += '</td>';
					row_html += '</tr>';

					$("#contactFilesTbl tbody").append(row_html);

					if($("#deletedContactFilesTbl tbody tr").length > 0) {
						if ($("#deleted-attachedfile-panel").is( ":visible" ) && $("#deleted-attachedfile-panel .panel-body").is( ":hidden" )) {
							$("#toggle-deleted-files").click();
						}
						else if (!$("#deleted-attachedfile-panel").is( ":visible" )) {
							$("#deleted-attachedfile-panel").css('display', 'block');
							$("#toggle-deleted-files").click();
						}
					}
					else {
						$("#deleted-attachedfile-panel").css('display', 'none');
						$("#toggle-deleted-files").click();
					}

					delete_contact_file();
				});

			},
			error: function (XMLHttpRequest, textStatus, errorThrown){
				$.log('XHR ERROR ' + XMLHttpRequest.status);
			}
		};

		$("#upload-file").click(function(){
			$("#file-type-id").val($("#contact-file-type").val());
		});

		$('#modal-add-contact-file').on('hide.bs.modal', function (){
			$('#no-file-uploaded').addClass('hide');
			$('#no-file-type').addClass('hide');
			$('#no-file-type').val('');
            myDropzone.removeAllFiles();
		});
		/************************************************ End-Attached Files Section ************************************************/


		{if $company.has_campaigns eq '1'}
		/************************************************ Start-Campaign Section ************************************************/
		$(document).on("click", "#btn-add-campaign", function(e) {
			$("#form-add-campaigns").submit();
		});

		$("#modal-add-campaign").on("hide.bs.modal", function() {
			$("#form-add-campaigns").parsley().reset();
		});

		$("#form-add-campaigns").on("submit", function(e){
			e.preventDefault();
			var campaign_id = $('#campaigns').val();
			if ( $(this).parsley().isValid() ) {
				$.ajax({
					type: "POST",
					url: '/ws/campaigns/add',
					data: { 'id': {$contact_data.contact_id}, 'campaign': campaign_id },
					dataType: "json",
					success: function(result) {
						if (result.msg == "User Not Related") {
                        	$('#modal-add-campaign').modal('hide');
                        	flash_alert('#alert_error_campaign', "User is not related on the contact.");
						}
						else if (result.msg == "Already Exists") {
                        	$('#modal-add-campaign').modal('hide');
                        	flash_alert('#alert_exists_campaign', "Contact is already subscribed to that campaign.");
						}
						else if(result.msg) {
							removeNoDataRow("table#commentsTbl tbody tr");
							$("#no-campaigns").remove();
							console.log(result.data[0]['date_last_sent']);

							var row_html = "";
							row_html += '<tr>';
							row_html += '<td>'+result.data[0]['campaign_contact_id']+'</td>';
							row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_added'])+'</td>';
							if (result.data[0]['date_last_sent'] != "" && result.data[0]['date_last_sent'] != null) {
								row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_last_sent'])+'</td>';
							}
							else {
								row_html += '<td class="text-center"></td>';
							}
							row_html += '<td class="text-center">'+result.data[0]['campaign_name']+'</td>';
							row_html += '<td class="text-center">';
							row_html += '<a href="/contact_campaign_history.php?id='+result.data[0]['contact_id']+'&c='+result.data[0]['campaign_id']+'" class="btn btn-info btn-xs" style="margin-right: 4px;"><i class="fa fa-history"></i>History</a>';
							if (result.data[0]['is_onhold'] == 1) {
								row_html += '<a href="javascript:void(0)" data-ccid="'+result.data[0]['campaign_id']+'" class="btn btn-success btn-xs resume-campaign"><i class="fa fa-play"></i> Resume</a></td>';
							}
							else {
								row_html += '<a href="javascript:void(0)" data-ccid="'+result.data[0]['campaign_id']+'" class="btn btn-danger btn-xs  stop-campaign"><i class="fa fa-stop"></i> Stop</a></td>';
							}
							row_html += '</tr>';

							$("#campaignTbl tbody").append(row_html);

                        	flash_alert('#alert_success_campaign', 'Subscribed to a Campaign.');
                        	$('#modal-add-campaign').modal('hide');
						}

					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					}
				});
			}
		});

		$(document).on("click", '.stop-campaign',function(){
			var campaign_id = $(this).attr("data-ccid");
			var element = this;

			$.ajax({
				type: "POST",
				url: '/ws/campaigns/stop',
				data: { 'id': {$contact_data.contact_id}, 'campaign': campaign_id },
				dataType: "json",
				success: function(result) {
					if (result.msg == "User Not Related") {
                    	$('#modal-add-campaign').modal('hide');
                    	flash_alert('#alert_error_campaign', "User is not related on the contact.");
					}
					else if(result.msg) {
						$(element).removeClass("btn-danger");
						$(element).addClass("btn-success");
						$(element).removeClass("stop-campaign");
						$(element).addClass("resume-campaign");
						$(element).text("Resume");
						$(element).html('<i class="fa fa-play"></i> Resume');
                        flash_alert('#alert_success_campaign', 'Stopped Campaign.');
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				}
			});
		});

		$(document).on("click", '.resume-campaign',function(){
			var campaign_id = $(this).attr("data-ccid");
			var element = this;

			$.ajax({
				type: "POST",
				url: '/ws/campaigns/resume',
				data: { 'id': {$contact_data.contact_id}, 'campaign': campaign_id },
				dataType: "json",
				success: function(result) {
					if (result.msg == "User Not Related") {
                    	$('#modal-add-campaign').modal('hide');
                    	flash_alert('#alert_error_campaign', "User is not related on the contact.");
					}
					else if(result.msg) {
						$(element).addClass("btn-danger");
						$(element).removeClass("btn-success");
						$(element).addClass("stop-campaign");
						$(element).removeClass("resume-campaign");
						$(element).html('<i class="fa fa-stop"></i> Stop');
                        flash_alert('#alert_success_campaign', 'Resumed Campaign.');
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				}
			});
		});
		/************************************************ End-Campaign Section ************************************************/
		{/if}


		// $("#companies").on("change", function(){
		// 	var company_id = $(this).find(":selected").val();

		// 	$.ajax({
		// 		type: "POST",
		// 		url: '/services/dropdown_changed.php',
		// 		data: { 'company_id': company_id },
		// 		dataType: "json",
		// 		success: function(result) {
		// 			console.log(result);
		// 			$("#users").html("");
		// 			$("#users").prop("disabled", false);
		// 			$("#users").append('<option value="">Select User</option>');
		// 			var temp = JSON.parse(JSON.stringify(result));
		// 			$.each(temp.data, function(index, val) {
		// 				console.log(index + " " + val.user_id);
		// 				$("#users").append('<option value=' + val.user_id + '>' + val.first_name + ' ' + val.last_name + '</option>');
		// 			});
		// 		},
		// 		error: function (XMLHttpRequest, textStatus, errorThrown) {
		// 			console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus);
		// 		}
		// 	});
		// });

		// $('.material-button-toggle').on("click", function () {
	 //        $(this).toggleClass('open');
	 //        $('.option').toggleClass('scale-on');
	 //        $('.option').toggleClass('hidden');
	 //        $('#floating-options').toggleClass('hidden');
	 //    });

		$("#floating-options").click(function() {
			$("#mini-fab").toggleClass('hidden');
			$(this).toggleClass('open');
		});


		/************************************************ Start-Time To Action Section ************************************************/
		$("#btn-set-time-to-action").click( function() {
			console.log("setting time to action");
			$("#form-set-time-to-action").submit();
			$("#form-set-time-to-action input[type!='hidden']").val("");
		});

		$("#form-set-time-to-action").on("submit", function(e){
			e.preventDefault();
			if ( checkGroup('time-to-action', '#error-time-to-action') ) {
				var target = $('#form-set-time-to-action').closest('.panel');

				$.ajax({
					type: "POST",
					url: '/ws/contact/set_time_to_action',
					data: $(this).serialize(),
					dataType: "json",
				    beforeSend: function() {
				        if (!$(target).hasClass('panel-loading')) {
				            var targetBody = $(target).find('.panel-body');
				            var spinnerHtml = '<div class="panel-loader"><span class="spinner-small"></span></div>';
				            $(target).addClass('panel-loading');
				            $(targetBody).prepend(spinnerHtml);
				        }
				    },
					success: function(result) {
						console.log(result);

						if (result.msg) {

							$('.progress-bar').attr('aria-valuenow', 0).css('width', 0);
							$('.progress-bar span').text(result.time_left+" left");

                    		flash_alert('#alert-success-action', 'Saved time to action');

						}
						else {
							window.location = "contacts_edit.php?id={$contact_data.contact_id}&code=1x007";
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					},
				    complete: function() {
				    	$("#modal-set-time-to-action").modal('hide');
			            $(target).removeClass('panel-loading');
			            $(target).find('.panel-loader').remove();
				    }
				});
			}
			else {
				// add parsley-error
				console.log('invalid');
				$("input[data-parsley-group='time-to-action']").addClass('parsley-error');
			}
		});

		/************************************************ End-Time To Action Section ************************************************/

		$(document).ready(function(){
		    $('[data-toggle="tooltip"]').tooltip();
		});

	});
</script>

{include file="includes/modal_contact_send_email.tpl"}
{include file="includes/modal_send_letter.tpl"}
