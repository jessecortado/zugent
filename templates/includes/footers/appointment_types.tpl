<script src="/assets/plugins/select2/dist/js/select2.full.min.js"></script>
<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>

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

    var getIconsSource = function() {
        return JSON.parse(JSON.stringify({$appointment_icons}));
    };

    function iformat(icon) {
        return $('<span><i class="fa ' + icon.id + '"></i>  ' + icon.text + '</span>');
    }

    $(document).ready(function() {

        $("#appointment-icon").select2({
            placeholder: "Select Appointment Icon", 
            width: "100%", 
            'max-width': "100%",
            allowClear: true,
            templateSelection: iformat,
            templateResult: iformat,
            allowHtml: true
        });

        edit_appointment_type();
        edit_appointment_icon();
        enable_appointment_type();
        disable_appointment_type();

        $("#add-appointment-type").on("submit", function(e){
            e.preventDefault();
            var appointment_type = $("#appointment-type").val();
            var appointment_icon = $("#appointment-icon").val();
            $.ajax({
                type: "POST",
                // url: '/services/appointment_manager.php',
                // data: { 'appointment_type': appointment_type, 'action': 'add_appointment_type' },
                url: '/ws/appointment/add',
                data: { 'appointment_type': appointment_type, 'appointment_icon': appointment_icon },
                dataType: "json",
                success: function(result) {
                    console.log(result);

                    if (result.msg) {

                        //remove no data notification if file type is added
                        $( "table#appointment-types tbody tr" ).each(function() {
                            if ($(this).hasClass('no-data')) { 
                                $(this).remove(); 
                            }
                        });

                        var row_html = '';
                        row_html += '<tr>';
                        row_html += '<td>'+result.appointment_type_id+'</td>';
                        row_html += '<td class="text-center">';
                        row_html += '<a href="javascript:;" class="editable-appointment-name" data-type="text" ';
                        row_html += 'data-pk="'+result.appointment_type_id+'" data-value="'+result.appointment_type+'" data-name="'+result.appointment_type+'">'+result.appointment_type+'';
                        row_html += '</a></td>';
                        row_html += '<td class="text-center">';
                        row_html += '<a href="javascript:;" class="editable-appointment-icon" data-type="text" ';
                        row_html += 'data-pk="'+result.appointment_type_id+'" data-value="'+result.appointment_icon+'" data-name="'+result.appointment_icon+'">';
                        row_html += '<i class="fa '+result.appointment_icon+'"></i> '+result.appointment_icon+'';
                        row_html += '</a></td>';
                        row_html += '<td class="text-center">';
                        row_html += '<a href="#alert_success_activetypes" class="btn btn-xs btn-danger btn-disable" ';
                        row_html += 'data-appointment-type-id='+result.appointment_type_id+' data-appointment-type='+result.appointment_type+' data-appointment-icon='+result.appointment_icon+'>';
                        row_html += '<i class="glyphicon glyphicon-remove"></i>Disable';
                        row_html += '</a></td>';
                        row_html += '</tr>';
                        $("#appointment-types tbody").append(row_html);

                        edit_appointment_type();
                        edit_appointment_icon();
                        disable_appointment_type();
                        flash_alert('#alert_success_activetypes', 'Added an appointment type.');
                        
                        $("#appointment-type").val('');
                        $("#add-appointment-type").parsley().reset();
                    }
                    else {
                        $('#alert_error').removeClass('hide');
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
                }
            });
        });

        function edit_appointment_type() {
            $('.editable-appointment-name').editable({
                url: '/ws/appointment/edit',
                title: 'Enter Appointment Type Name',
                ajaxOptions: { dataType: 'json' },
                params: function(params) {
                    //originally params contain pk, name and value
                    params.appointment_type_id = $(this).data('pk');
                    params.appointment_type = params.value;
                    params.appointment_column = 'appointment_type';
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
                        $('#alert_error').removeClass('hide');
                    }
                    else {
                        $('a.btn-disable[data-appointment-type-id="'+$(this).data('pk')+'"]').attr('data-appointment-type', newValue);
                        flash_alert('#alert_success_activetypes', 'Updated an appointment type.');
                    }
                }
            });
        }

        function edit_appointment_icon() {
            $('.editable-appointment-icon').editable({
                url: '/ws/appointment/edit',
                title: 'Enter Appointment Type Icon',
                source: getIconsSource(),
                select2: {
                    width: 200,
                    placeholder: 'Select Icon',
                    allowClear: true,
                    dropdownCssClass: "x-editable-select2",
                    templateSelection: iformat,
                    templateResult: iformat,
                    allowHtml: true
                },
                ajaxOptions: { dataType: 'json' },
                params: function(params) {
                    //originally params contain pk, name and value
                    params.appointment_type_id = $(this).data('pk');
                    params.appointment_icon = params.value;
                    params.appointment_column = 'appointment_icon';
                    //alert(params.value);
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
                        $('#alert_error').removeClass('hide');
                    }
                    else {
                        $('a.btn-disable[data-appointment-type-id="'+$(this).data('pk')+'"]').attr('data-appointment-type', newValue);
                        flash_alert('#alert_success_activetypes', 'Updated an appointment type.');
                    }
                }
            });
        }

        function enable_appointment_type() {
            $(".btn-activate").unbind('click').bind('click', function(){
                var appointment_type_id = $(this).data("appointment-type-id");
                var appointment_type = $(this).data("appointment-type");
                var appointment_icon = $(this).data("appointment-icon");
                var current = this;
                var transfer;

                $.ajax({
                    type: "POST",
                    url: '/ws/appointment/set_activate',
                    data: { 'appointment_type_id': appointment_type_id, 'appointment_type': appointment_type, 'appointment_icon': appointment_icon, 'is_active': '1' },
                    dataType: 'json',
                    success: function(result) {
                        console.log(result);
                        if(result.msg) {
                            transfer = $(current).parent().closest('tr');
                            $(transfer).remove();

                            var row_html = '';
                            row_html += '<tr>';
                            row_html += '<td>'+result.appointment_type_id+'</td>';
                            row_html += '<td class="text-center">';
                            row_html += '<a href="javascript:;" class="editable-appointment-name" data-type="text" ';
                            row_html += 'data-pk='+result.appointment_type_id+' data-value='+result.appointment_type+' data-name='+result.appointment_type+'>'+result.appointment_type+'';
                            row_html += '</a></td>';
                            row_html += '<td class="text-center">';
                            row_html += '<a href="javascript:;" class="editable-appointment-icon" data-type="select2" ';
                            row_html += 'data-pk="'+result.appointment_type_id+'" data-value="'+result.appointment_icon+'" data-name="'+result.appointment_icon+'">';
                            row_html += '<i class="fa '+result.appointment_icon+'"></i> '+result.appointment_icon+'';
                            row_html += '</a></td>';
                            row_html += '<td class="text-center">';
                            row_html += '<a href="#alert_success_disabledtypes" class="btn btn-xs btn-danger btn-disable" ';
                            row_html += 'data-appointment-type-id='+result.appointment_type_id+' data-appointment-type='+result.appointment_type+' data-appointment-icon='+result.appointment_icon+'>';
                            row_html += '<i class="glyphicon glyphicon-remove"></i>Disable';
                            row_html += '</a></td>';
                            row_html += '</tr>';
                            $("#appointment-types tbody").append(row_html);

                            if ($( "table#disabled-appointment-types tbody tr" ).length == 0) {
                                $("table#disabled-appointment-types tbody").append('<tr class="no-data"><td class="text-center" colspan="3">No Appointment Types Available</td></tr>');
                            }

                            edit_appointment_type();
                            edit_appointment_icon();
                            disable_appointment_type();
                            flash_alert('#alert_success_disabledtypes', 'Enabled an appointment type.');
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
        }

        function disable_appointment_type() {
            $(".btn-disable").unbind('click').bind('click', function(){
                var appointment_type_id = $(this).data("appointment-type-id");
                var appointment_type = $(this).data("appointment-type");
                var appointment_icon = $(this).data("appointment-icon");
                var current = this;
                var transfer;

                $.ajax({
                    type: "POST",
                    url: '/ws/appointment/set_activate',
                    data: { 'appointment_type_id': appointment_type_id, 'appointment_type': appointment_type, 'appointment_icon': appointment_icon, 'is_active': '0' },
                    dataType: 'json',
                    success: function(result) {
                        console.log(result);
                        if(result.msg) {
                            transfer = $(current).parent().closest('tr');
                            $(transfer).remove();

                            var row_html = '';
                            row_html += '<tr>';
                            row_html += '<td>'+result.appointment_type_id+'</td>';
                            row_html += '<td class="text-center">'+result.appointment_type+'</td>';
                            row_html += '<td class="text-center"><i class="fa '+result.appointment_icon+'"></i> '+result.appointment_icon+'</td>';
                            row_html += '<td class="text-center">';
                            row_html += '<a href="#alert_success_activetypes" class="btn btn-xs btn-success btn-activate" data-appointment-type-id='+result.appointment_type_id+' data-appointment-type='+result.appointment_type+' data-appointment-icon='+result.appointment_icon+'>';
                            row_html += '<i class="glyphicon glyphicon-check"></i>Enable';
                            row_html += '</a>';
                            row_html += '</td>';
                            row_html += '</tr>';
                            $("#disabled-appointment-types tbody").append(row_html);

                            //remove no data notification if file type is added
                            $( "table#disabled-appointment-types tbody tr" ).each(function() {
                                if ($(this).hasClass('no-data')) { 
                                    $(this).remove(); 
                                }
                            });

                            edit_appointment_type();
                            edit_appointment_icon();
                            enable_appointment_type();
                            flash_alert('#alert_success_activetypes', 'Disabled an appointment type.');
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
        }

    });
</script>