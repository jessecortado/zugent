<script src="assets/plugins/summernote/summernote.min.js"></script>
<script src="assets/plugins/select2/dist/js/select2.min.js"></script>

<script type="text/javascript">
	$(document).ready(function() {

        $('#share-level').select2({
            placeholder: "Select Share Level"
        });

    	$(document).ready(function() {
    		if($("#is-active").val() == 1) {
    			$("#chk-is-active").prop("checked", true);
    		}
    		else {
    			$("#chk-is-active").prop("checked", false);
    		}
    	});

    	$('#summernote').summernote({
    		placeholder: 'Give this pool a description',
    		height: "300px"
    	});

    	$('#summernote').on('summernote.change', function(we, contents, $editable) {
			$("#description").html(contents);
			console.log($("#description").html(contents));
		});

		$('#save-pool').click(function(){
			console.log("help");
			$("#form-pool").submit();
		});

		$('#state').val('{$user.state}');

		$(document).on("click", "#chk-is-active", function(){
			if($(this).is(":checked") == true) {
				$("#is-active").val("1");
			}
			else {
				$("#is-active").val("0");
			}
		});

		if($("#chk-is-active").is(":checked") == true) {
				$("#is-active").val("1");
		}
		else {
				$("#is-active").val("0");
		}

    });
</script>