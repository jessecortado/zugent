<script src="assets/plugins/dropzone/dropzone.js"></script>
<script src="/assets/plugins/select2/dist/js/select2.min.js"></script>
<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
<script src="assets/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>

<script type="text/javascript">
    $("#cupload-email-header").hide();

	$(document).ready(function() {
	    $("#state").val('{$company.state}');
	    $("#state").select2({ width: "100%" });
	    $("#timezone").select2({ width: "100%" });

		$('#allow_agents_email_logo').on('change', function() {
			var x = ($(this).attr("checked")) ? 1 : 0;
			$(this).val(x);
		});

        Dropzone.options.cemailHeader = {
            autoProcessQueue: false,
            uploadMultiple: false,
            maxFiles: 1,
            init: function() {
                var submitButton = $("#cupload-email-header");
                cemailHeader = this;
                submitButton.on("click", function() {
                    $("#page-loader").append("<p style='position:absolute; top: 70%; left: 46.5%; margin: -20px 0 0 -20px;'>Processing Company Email Header Photo</p>");
                    $("#page-loader").removeClass('hide');
                    cemailHeader.processQueue(); 
                });
                this.on("addedfile", function() {
                    $("#cupload-email-header").show();
                });
                this.on("complete", function (file) {
                    if (this.getUploadingFiles().length === 0 && this.getQueuedFiles().length === 0) {
                        console.log("done");
                        window.location = "settings.php";
                    }
                });

            },
            success: function(file, response){
            	console.log(response);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                $.log('XHR ERROR ' + XMLHttpRequest.status);
            }
        };
	});
</script>