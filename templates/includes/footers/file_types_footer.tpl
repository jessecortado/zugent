<script src="/assets/plugins/select2/dist/js/select2.min.js"></script>
<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
<script src="assets/js/bootstrap-confirmation.min.js"></script>

<script type="text/javascript">
	function isNumberKey(evt){
	    var charCode = (evt.which) ? evt.which : event.keyCode
	    if (charCode > 31 && (charCode < 48 || charCode > 57))
	        return false;
	    return true;
	}

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
		$('#sequence').mask('999');

		var current,file_type_id;

		edit_type_name();
		edit_type_sequence();
		delete_type();

		$("#add-file-type").on("submit", function(e){
			e.preventDefault();
			var name = $("#name").val();
			var sequence = $("#sequence").val();
			$.ajax({
				type: "POST",
				url: '/ws/file_types/add',
				data: { 'name': name, "sequence": sequence },
				dataType: "json",
				success: function(result) {
					console.log(result);
					if (result.msg) {
						//remove no data notification if file type is added
						$( "table#file-types tbody tr" ).each(function() {
							if ($(this).hasClass('no-data')) { 
								$(this).remove(); 
							}
						});

						var row_html = '';
						row_html += '<tr>';
						row_html += '<td>'+result.file_type_id+'</td>';
						row_html += '<td class="text-center">';
						row_html += '<a href="#file-types" class="editable-file-type editable editable-click" data-type="text" data-pk="'+result.file_type_id+'" data-value="'+result.name+'" data-name="'+result.name+'">'+result.name+'';
						row_html += '</a></td>';
						row_html += '<td class="text-center">';
						row_html += '<a href="#file-types" class="editable-sequence editable-click" data-type="text" data-pk="'+result.file_type_id+'" data-value="'+result.sequence+'">'+result.sequence+'';
    					row_html += '</a></td>';
    					row_html += '<td class="text-center">';
    					row_html += '<a href="javascript:;" data-toggle="confirmation" class="btn btn-xs btn-danger btn-delete-file-type" data-file-type-id="'+result.file_type_id+'">';
    					row_html += '<i class="glyphicon glyphicon-remove"></i>Delete</a>';
    					row_html += '</td>';
    					row_html += '</tr>';
    					$("#file-types tbody").append(row_html);

                        flash_alert('#alert_success', 'Added a file type.');

						//re-initialize plugins for newly added data
						edit_type_name();
						edit_type_sequence();
						delete_type();

						$("#name").val('');
						$("#sequence").val('');
						$("#add-file-type").parsley().reset();
						$("#alert_error").addClass('hide');
					}
					else {
						$("#alert_error").removeClass('hide');
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
				}
			});
		});

		function edit_type_name() {
			$('.editable-file-type').editable({
				url: '/ws/file_types/edit_name',
				title: 'Enter File Type Name',
				ajaxOptions: { dataType: 'json' },
				params: function(params) {
				//originally params contain pk, name and value
				params.file_type_id = $(this).data('pk');
				params.name = params.value;
				return params;
				},
				validate: function(value) {
					if($.trim(value) == '') {
						return 'This field is required';
					}
				},
				success: function(response, newValue) {
					console.log(response);
					if (!response) {
						return 'Permission Denied';
					}
					else {
                        flash_alert('#alert_success', 'Updated file type name.');
					}
				}
			});
		}

		function edit_type_sequence() {
			$('.editable-sequence').editable({
				url: '/ws/file_types/edit_sequence',
				title: 'Enter Sequence',
				tpl: '<input maxlength="3" onkeypress="return isNumberKey(event)"/>',
				ajaxOptions: { dataType: 'json' },
				params: function(params) {
				//originally params contain pk, name and value
				params.file_type_id = $(this).data('pk');
				params.sequence = params.value;
				return params;
				},
				validate: function(value) {
					if($.trim(value) == '') {
						return 'This field is required';
					}
				},
				success: function(response, newValue) {
					console.log(response);
					if (!response) {
						return 'Permission Denied';
					}
					else {
                        flash_alert('#alert_success', 'Updated file type sequence.');
					}
				}
			});
		}

		function delete_type() {
			$('.btn-delete-file-type').on("click", function(){
				current = this;
				file_type_id = $(this).data("file-type-id");
			});

			$('.btn-delete-file-type').confirmation({
				title: "Are you sure you want to delete this file type?",
	            placement: "left",
	            btnOkLabel: "Yes",
	            btnOkClass: "btn btn-sm btn-success m-r-3",
	            btnCancelLabel: "No",
				singleton: true,
				onConfirm: function(event, element) { 
					$.ajax({
						type: "POST",
						url: '/ws/file_types/delete',
						data: { 'file_type_id': file_type_id },
						dataType: "json",
					})
					.fail(function (XMLHttpRequest, textStatus, errorThrown) {
						console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
					})
					.success(function(response) {
						console.log(response);
						if(response) {
							transfer = $(current).parent().closest('tr');
							$(transfer).remove();

							if ($( "table#file-types tbody tr" ).length == 0) {
								$("table#file-types tbody").append('<tr class="no-data"><td class="text-center" colspan="4">No Contact File Types Available</td></tr>');
							}

							flash_alert('#alert_success', 'Deleted a file type.');
							$("#alert_error").addClass('hide');
						}
						else {
							$("#alert_error").removeClass('hide');
						}
					});
				},
				onCancel: function() {}
			});
		}
	});
</script>