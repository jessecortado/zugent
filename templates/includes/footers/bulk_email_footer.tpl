<script src="/assets/plugins/select2/dist/js/select2.full.min.js"></script>
<script src="assets/plugins/sweetalert2/js/sweetalert2.all.min.js"></script>
<script src="assets/plugins/bootstrap-tagsinput/bootstrap-tagsinput.min.js"></script>
<script src="assets/plugins/bootstrap-tagsinput/bootstrap-tagsinput-typeahead.js"></script>
<script src="assets/plugins/jquery-tag-it/js/tag-it.min.js"></script>
<script src="assets/plugins/summernote/summernote.min.js"></script>

<script type="text/javascript">

	var timeo, removed_tags = [], contacts = [], filters = [];

    function flash_alert(element, msg) {
        $('#alert_error').addClass('hide');
        $(element+' span#msg').text(msg);
        $(element).removeClass('hide');
        $(element).css('opacity', '1');
        $(element).css('display', 'block');
        window.setTimeout(function() {
          $(element).fadeTo(500, 0).slideUp(500, function(){
              $(element).addClass('hide');
          });
        }, 2000);
    }

	function enableFilter(checkbox, input) {
        var is_checked = $(checkbox).prop("checked");

        if(is_checked) {
        	$(input).attr("disabled", false);
        }
        else {
        	$(input).attr("disabled", true);
        	$(input).val('');
        	getTotalContacts();
        }

        $(input).parsley().reset();
	}

	function getTotalContacts() {
		$('#userNameFriend').tagit('assignedTags')
        
		$.ajax({
			type: "POST",
			url: '/ws/email/fetch_contacts',
			data: $('#form-send-bulk-email').serialize(),
			dataType: "json",
			success: function(result) {
				console.log(result);

				if (result.msg) {
					contacts = [], filters = [];
					$('#contacts_selected').text(result.total_count + ' contact/s will receive this email.');

					$.each( result.contacts_details, function( i, val ) {
						contacts.push(val);
					});

					filters = result.filters;
				}
				else {
					window.location = "dashboard.php?code=1xbe7";
				}
			},
			error: function (XMLHttpRequest, textStatus, errorThrown) {
				console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
			}
		});

	}

	$(document).ready(function() {

        getTotalContacts();

        $("#contact_tags").tagit({
        	fieldName: "contact_tags[]",
            availableTags: {$tags|json_encode},
            caseSensitive: false,
            afterTagAdded: function(event, ui) {
	        	getTotalContacts();
            },
            beforeTagRemoved: function(event, ui) {
                // console.log(ui.tag[0].firstElementChild.innerText);
                removed_tags.push(ui.tag[0].firstElementChild.innerText);
            },
            afterTagRemoved: function(event, ui) {
	        	getTotalContacts();
            }
        });

        $('.ui-autocomplete-input').prop('disabled', true).val('');
        $('.tagit-choice').remove();
        $('.ui-widget-content').attr('style', 'background: #e5e9ed !important; opacity: .6');

		$("#email_template").select2({ placeholder:'Please select a template', width:'100%'});

		$('#summernote_body').summernote({
			placeholder: 'Please select a template',
			height: "300px"
		});

		$('#summernote_body').on('summernote.change', function(we, contents, $editable) {
			$("#mail_body").text(contents);
		});

        $('#summernote_body').summernote('disable');

		$('.template-parameters').on('click', function() {
			$('#summernote_body').summernote('editor.saveRange');
			$('#summernote_body').summernote('editor.restoreRange');
			$('#summernote_body').summernote('editor.focus');
			$('#summernote_body').summernote('editor.insertText', '%'+$(this).text()+'%');
		});

        $('#email_template').on('change', function() {
			$.ajax({
				type: "POST",
				url: '/ws/email/get_template',
				data: { 'bulk_template_id' : $(this).val() },
				dataType: "json",
				success: function(result) {
					console.log(result);

					if (result.msg) {
						$('#mail_subject').val(result.template[0]['subject']);
						$('#summernote_body').summernote("code", result.template[0]['body']);
					}
					else {
						window.location = "dashboard.php?code=1xbe7";
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				}
			});
        });

        $('#check_company_contacts').on("click", function(){
        	getTotalContacts();
        });

        $('#check_bucket').on("click", function(){
        	enableFilter(this, "#contact_bucket");
        });

        $('#check_tag').on("click", function(){
	        var is_checked = $(this).prop("checked");

	        if(is_checked) {
		        $('.ui-autocomplete-input').prop('disabled', false);
		        $('.ui-widget-content').attr('style', 'background: #fff !important; opacity: 1');
	        }
	        else {
		        $('.ui-autocomplete-input').prop('disabled', true).val('');
		        $('.tagit-choice').remove();
		        $('.ui-widget-content').attr('style', 'background: #e5e9ed !important; opacity: .6');
	        	getTotalContacts();
	        }
        });

        $('#check_city').on("click", function(){
        	enableFilter(this, "#contact_city");
        });

        $('#check_county').on("click", function(){
        	enableFilter(this, "#contact_county");
        });

        $('#check_zip').on("click", function(){
        	enableFilter(this, "#contact_zip");
        });

        $('#contact_bucket').on("input", function(){
	        clearTimeout(timeo);
	        timeo = setTimeout(getTotalContacts, 500);
        });

        $('#contact_city').on("input", function(){
	        clearTimeout(timeo);
	        timeo = setTimeout(getTotalContacts, 500);
        });

        $('#contact_county').on("input", function(){
	        clearTimeout(timeo);
	        timeo = setTimeout(getTotalContacts, 500);
        });

        $('#contact_zip').on('input', function(){
	        clearTimeout(timeo);
	        timeo = setTimeout(getTotalContacts, 500);
	    });

        $("#btn-add-new-template").click(function() {
			$("#form-new-template").submit();
		});

        $("#form-new-template").on("submit", function(e){
			e.preventDefault();
			if ( $(this).parsley().isValid() ) {
				$.ajax({
					type: "POST",
					url: '/ws/email/new_template',
					data: $(this).serialize(),
					dataType: "json",
					success: function(result) {
						console.log(result);

						if (result.msg) {
							window.location = "bulk_template_edit.php?id="+result.bulk_template_id;
						}
						else {
							window.location = "dashboard.php?code=1xbe7";
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


        $("#btn-send-bulk-mail").click(function() {
			$("#form-send-bulk-email").submit();
		});

        $("#form-send-bulk-email").on("submit", function(e){
			e.preventDefault();
			if ( $(this).parsley().isValid() ) {
				if ($("#mail_body").text() != '') {
					$.ajax({
						type: "POST",
						url: '/ws/email/send_queue',
						data: {
							'email_template': $('#email_template').val(),
							'email_subject': $('#mail_subject').val(),
							'email_body': $('#mail_body').text(),
							'contacts': contacts,
							'filters': filters
						},
						dataType: "json",
						success: function(result) {
							console.log(result);

							if (result.msg) {
								flash_alert("#alert_success", "Added to bulk email queue.");
								window.location = "bulk_email_history.php";
							}
							else {
								$('#alert_error').removeClass('hide');
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
				else {
					swal('Message is empty!', 'Please enter a message.', 'error');
				}
			}
		});

	});
</script>