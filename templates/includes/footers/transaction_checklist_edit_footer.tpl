<script src="/assets/plugins/select2/dist/js/select2.full.min.js"></script>
<script src="assets/js/bootstrap-confirmation.min.js"></script>

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

    function delete_step_init() {
        $(document).on("click", ".btn-delete-step", function() {
            step_id = $(this).parent().closest("tr").data("step-id");
            checklist_id = $(this).parent().closest("tr").data("checklist-id");
            current = this;
        });

        $('.btn-delete-step').confirmation({
            title: "Are you sure you want to delete this bucket?",
            placement: "left",
            btnOkLabel: "Yes",
            btnOkClass: "btn btn-sm btn-success m-r-3",
            btnCancelLabel: "No",
            onConfirm: function(event, element) {
                $.ajax({
                    type: "POST",
                    url: '/ws/checklist/delete_step',
                    data: { 'step_id': step_id, 'checklist_id': checklist_id },
                    dataType: "json",
                    success: function(result) {
                        console.log(result);
                        if(result) {
                            $(current).closest("tr").remove();
                            flash_alert('#alert_success', 'Deleted a step.');
                            $("#alert_error").addClass('hide');
                        }
                        else {
                            $("#alert_error").removeClass('hide');
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                    }
                });
            },
            onCancel: function() { }
        });
    }

    $(document).ready(function() {

        var step_id, current;
        delete_step_init();

        $("#transaction-type").select2({ placeholder:'Please select one', width:'100%' });
        $("#select-due-event").select2({ placeholder:'Please select one', width:'100%' });

        $("#form-step").on("submit", function(e){
            e.preventDefault();
            if ( $(this).parsley().isValid() ) {
                $.ajax({
                    type: "POST",
                    url: '/ws/checklist/add_step',
                    data: $(this).serialize(),
                    dataType: "json",
                    success: function(result) {
                        console.log(result);

                        if (result.msg) {

                            $("table#tbl-checklists tbody tr").each(function() {
                                if ($(this).hasClass('no-data')) { 
                                    $(this).remove();
                                }
                            });

                            var row_html = '';
                            row_html += '<tr data-step-id="'+result.data[0]['checklist_step_id']+'" data-checklist-id="'+result.data[0]['checklist_id']+'">';
                            row_html += '<td>'+result.data[0]['checklist_step_id']+'</td>';
                            row_html += '<td class="text-center">'+result.data[0]['step_name']+'</td>';
                            row_html += '<td class="text-center">'+result.data[0]['step_tooltip']+'</td>';
                            row_html += '<td class="text-center">';
                            row_html += '<div class="checkbox checkbox-css checkbox-success"><input type="checkbox" id="checkbox_has_agent'+result.data[0]['checklist_step_id']+'" class="has-agent"><label for="checkbox_has_agent'+result.data[0]['checklist_step_id']+'"></label></div>';
                            row_html += '</td>';
                            row_html += '<td class="text-center">';
                            row_html += '<div class="checkbox checkbox-css checkbox-success"><input type="checkbox" id="checkbox_has_admin_'+result.data[0]['checklist_step_id']+'" class="has-admin"><label for="checkbox_has_admin_'+result.data[0]['checklist_step_id']+'"></label></div>';
                            row_html += '</td>';
                            row_html += '<td class="text-center">'+result.data[0]['due_event']+'</td>';
                            row_html += '<td class="text-center">'+result.data[0]['due_days']+'</td>';
                            row_html += '<td class="text-center"><a href="javascript:;" class="btn btn-xs btn-danger m-r-5 btn-delete-step"><i class="glyphicon glyphicon-remove"></i>Delete</a></td>';
                            row_html += '</tr>';
                            $("#tbl-checklists").append(row_html);

                            delete_step_init();

                            flash_alert('#alert_success', 'Added a step.');
                            $("#alert_error").addClass('hide');
                        }
                        else {
                            $("#alert_error").removeClass('hide');
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                    },
                    complete: function() {
                        $("#modal-step").modal('hide');
                    }
                });
            }
        });

        $(document).on("click", ".has-agent", function(){
            var step_id = $(this).closest("tr").data("step-id");
            var checklist_id = $(this).parent().closest("tr").data("checklist-id");
            var current = this;
            
            $.ajax({
                type: "POST",
                url: '/ws/checklist/has_agent',
                data: { 'step_id': step_id, 'value' : $(current).is(":checked"), 'checklist_id': checklist_id },
                dataType: "json",
                success: function(result) {
                    console.log(result);
                    if(result) {
                        if($(current).is(":checked")) {
                            flash_alert('#alert_success', 'Set transaction checklist has an agent.');
                        }
                        else {
                            flash_alert('#alert_success', 'Unset transaction checklist has agent.');
                        }
                        $("#alert_error").addClass('hide');
                    }
                    else {
                        $("#alert_error").removeClass('hide');
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                }
            });
        });

        $(document).on("click", ".has-admin", function(){
            var step_id = $(this).closest("tr").data("step-id");
            var checklist_id = $(this).parent().closest("tr").data("checklist-id");
            var current = this;
            
            $.ajax({
                type: "POST",
                url: '/ws/checklist/has_admin',
                data: { 'step_id': step_id, 'value': $(current).is(":checked"), 'checklist_id': checklist_id },
                dataType: "json",
                success: function(result) {
                    console.log(result);
                    if(result) {
                        if($(current).is(":checked")) {
                            flash_alert('#alert_success', 'Set transaction checklist has admin.');
                        }
                        else {
                            flash_alert('#alert_success', 'Unset transaction checklist has admin.');
                        }
                        $("#alert_error").addClass('hide');
                    }
                    else {
                        $("#alert_error").removeClass('hide');
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                }
            });
        });

        $("#btn-save-step").on("click", function() {
            $("#form-step").submit();
        });

    });
</script>