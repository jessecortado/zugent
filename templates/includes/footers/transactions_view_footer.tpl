<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
<script src="assets/plugins/bootstrap-datetimepicker/js/bootstrap-datetimepicker.min.js"></script>
<script src="assets/plugins/sweetalert2/js/sweetalert2.all.min.js"></script>
<script src="assets/plugins/select2/dist/js/select2.full.min.js"></script>

<script type="text/javascript">
    function editable_init() {

        $('.editable-date').editable({
            // url: '/services/transaction_manager.php',
            url: '/ws/transaction/edit_contact_date',
            title: 'Enter New Date',
            format: 'yyyy-mm-dd hh:ii',
            viewformat: 'M dd, yyyy H:ii P',
            showbuttons: 'bottom',
            placement: 'top',
            datetimepicker: {
               todayBtn: 'linked',
               weekStart: 1
            },
            params: function(params) {
                //originally params contain pk, name and value
                // params.action = 'edit_transaction_date';
                params.transaction_id = $(this).data('pk');
                params.column = $(this).data('column');
                params.date = params.value;
                return params;
            },
            validate: function(value) {
               // if(value && value.getDate() == "") return 'Day cant be empty!';
            },
            success: function(response, newValue) {
                console.log(response);
            }
        }); 

        $('.editable-transaction-status').editable({
            url: '/ws/transaction/edit_contact_status',
            title: 'Enter Transaction Status Name',
            source: get_transaction_status({$company_id}),
            showbuttons: 'bottom',
            placement: 'top',
            select2: {
                width: 200,
                placeholder: 'Select Status',
                allowClear: true,
            },
            showbuttons: 'bottom',
            params: function(params) {
                //originally params contain pk, name and value
                params.transaction_id = $(this).data('pk');
                params.transaction_status_id = params.value;
                return params;
            },
            validate: function(value) {
                if($.trim(value) == '') {
                    return 'This field is required';
                }
            },
            success: function(response, newValue) {
                console.log(response);
            }
        });

        $('.editable-transaction-types').editable({
            url: '/ws/transaction/edit_contact_type',
            title: 'Enter Transaction Type Name',
            showbuttons: 'bottom',
            placement: 'top',
            select2: {
                width: 200,
                placeholder: 'Select Type',
                allowClear: true
            },
            tpl:'<select type="hidden">',
            source: get_transaction_types({$company_id}),
            params: function(params) {
                //originally params contain pk, name and value
                params.transaction_id = $(this).data('pk');
                params.transaction_type_id = params.value;
                return params;
            },
            validate: function(value) {
                if($.trim(value) == '') {
                    return 'This field is required';
                }
            },
            success: function(response, newValue) {
                console.log(response);
            }
        });

        $('.editable-textarea').editable({
            type: 'textarea',
            url: '/ws/transaction/edit_extendedata',
            title: 'Enter Extended Data',
            showbuttons: 'bottom',
            placement: 'top',
            params: function(params) {
                //originally params contain pk, name and value
                params.transaction_id = $(this).data('pk');
                params.extended_data = params.value;
                return params;
            },
            validate: function(value) {
                if($.trim(value) == '') {
                    return 'This field is required';
                }
            },
            success: function(response, newValue) {
                console.log(response);
            }
        });

        $('.editable-text').editable({
            url: '/services/transaction_manager.php',
            title: 'Enter Transaction Type Name',
            showbuttons: 'bottom',
            placement: 'top',
            params: function(params) {
                //originally params contain pk, name and value
                params.action = 'edit_transaction_text';
                params.transaction_id = $(this).data('pk');
                params.transaction_id = $(this).data('column');
                params.transaction_type_id = params.value;

                return params;
            },
            validate: function(value) {
                if($.trim(value) == '') {
                    return 'This field is required';
                }
            },
            success: function(response, newValue) {
                console.log(response);
            }
        });
    }

    function expose_more(more_id) { 
        var more_link = '#more_link_' + more_id;
        var more_span = '#more_desc_' + more_id;
        $(more_link).hide();
        $(more_span).show();
        return false;
    }

    $(document).ready(function() {
        editable_init();

        $('.editable-transaction-status, .editable-transaction-types').on("click", function(){
            $(".select2-selection__rendered").html("Select One");
        });

        $(document).on("click", ".btn-delete", function(){
            transaction_id = $(this).data("transaction-id");
            current = this;

            $.ajax({
                type: "POST",
                url: '/ws/transaction/check_delete_transaction',
                data: { 'transaction_id': transaction_id },
                dataType: "json",
                success: function(result) {
                    console.log(result);

                    if(result.connected) {
                        swal({
                            title: 'Are you sure?',
                            html: result.msg,
                            type: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: '#3085d6',
                            cancelButtonColor: '#d33',
                            confirmButtonText: 'Yes, delete it!',
                            cancelButtonText: 'No, cancel!',
                            confirmButtonClass: 'btn btn-sm btn-success m-r-5',
                            cancelButtonClass: 'btn btn-sm btn-danger',
                            buttonsStyling: false,
                            allowOutsideClick: false
                        }).then(function () {

                            $.ajax({
                                type: "POST",
                                url: '/ws/transaction/delete_transaction',
                                data: { 'transaction_id': transaction_id, 'has_comments': result.has_comments, 'has_files': result.has_files },
                                dataType: "json",
                                success: function(result) {
                                    console.log(result);

                                    if (result) {
                                        swal('Deleted!','Transaction has been deleted.','success');
                                        $("#alert_error").addClass('hide');
                                        $(current).closest("tr").remove();
                                    }
                                    else {
                                        $("#alert_error").removeClass('hide');
                                    }
                                }
                            });

                        }, function (dismiss) {});
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

    });
</script>

{include file="includes/modal_new_transaction.tpl"}