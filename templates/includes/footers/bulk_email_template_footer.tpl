
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

        $(".stm").on("click", function() {
        	var template_id = $(this).attr('data-tid');

			$.ajax({
				type: "POST",
				url: '/ws/email/test',
				data: { 'template_id': template_id},
				dataType: "json",
				success: function(result) {

					if (result) {
						flash_alert("#alert_success", "Test Email Sent!");
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

	});
</script>