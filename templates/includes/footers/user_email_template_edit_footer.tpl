<script src="assets/plugins/summernote/summernote.min.js"></script>
<script src="assets/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>

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

		$('#template_type_email, #template_type_letter').on('change', function() {
			var x = ($(this).attr("checked")) ? 1 : 0;
			$(this).val(x);
		});
	});
</script>