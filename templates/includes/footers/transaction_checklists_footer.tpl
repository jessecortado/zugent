<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
<script src="assets/plugins/select2/dist/js/select2.min.js"></script>

<script type="text/javascript">

    function day_ordinal(day) {
        if(day>3 && day<21) return 'th';
        switch (day % 10) {
            case 1:  return "st";
            case 2:  return "nd";
            case 3:  return "rd";
            default: return "th";
        }
    }

    function datetime_format(datetime) {
        var js_datetime = new Date(datetime),
            date = js_datetime.getDate(),
            month = "Jan,Feb,Mar,Apl,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec".split(",")[js_datetime.getMonth()];

        if (datetime != '')
        return month +" "+ date + day_ordinal(date) +", "+ js_datetime.getFullYear();
    }

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

        $("#add-checklist").on("submit", function(e) {
            e.preventDefault();
            if ( $(this).parsley().isValid() ) {
                var checklist_name = $("#checklist-name").val();
                $.ajax({
                    type: "POST",
                    url: '/ws/checklist/add',
                    data: { 'checklist_name': checklist_name },
                    dataType: "json",
                    success: function(result) {
                        console.log(result);
                        if (result.msg) {
                            //remove no data notification if file type is added
                            $( "table#tbl-checklists tbody tr" ).each(function() {
                                if ($(this).hasClass('no-data')) { 
                                    $(this).remove(); 
                                }
                            });

                            var row_html = '';
                            row_html += '<tr>';
                            row_html += '<td>'+result.data[0]['checklist_id']+'</td>';
                            row_html += '<td class="text-center">'+result.data[0]['checklist_name']+'</td>';
                            row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_added'])+' ('+result.data[0]['created_by']+')</td>';
                            if (result.data[0]['date_modified'] != '0000-00-00 00:00:00' && result.data[0]['modified_by'] != '') {
                                row_html += '<td class="text-center">'+result.data[0]['date_modified']+' ('+result.data[0]['modified_by']+')</td>';
                            }
                            else {
                                row_html += '<td class="text-center">(n/a)</td>';
                            }
                            row_html += '<td class="text-center">';
                            row_html += '<a href="transaction_checklist_edit.php?checklist_id='+result.data[0]['checklist_id']+'&checklist_name='+result.data[0]['checklist_name']+'" class="btn btn-xs btn-info m-r-5 btn-edit"><i class="glyphicon glyphicon-eye-open"></i>Edit</a>';
                            row_html += '<a href="#" class="btn btn-xs btn-danger m-r-5 btn-status" data-checklist-id="'+result.data[0]['checklist_id']+'" data-status="active"><i class="glyphicon glyphicon-remove"></i>Set Inactive</a>';
                            row_html += '</td>';
                            row_html += '</tr>';
                            $("#tbl-checklists tbody").append(row_html);

                            flash_alert('#alert_success', 'Added a transaction checklist.');

                            $("#checklist-name").val('');
                            $("#add-checklist").parsley().reset();
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
            }
        });
        
        $(document).on("click", ".btn-status", function() {
            var checklist_id = $(this).data("checklist-id");
            var is_active = $(this).data("status");
            var current = this;

            $.ajax({
                type: "POST",
                url: '/ws/checklist/status',
                data: { 'checklist_id': checklist_id, 'is_active': is_active },
                dataType: "json",
                success: function(result) {
                    console.log(result);
                    if (result.msg) {
                        var first = $(current).closest('tr');
                        $(first).remove();

                        var row_html = '';
                        row_html += '<tr>';
                        row_html += '<td>'+result.data[0]['checklist_id']+'</td>';
                        row_html += '<td class="text-center">'+result.data[0]['checklist_name']+'</td>';
                        row_html += '<td class="text-center">'+datetime_format(result.data[0]['date_added'])+' ('+result.data[0]['created_by']+')</td>';
                        if (result.data[0]['date_modified'] != '0000-00-00 00:00:00' && result.data[0]['modified_by'] != '') {
                            row_html += '<td class="text-center">'+result.data[0]['date_modified']+' ('+result.data[0]['modified_by']+')</td>';
                        }
                        else {
                            row_html += '<td class="text-center">(n/a)</td>';
                        }

                        if (is_active == 'active') {

                            row_html += '<td class="text-center">';
                            row_html += '<a href="#" class="btn btn-xs btn-danger m-r-5 btn-status" data-checklist-id="'+result.data[0]['checklist_id']+'" data-status="inactive"><i class="glyphicon glyphicon-remove"></i>Set Inactive</a>';
                            row_html += '</td>';
                            row_html += '</tr>';

                            $("#tbl-inactive-checklists tbody").append(row_html);

                            if ($("#panel-inactive").is( ":visible" ) && $("#panel-inactive .panel-body").is( ":hidden" )) {
                                $("#show-inactive").click();
                            }

                            if ($("#tbl-checklists tbody tr").length == 0) {
                                $("#tbl-checklists tbody").append('<tr class="no-data"><td class="text-center" colspan="5">No Transaction Checklist Available</td></tr>');
                            }

                            flash_alert('#alert_success', 'Inactive a transaction checklist.');
                        }
                        else {
                            //remove no data notification if file type is added
                            $( "table#tbl-checklists tbody tr" ).each(function() {
                                if ($(this).hasClass('no-data')) {
                                    $(this).remove();
                                }
                            });

                            row_html += '<td class="text-center">';
                            row_html += '<a href="transaction_checklist_edit.php?checklist_id='+result.data[0]['checklist_id']+'&checklist_name='+result.data[0]['checklist_name']+'" class="btn btn-xs btn-info m-r-5 btn-edit"><i class="glyphicon glyphicon-eye-open"></i>Edit</a>';
                            row_html += '<a href="#" class="btn btn-xs btn-danger m-r-5 btn-status" data-checklist-id="'+result.data[0]['checklist_id']+'" data-status="active"><i class="glyphicon glyphicon-remove"></i>Set Inactive</a>';
                            row_html += '</td>';
                            row_html += '</tr>';

                            $("#tbl-checklists tbody").append(row_html);

                            if ($("#tbl-inactive-checklists tbody tr").length == 0) {
                                $("#tbl-inactive-checklists tbody").addClass('display', 'none');
                            }

                            flash_alert('#alert_success', 'Activated transaction checklist.');
                        }

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

        var shown = 0;

        $(document).on("click", '#show-inactive',function(){
            if(shown == 0) {
                $(this).html('<i class="fa fa-minus"></i> Hide Inactive Users');
                shown++;
            }
            else {
                $(this).html('<i class="fa fa-expand"></i> Show Inactive Users');
                shown--;
            }
        });

    });

</script>