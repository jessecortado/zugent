<script src="https://cdn.jsdelivr.net/ace/1.2.0/min/ace.js"></script>
<script src="//cdn.tinymce.com/4/tinymce.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>
<script src="assets/plugins/sweetalert2/js/sweetalert2.all.min.js"></script>
<script src="assets/test_temp/page_design_app.js"></script>


<script type="text/javascript">
	
	$(document).ready(function(){

		$('#save-design').click(function () {
			downloadLayoutSrc();
			var target = $('#page-design-sheet').closest('.panel');

			$.ajax({
				type: "POST",
				url: '/ws/page/save_design',
				data: {
					'page_name': '{$page_title}',
					'plain_code': $("#download-layout").html(),
					'edittable_code': $(".htmlpage").html()
				},
				dataType: "json",
			    beforeSend: function() {
			        if (!$(target).hasClass('panel-loading')) {
			            var targetBody = $(target).find('.panel-body');
			            var spinnerHtml = '<div class="panel-loader"><span class="spinner-small"></span></div>';
			            $(target).addClass('panel-loading');
			            $(targetBody).prepend(spinnerHtml);
			        }
			    },
				success: function(result) {
					if (result) {
						swal({
							type: 'success',
							title: 'Your work has been saved',
							showConfirmButton: false,
							timer: 1500
						}).catch(swal.noop);
					}
					else {
						swal({
							type: 'error',
							title: 'Your work has been saved',
							showConfirmButton: false,
							timer: 1500
						}).catch(swal.noop);
					}

	                $(target).removeClass('panel-loading');
	                $(target).find('.panel-loader').remove();
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				}
			});
		});

	});

</script>