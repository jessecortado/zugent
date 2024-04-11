<script src="assets/plugins/sweetalert2/js/sweetalert2.all.min.js"></script>

<script type="text/javascript">

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
    
	$(document).ready(function() {

		$(".delete-template").click(function() {
			var template_id = $(this).attr("data-id");
			swal({
				title: 'Are you sure?',
				text: "You won't be able to revert this!",
				type: 'warning',
				showCancelButton: true,
				confirmButtonColor: '#3085d6',
				cancelButtonColor: '#d33',
				confirmButtonText: 'Yes, delete it!',
				cancelButtonText: 'No, cancel!',
				confirmButtonClass: 'btn btn-success',
				cancelButtonClass: 'btn btn-danger m-r-10',
				buttonsStyling: false,
				reverseButtons: true
			}).then(function () {

				$.ajax({
					type: "POST",
					url: '/ws/user/email/delete_template',
					data: { 'action':'delete_email_template', 'user_email_template_id':template_id },
					dataType: "json",
					success: function(result) {
						console.log(result);

						if (result) {
							swal({
								title: 'Deleted!',
								text: 'Email template has been deleted.',
								type: 'success'
							}).then(function () {
								location.reload();
							});
						}
						else {
							window.location = "dashboard.php?code=1xue7";
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					}
				});

			}, function (dismiss) {});
		});
		
        $("#btn-add-new-template").click(function() {
			$("#form-new-template").submit();
		});

        $("#form-new-template").on("submit", function(e){
			e.preventDefault();
			if ( $(this).parsley().isValid() ) {
				$.ajax({
					type: "POST",
					url: '/ws/user/email/new_template',
					data: $(this).serialize(),
					dataType: "json",
					success: function(result) {
						console.log(result);

						if (result.msg) {
							window.location = "user_email_template_edit.php?id="+result.user_email_template_id;
						}
						else {
							window.location = "dashboard.php?code=1xue7";
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					}
				});
			}
		});

        $(".stm").on("click", function() {
        	var template_id = $(this).attr('data-tid');

			$.ajax({
				type: "POST",
				url: '/ws/user/email/test',
				data: { 'template_id': template_id},
				dataType: "json",
				success: function(result) {

					if (result) {
						flash_alert("#alert_success", "Test Email Sent!");
					}
					else {
						window.location = "dashboard.php?code=1xue7";
					}
					
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				}
			});
        });

	});
</script>