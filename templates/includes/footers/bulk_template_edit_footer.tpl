<script src="assets/plugins/summernote/summernote.min.js"></script>

<script type="text/javascript">
	$(document).ready(function(){

		$('#summernote_body').summernote({
			placeholder: 'Please enter email message template',
			height: "300px"
		});

		$('#summernote_body').on('summernote.change', function(we, contents, $editable) {
			$("#template_body").text(contents);
		});

		$('.template-parameters').on('click', function() {
			$('#summernote_body').summernote('editor.saveRange');
			$('#summernote_body').summernote('editor.restoreRange');
			$('#summernote_body').summernote('editor.focus');
			$('#summernote_body').summernote('editor.insertText', '%'+$(this).text()+'%');
		});

        $('#check_shared').on("click", function(){
            var is_checked = $(this).prop("checked");

            if(is_checked) {
                is_shared = 1;
            }
            else {
                is_shared = 0;
            }

            $('#template_shared').val(is_shared);
        });

        $('#check_active').on("click", function(){
            var is_checked = $(this).prop("checked");

            if(is_checked) {
                is_active = 1;
            }
            else {
                is_active = 0;
            }

            $('#template_active').val(is_active);
        });

	});
</script>