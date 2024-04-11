<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
<link href="assets/plugins/summernote/summernote.css" rel="stylesheet" />

<style type="text/css">
    .checkbox-css label:before,
    .checkbox-css label:after {
        left: 5px !important;
        top: 0 !important;
    }
</style>

<div class="modal fade" id="xmodal-send-message" style="display: none;">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Send Message</h4>
			</div>
			<div class="modal-body p-20">
				<form id="xform-send-email" method="post" data-parsley-validate="true" data-parsley-excluded="[disabled=disabled]">

					<div class="row">
						<div class="col-md-3">
							<div class="form-group">
								<label class="control-label">Options</label>

		                        <div class="checkbox checkbox-css checkbox-success">
				                    <input id="xis_usetemp" type="checkbox" checked="true">
				                    <label for="xis_usetemp"> Use a Template</label>
				                </div>

		                        <div class="checkbox checkbox-css checkbox-success">
				                    <input id="xis_bccme" type="checkbox" checked="true">
				                    <label for="xis_bccme"> BCC Me</label>
				                </div>
							</div>
						</div>
						<div class="col-md-9">
							<label class="control-label">Email Template</label>
							<div class="form-group">
								<div style="width:100%;" class="input-group">
									<select id="xuser_email_template" name="user_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#xuseremail-template-error">
										<option value="">Select a Template</option>
										{foreach from=$user_email_templates item='row'}
										<option value="{$row.user_email_template_id}">{$row.template_name}</option>
										{/foreach}
									</select>
									<div id="xuseremail-template-error"></div>
								</div>
							</div>
						</div>
					</div>

					<div class="form-group">
						<label for="mail_subject">Subject:</label>
						<input type="text" class="form-control" name="mail_subject" id="xmail_subject" placeholder="Email Subject" data-parsley-required="true" style="opacity: 1;" disabled>
					</div>

					<div class="form-group">
						<label for="mail_body">Message:</label>
                        <div id="xsummernote_body"></div>
						<textarea name="mail_body" id="xmail_body" class="form-control" rows="2" style="display:none;"></textarea>
					</div>

					<input type="hidden" name="contact_id" value="{$contact_data.contact_id}"/>
				</form>
			</div>
			<div class="modal-footer">
				<a id="xclose-add-modal" href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a id="xbtn-send-message" href="javascript:void(0)" class="btn btn-sm btn-success"><i class="fa fa-send"></i> Send</a>
			</div>
		</div>
	</div>
</div>


<script src="assets/plugins/select2/dist/js/select2.full.min.js"></script>
<!-- <script src="assets/plugins/sweetalert2/js/sweetalert2.all.min.js"></script> -->
<script src="assets/plugins/summernote/summernote.min.js"></script>

<script type="text/javascript">
	// Note:
	// ".xbtn-sec" = email icon button below
	// <a href="#xmodal-send-message" class="btn btn-info btn-fab xbtn-sec" data-toggle="modal"><span class="fa fa-envelope-o" aria-hidden="true"></span></a>
	// "#xmodal-send-message" = modal/form

	$(document).ready(function() {
		// FormSummernote.init();

		var contact_id;
		var bcc_me = true;

		$("#xuser_email_template").select2({ placeholder:'Please select a template', width:'100%'});

		$(".xbtn-sec").click(function() {
			contact_id = $(this).attr("data-cid");
		});

		$('#xsummernote_body').summernote({
			placeholder: 'Please select a template',
			height: "150px"
		});

		$('#xsummernote_body').on('summernote.change', function(we, contents, $editable) {
			$("#xmail_body").text(contents);
		});

        $('#xsummernote_body').summernote('disable');

        $('#xis_usetemp').on('change', function() {
	        var is_checked = $(this).prop("checked");
        	if (is_checked) {
	        	$('#xuser_email_template').removeAttr('disabled');
	        	$('#xmail_subject').attr('disabled', 'true');
	        	$('#xsummernote_body').summernote('disable');
	        	$('#xmail_subject').val("");
        		$("#xuser_email_template").select2('val', " ");
	        	$('#xsummernote_body').summernote("code", "");
        	}
        	else {
	        	$('#xuser_email_template').attr('disabled', 'true');
	        	$('#xmail_subject').removeAttr("disabled");
	        	$('#xsummernote_body').summernote('enable');
	        	$('#xmail_subject').val("");
        		$("#xuser_email_template").select2('val', " ");
	        	$('#xsummernote_body').summernote("code", "");
        	}
        });

        $('#xis_bccme').on('change', function() {
	        var is_checked = $(this).prop("checked");
        	if (is_checked) {
        		bcc_me = true;
        	}
        	else {
        		bcc_me = false;
        	}
        	$("#xform-send-email").parsley().reset();
        });

        $('#xuser_email_template').on('change', function() {
	        var uetval = $(this).select2('val');
        	if (uetval != " " && uetval != "") {
				$.ajax({
					type: "POST",
					url: '/ws/user/email/get_template',
					data: { 'user_email_template_id' : $(this).val() },
					dataType: "json",
					success: function(result) {
						console.log(result);

						if (result.msg) {
							$('#xmail_subject').val(result.template[0]['subject']);
							$('#xsummernote_body').summernote("code", result.template[0]['message']);
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
        });

        $("#xbtn-send-message").click(function() {
			$("#xform-send-email").submit();
		});

        $("#xform-send-email").on("submit", function(e){
			e.preventDefault();
			if ( $(this).parsley().isValid() ) {
				if ($("#xmail_body").text() != '') {
					$.ajax({
						type: "POST",
						url: '/ws/user/email/send_mail',
						data: {
							'email_subject': $('#xmail_subject').val(),
							'email_body': $('#xmail_body').text(),
							'contact_id': contact_id,
							'bcc_me': bcc_me
						},
						dataType: "json",
						success: function(result) {
							console.log(result);

							if (result.msg) {
								swal('Email Sent!', 'Sent an email on contact.', 'success');
							}
							else {
								$('#alert_error').removeClass('hide');
							}
						},
						error: function (XMLHttpRequest, textStatus, errorThrown) {
							console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
						},
					    complete: function() {
					    	$("#xmodal-send-message").modal('hide');
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