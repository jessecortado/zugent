<script src = "assets/plugins/parsley/dist/parsley.js" > </script> 
<script src = "assets/plugins/bootstrap-wizard/js/bwizard.js"> </script>
{* <script src="assets/plugins/jquery-simplecolorpicker/jquery.simplecolorpicker.js"></script> *}
<script src="assets/plugins/bootstrap-colorpicker/js/bootstrap-colorpicker.min.js"></script>
<script src="/assets/plugins/select2/dist/js/select2.full.min.js"></script>


	<script type = "text/javascript">

	$(document).ready(function () {

		$("select").select2({ placeholder:'Please select one', width:'100%'});

    	$('.colorpicker')
			.colorpicker({ format: 'hex' })
			.on("changeColor", function() {
			console.log("generating");
			generate_image();
		});

		var b_image, frame, header, sub_header, invert_layers, header_font_size, sub_header_font_size, header_color, sub_header_color, header_offset, sub_header_offset;
		var saved_frame, saved_image;

		function generate_image() {
			$("#preview-image").remove();
			var imgString = '<img id="preview-image" class="" src="services/generate_media/generate_media.php?' +
			'b_image=' + b_image + 
			'&frame=' + frame + 
			'&header=' + header + 
			'&sub_header=' + sub_header;
			if ($("#header-font-size").val() !== "")
				imgString += '&header_font_size=' + $("#header-font-size").val();
			if ($("#sub-header-font-size").val() !== "")
				imgString += '&sub_header_font_size=' + $("#sub-header-font-size").val();
			if ($("#header-color").val() !== "")
				imgString += '&header_color=' + $("#header-font-color").val().replace("#","");
			if ($("#sub-header-font-color").val() !== "")
				imgString += '&sub_header_color=' + $("#sub-header-font-color").val().replace("#","");
			if ($("#header-offset").val() !== "")
				imgString += '&header_offset=' + $("#header-offset").val();
			if ($("#sub-header-offset").val() !== "")
				imgString += '&sub_header_offset=' + $("#sub-header-offset").val();
				
			imgString += '&invert_layers='+ invert_layers +'" alt="GD Library Example Image" style="width:100%; height:auto;">';

			$("#preview-area").prepend(imgString);
		}
  
		// Remove validation for now
		$("#wizard").bwizard({
			clickableSteps: false,
			activeIndexChanged: function (e, ui) {
				console.log(ui);
				if (ui.index == 3)
					$("#generate-preview").click();
			} 
		});

		// For validation
		{* $("#wizard").bwizard({
				clickableSteps: false,
				validating: function (e, ui) {
					if (ui.index == 0) {
						// step-1 validation
						if (false === $('form[name="form-wizard"]').parsley().validate('wizard-step-1')) {
							return false;
						}
					} else if (ui.index == 1) {
						// step-2 validation
						if (false === $('form[name="form-wizard"]').parsley().validate('wizard-step-2')) {
							return false;
						}
					} else if (ui.index == 2) {
						// step-3 validation
						if (false === $('form[name="form-wizard"]').parsley().validate('wizard-step-3')) {
							return false;
						}
					}
				}
			}); *}

		$("#form-media").on("submit", function (e) {
			e.preventDefault();

			var target = $('#preview-section').closest('.panel');

			$("#save").val("1");
			$.ajax({
				type: "POST",
				url: '/services/generate_media/generate_media.php',
				data: {
					"b_image" : b_image,
					"frame" : frame,
					"header" : $("#header").val(),
					"sub_header" : $("#sub-header").val(),
					"media_name" : $("#media-name").val(),
					"invert_layers" : invert_layers,
					"header_color" : $("#header-font-color").val(),
					"sub_header_color" : $("#sub-header-font-color").val(),
					"header_font_size" : $("#header-font-size").val(),
					"sub_header_font_size" : $("#sub-header-font-size").val(),
					"header_offset" : $("#header-offset").val(),
					"sub_header_offset" : $("#sub-header-offset").val()
				},
				dataType: "json",
				beforeSend: function () {
					if (!$(target).hasClass('panel-loading')) {
						var targetBody = $(target).find('.panel-body');
						var spinnerHtml = '<div class="panel-loader"><span class="spinner-small"></span></div>';
						$(target).addClass('panel-loading');
						$(targetBody).prepend(spinnerHtml);
					}
				},
				success: function (result) {
					console.log(result);
					if (result.result) {

						$("#preview-section").addClass("hide");
					}


			        $(target).removeClass('panel-loading');
			        $(target).find('.panel-loader').remove();
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				}
			});

		});

		$("#generate-preview").on("click", function (e) {
			e.preventDefault();
			$("#save").val("0");
			console.log("generating");
			$("#preview-area img").remove();

			var target = $('#preview-section').closest('.panel');
			var formData = new FormData($('#form-media')[0]);
			formData.append('saved_frame', saved_frame);
			formData.append('saved_image', saved_image);
			formData.append('image_url', $("#modal-image .selected").children('img').attr('src'));
			formData.append('frame_url', $("#modal-frame .selected").children('img').attr('src'));

			$.ajax({
				type: "POST",
				url: '/services/generate_media/upload_images.php',
				data:  formData,
				processData: false,
				contentType: false,
				dataType: "json",
				beforeSend: function () {
					if (!$(target).hasClass('panel-loading')) {
						var targetBody = $(target).find('.panel-body');
						var spinnerHtml = '<div class="panel-loader"><span class="spinner-small"></span></div>';
						$(target).addClass('panel-loading');
						$(targetBody).prepend(spinnerHtml);
					}
				},
				success: function (result) {
					console.log(result);

					if (saved_image)
						b_image = $("#modal-image .selected").children('img').attr('src');
					else
						b_image = result.bg_image;
					if (saved_frame)
						frame = $("#modal-frame .selected").children('img').attr('src');
					else
						frame = result.frame;
						
					header = result.header
					sub_header = result.sub_header;
					select_from_mls = $("#select-from-mls").val();
					
					$("#header-font-size").val(result.header_font_size);
					$("#sub-header-font-size").val(result.sub_header_font_size)
					$("#header-offset").val(result.offset_header);
					$("#sub-header-offset").val(result.offset_sub_header);

					if (result.result) {
						$("#preview-section").removeClass("hide");
						invert_layers = false;

						var imgString = $('<img id="preview-image" class="" src="services/generate_media/generate_media.php?b_image=' + b_image + '&frame=' + frame + '&header=' + result.header + '&sub_header=' + result.sub_header + '&invert_layers=0" alt="GD Library Example Image" style="width:100%; height:auto;">').on('load', function() {
							console.log("finished fetching generated image");
							$("#preview-area").prepend(imgString);

			                $(target).removeClass('panel-loading');
			                $(target).find('.panel-loader').remove();
							$(".media-details").removeClass('hide');
						});

					} else {
						$("#preview-section").removeClass("hide");

						invert_layers = true;

						var imgString = $('<img id="preview-image" class="" src="services/generate_media/generate_media.php?b_image=' + b_image + '&frame=' + frame + '&header=' + result.header + '&sub_header=' + result.sub_header + '&invert_layers=1" alt="GD Library Example Image" style="width:100%; height:auto;">').on('load', function() {
							console.log("finished fetching generated image");
							$("#preview-area").prepend(imgString);

			                $(target).removeClass('panel-loading');
			                $(target).find('.panel-loader').remove();
						});

						{* alert("The background image is smaller than the frame"); *}
					}

				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				}
			});
		});

		$(document).on("load", "#preview-image",function () {
			console.log("loaded");
		});

		$(".image-details, .image-offset").on("change", function() {
			console.log("generating");
			generate_image();
		});

		$("#modal-frame .img-box").on("click", function() {
			$("#modal-frame .img-box").removeClass("selected");
			$(this).addClass("selected");
		});

		$("#frame").on("change", function () {
			if ($(this).val().length > 0) {
				saved_frame = false;
			}
		});

		$("#modal-save-frame").on("click", function() {
			saved_frame = true;
			$("#selected-frame-name").text($('#modal-frame .selected').children('h4').text());
		});

		$("#modal-image .img-box").on("click", function() {
			$("#modal-image .img-box").removeClass("selected");
			$(this).addClass("selected");
		});

		$("#b-image").on("change", function () {
			if ($(this).val().length > 0) {
				saved_image = false;
			}
		});

		$("#modal-save-image").on("click", function() {
			saved_image = true;
			$("#selected-image-name").text($('#modal-image .img-box.selected').children('h4').text());
		});

		$("li.next a").on("click", function() {

		});

	});

	</script>