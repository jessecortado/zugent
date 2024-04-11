<script src="/assets/plugins/select2/dist/js/select2.min.js"></script>
<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
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

    function editable_ts_init(){
        $('.editable-ts').editable({
            url: '/ws/transaction/edit_status',
            title: 'Enter Transaction Status Name',
            ajaxOptions: { dataType: 'json' },
            params: function(params) {
                //originally params contain pk, name and value
                params.transaction_status_id = $(this).data('pk');
                params.transaction_status = params.value;
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
                    $("#alert_error").removeClass('hide');
                }
                else {
                    flash_alert('#alert_success_status', 'Updated transaction status.');
                    $("#alert_error").addClass('hide');
                }
            }
        });
    }

    function editable_tt_init(){
        $('.editable-tt').editable({
            url: '/ws/transaction/edit_type',
            title: 'Enter Transaction Type Name',
            ajaxOptions: { dataType: 'json' },
            params: function(params) {
                //originally params contain pk, name and value
                params.transaction_type_id = $(this).data('pk');
                params.transaction_type = params.value;
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
                    $("#alert_error").removeClass('hide');
                }
                else {
                    flash_alert('#alert_success_type', 'Updated transaction type.');
                    $("#alert_error").addClass('hide');
                }
            }
        });
    }

    function delete_ts_init() {
        $('.btn-delete-transaction-status').on("click", function(){
            current = this;
            transaction_status_id = $(this).data("transaction-status-id");
        });

        $('.btn-delete-transaction-status').confirmation({
            title: "Are you sure you want to delete this transaction status?",
            placement: "left",
            btnOkLabel: "Yes",
            btnOkClass: "btn btn-sm btn-success m-r-3",
            btnCancelLabel: "No",
            singleton: true,
            onConfirm: function(event, element) { 
                $.ajax({
                    type: "POST",
                    url: '/ws/transaction/delete_status',
                    data: { 'transaction_status_id': transaction_status_id },
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

                        if ($("table#tbl-transaction-status tbody tr").length == 0) {
                            $("table#tbl-transaction-status tbody").append('<tr class="no-data"><td class="text-center" colspan="4">No Transaction Status Available</td></tr>');
                        }

                        flash_alert('#alert_success_status', 'Deleted a transaction status.');
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

    function delete_tt_init() {
        $('.btn-delete-transaction-type').on("click", function(){
            current = this;
            transaction_type_id = $(this).data("transaction-type-id");
        });

        $('.btn-delete-transaction-type').confirmation({
            title: "Are you sure you want to delete this transaction type?",
            placement: "left",
            btnOkLabel: "Yes",
            btnOkClass: "btn btn-sm btn-success m-r-3",
            btnCancelLabel: "No",
            singleton: true,
            onConfirm: function(event, element) { 
                $.ajax({
                    type: "POST",
                    url: '/ws/transaction/delete_type',
                    data: { 'transaction_type_id': transaction_type_id },
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

                        if ($("table#tbl-transaction-types tbody tr").length == 0) {
                            $("table#tbl-transaction-types tbody").append('<tr class="no-data"><td class="text-center" colspan="3">No Transaction Type Available</td></tr>');
                        }

                        flash_alert('#alert_success_type', 'Deleted a transaction type.');
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

    $(document).ready(function() {

        var transaction_type_id, transaction_status_id, current;

        editable_tt_init();
        delete_tt_init();
        editable_ts_init();
        delete_ts_init();

        $("#btn-save-transaction-type").on("click", function(){
            $("#form-add-transaction-type").submit();
        });

        $('#modal-add-transaction-type').on('hide.bs.modal', function (){
            $('#form-add-transaction-type').parsley().reset();
        });

        $("#form-add-transaction-type").on("submit", function(e){
            e.preventDefault();
            if ( $(this).parsley().isValid() ) {
                var transaction_type = $("#transaction-type").val();

                $.ajax({
                    type: "POST",
                    url: '/ws/transaction/add_type',
                    data: { 'transaction_type': transaction_type, 'company_id': {$company.company_id} },
                    dataType: "json",
                    success: function(result) {
                        console.log(result);

                        if (result.msg) {
                            //remove no data notification if file type is added
                            $( "table#tbl-transaction-types tbody tr" ).each(function() {
                                if ($(this).hasClass('no-data')) { 
                                    $(this).remove();
                                }
                            });

                            var row_html = '';
                            row_html += '<tr>';
                            row_html += '<td>'+result.transaction_type_id+'</td>';
                            row_html += '<td class="text-center">';
                            row_html += '<a href="javascript:void(0)" class="editable-tt" data-type="text" data-pk="'+result.transaction_type_id+'" data-value="'+result.transaction_type+'" data-name="'+result.transaction_type+'">' + result.transaction_type + '';
                            row_html += '</a></td>';
                            row_html += '<td class="text-center">';
                            row_html += '<a href="#alert_success_type" class="btn btn-xs btn-danger btn-delete-transaction-type" data-transaction-type-id="'+result.transaction_type_id+'"><i class="glyphicon glyphicon-remove"></i>Delete';
                            row_html += '</a></td>';
                            row_html += '</tr>';
                            $("#tbl-transaction-types tbody").append(row_html);

                            flash_alert('#alert_success_type', 'Added a transaction type.');

                            editable_tt_init();
                            delete_tt_init();
                            $("#transaction-type").val("");
                            $("#modal-add-transaction-type").modal('hide');
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

        $("#btn-save-transaction-status").on("click", function(){
            $("#form-add-transaction-status").submit();
        });

        $('#modal-add-transaction-status').on('hide.bs.modal', function (){
            $('#form-add-transaction-status').parsley().reset();
        });

        $("#form-add-transaction-status").on("submit", function(e){
            e.preventDefault();
            if ( $(this).parsley().isValid() ) {
                var transaction_status = $("#transaction-status").val();
                $.ajax({
                    type: "POST",
                    url: '/ws/transaction/add_status',
                    data: { 'transaction_status': transaction_status, 'company_id': {$company.company_id} },
                    dataType: "json",
                    success: function(result) {
                        console.log(result);

                        if (result.msg) {
                            //remove no data notification if file type is added
                            $( "table#tbl-transaction-status tbody tr" ).each(function() {
                                if ($(this).hasClass('no-data')) { 
                                    $(this).remove();
                                }
                            });

                            var row_html = '';
                            row_html += '<tr>';
                            row_html += '<td>'+result.transaction_status_id+'</td>';
                            row_html += '<td class="text-center">';
                            row_html += '<a href="javascript:void(0)" class="editable-ts" data-type="text" data-pk="'+result.transaction_status_id+'" data-value="'+result.transaction_status+'" data-name="'+result.transaction_status_id+'">' + result.transaction_status + '';
                            row_html += '</a></td>';
                            row_html += '<td class="text-center">';
                            row_html += '<a href="#alert_success_status" class="btn btn-xs btn-danger btn-delete-transaction-status" data-transaction-type-id="'+result.transaction_status_id+'"><i class="glyphicon glyphicon-remove"></i>Delete';
                            row_html += '</a></td>';
                            row_html += '</tr>';
                            $("#tbl-transaction-status tbody").append(row_html);

                            flash_alert('#alert_success_status', 'Added a transaction status.');

                            editable_ts_init();
                            delete_ts_init();
                            $("#transaction-status").val("");
                            $("#modal-add-transaction-status").modal('hide');
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

    });
</script>