<script src="assets/plugins/sweetalert2/js/sweetalert2.all.min.js"></script>
<script src="assets/test_temp/menu_plugin/jquery.nestable.js"></script>
<script src="assets/test_temp/menu_plugin/menu_design_app.js"></script>

<script type="text/javascript">

    function flash_alert(element, msg) {
        $('#alert_error').addClass('hide');
        $(element+' span#msg').text(msg);
        $(element).removeClass('hide');
        $(element).css('opacity', '1');
        $(element).css('display', 'block');
        window.setTimeout(function() {
          $(element).fadeTo(500, 0).slideUp(500, function(){
              // $(this).remove();
              $(element).addClass('hide');
          });
        }, 2000);
    }
	
	$(document).ready(function() {

		$("#newpageContent [name='page_name']").on({
			keydown: function(e) {
				if (e.which === 32)
					return false;
			},
			change: function() {
				this.value = this.value.replace(/\s/g, "");
			}
		});

		$(".add-custom-page").on('click', function (){
	        var page_name = $(this).attr('data-page-name');

            var menu_btn = '<li class="dd-item" data-id="'+s4()+'" data-custompage="1" data-type="menu-page">';
            menu_btn += '<a class="dd-handle" href="'+page_name+'">'+page_name+'</a>';
            menu_btn += '<a href="javascript:;" class="menu-setup"><i class="fa fa-gear"></i></a>';
            menu_btn += '<a href="javascript:;" class="menu-remove"><i class="fa fa-times"></i></a>';
            menu_btn += '</li>';
            $('#menu-html .dd ol.dd-list:first').append(menu_btn);

            $("#alert_validate_menu").addClass("hide");
            $("#alert_error_menu").addClass("hide");
            notifyItem();
		});

		$(".remove-custom-page").on('click', function (){
	        var page_id = $(this).attr('data-page-id');
	        var page_name = $(this).attr('data-page-name');

			$.ajax({
				type: "POST",
				url: '/ws/page/remove',
				data: { 'page_id':page_id, 'page_name':page_name },
				dataType: "json",
				success: function(result) {
					if (result) {
						window.location = "company_page_settings.php";
					}
					else {
						$('#alert_error').removeClass('hide');
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
				}
			});
		});

		$("#btn-save-settings").click(function() {
			$("#form-general-settings").submit();
		});

		$("#createPage").click(function() {
			$("#newpageContent").submit();
		});

		$("#newpageContent").on("submit", function(e){
			e.preventDefault();

			if ( $(this).parsley().isValid() ) {
				$.ajax({
					type: "POST",
					url: '/ws/page/add',
					data: $(this).serialize(),
					dataType: "json",
					success: function(result) {
						if (result.msg) {
							var page_card = '<div class="col-md-4 col-xs-12">';
				            page_card += '<div class="widget widget-stats bg-green">';
				            page_card += '<div class="stats-icon" style="top:6px"><i class="fa fa-file-text"></i></div>';
				            page_card += '<div class="stats-info"><p>'+result.page_name+' Page</p></div>';
				            page_card += '<div class="stats-link">';
				            page_card += '<a href="http://{$company_settings.site_address}.{$smarty.server.HTTP_HOST}/'+result.page_name+'">Visit '+result.page_name+' Page <i class="fa fa-globe"></i></a>';
				            page_card += '<a href="javascript:;">Edit '+result.page_name+' Page <i class="fa fa-pencil"></i></a>';
				            page_card += '</div></div></div>';
				            $('#customPages .row').append(page_card);
				            
	                    	flash_alert('#alert_success_setting', 'Saved page settings.');
	                    	$("#modal-add-page").modal('hide');
						}
						else {
							$('#alert_error').removeClass('hide');
						}
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
					}
				});
			}
		});

		$("#form-general-settings").on("submit", function(e){
			e.preventDefault();

			if ( $(this).parsley().isValid() ) {
				$.ajax({
					type: "POST",
					url: '/ws/page/save_settings',
					data: $(this).serialize(),
					dataType: "json",
					success: function(result) {
						if (result) {
	                    	flash_alert('#alert_success_setting', 'Saved page settings.');
							$('#form-general-settings').parsley().reset();
						}
						else {
							$('#alert_error').removeClass('hide');
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