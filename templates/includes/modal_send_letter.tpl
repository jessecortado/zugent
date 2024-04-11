<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
<link href="assets/plugins/summernote/summernote.css" rel="stylesheet" />
<!-- <link href="assets/plugins/summernote/summernote-lite-flatly.min.css" rel="stylesheet" /> -->

<style type="text/css">
    .checkbox-css label:before,
    .checkbox-css label:after {
        left: 5px !important;
        top: 0 !important;
    }
</style>

<div class="modal fade" id="xmodal-send-letter" style="display: none;">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Send Letter</h4>
			</div>
			<div class="panel" style="margin-bottom:0;">
				<div class="modal-body panel-body p-20">
					<form id="xform-send-letter" method="post" data-parsley-validate="true" data-parsley-excluded="[disabled=disabled]">

						<div class="row">
							<div class="col-md-12">
								<label class="control-label">Letter Template</label>
								<div class="form-group">
									<div style="width:100%;" class="input-group">
										<select id="xuser_letter_template" class="form-control" data-parsley-required="true" data-parsley-errors-container="#xuserletter-template-error">
											<option value="">Select a Template</option>
											{foreach from=$user_letter_templates item='row'}
											<option value="{$row.user_email_template_id}">{$row.template_name}</option>
											{/foreach}
										</select>
										<div id="xuserletter-template-error"></div>
									</div>
								</div>
							</div>
						</div>

						<div id="preview-pdf">
							<embed src="assets/pdfs/preview_letter.pdf" width="100%" height="500px" />
						</div>

						<input type="hidden" name="contact_id" value="{$contact_data.contact_id}"/>
					</form>
				</div>
			</div>
			<div class="modal-footer">
				<a id="xclose-send-letter-modal" href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a id="xbtn-send-letter" href="javascript:void(0)" class="btn btn-sm btn-success"><i class="fa fa-send"></i> Send</a>
			</div>
		</div>
	</div>
</div>


<script src="assets/plugins/sweetalert2/js/sweetalert2.all.min.js"></script>
<script src="assets/plugins/select2/dist/js/select2.full.min.js"></script>

<script type="text/javascript">
	// Note:
	// ".xbtn-sec" = email icon button below
	// <a href="#xmodal-send-message" class="btn btn-info btn-fab xbtn-sec" data-toggle="modal"><span class="fa fa-envelope-o" aria-hidden="true"></span></a>
	// "#xmodal-send-message" = modal/form

	$(document).ready(function() {
		// FormSummernote.init();

		var contact_id;
		var template_id;
		var bcc_me = true;
		$("#preview-pdf").css('display', 'none');

		$("#xuser_letter_template").select2({ placeholder:'Please select a template', width:'100%'});

		$(".xbtn-sec").click(function() {
			contact_id = $(this).attr("data-cid");
		});

        $('#xuser_letter_template').on('change', function() {
	        var uetval = $(this).select2('val');
			var target = $('#preview-pdf').closest('.panel');
        	if (uetval != " " && uetval != "") {
				$.ajax({
					type: "POST",
					url: '/ws/user/email/letter_template',
					data: { 'user_letter_template_id' : $(this).val() },
				    beforeSend: function() {
				    	$("#xbtn-send-letter").attr("disabled", true);
				        if (!$(target).hasClass('panel-loading')) {
				            var targetBody = $(target).find('.panel-body');
				            var spinnerHtml = '<div class="panel-loader"><span class="spinner-small"></span></div>';
				            $(target).addClass('panel-loading');
				            $(targetBody).prepend(spinnerHtml);
				        }
				    },
					success: function(result) {
						console.log(result);
						$('#xform-send-letter').parsley().reset();
						template_id = uetval;
				    	$("#xbtn-send-letter").removeAttr("disabled");
						$("#preview-pdf").css('display', 'block');
						$("#preview-pdf").html('<embed src="assets/pdfs/preview_letter.pdf" width="100%" height="500px" />');
		                $(target).removeClass('panel-loading');
		                $(target).find('.panel-loader').remove();
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					}
				});
        	}
        });

        $("#xbtn-send-letter").click(function() {
			$("#xform-send-letter").submit();
		});

		$('#xmodal-send-letter').on('hidden.bs.modal', function () {
			// $("#xuser_letter_template").select2("val", "");
			$("#xuser_letter_template").val('').trigger('change');
			$("#preview-pdf").css('display', 'none');
		});

        $("#xform-send-letter").on("submit", function(e){
			e.preventDefault();
			var target = $('#preview-pdf').closest('.panel');
			if ( $(this).parsley().isValid() ) {
				$.ajax({
					type: "POST",
					url: '/ws/user/email/send_letter',
					data: {
						'contact_id': contact_id,
						'user_letter_template_id': template_id
					},
					dataType: 'json',
				    beforeSend: function() {
				    	$("#xbtn-send-letter").attr("disabled", true);
				        if (!$(target).hasClass('panel-loading')) {
				            var targetBody = $(target).find('.panel-body');
				            var spinnerHtml = '<div class="panel-loader"><span class="spinner-small"></span></div>';
				            $(target).addClass('panel-loading');
				            $(targetBody).prepend(spinnerHtml);
				        }
				    },
					success: function(result) {
		                $(target).removeClass('panel-loading');
		                $(target).find('.panel-loader').remove();

						if (result.msg) {
							swal('Letter Sent!', 'Sent a letter on contact.', 'success');
				    		$("#xmodal-send-letter").modal('hide');
						}
						else {
							swal('Letter Not Sent!', 'Something went wrong.', 'error');
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					}
				});
			}
		});

	});
</script>