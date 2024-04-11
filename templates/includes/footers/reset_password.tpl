<script src="assets/plugins/password-indicator/js/password-indicator.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		PasswordIndicator.init();

		window.Parsley.addAsyncValidator('validatePassword', function (xhr) {
		    var response = xhr.responseText;
		    
		    if (response == '200') {
		        return true;
		    } else {
		        return false;
		    }
		}, '/reset_password.php');
	});
</script>