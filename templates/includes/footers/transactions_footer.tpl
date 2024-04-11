<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
<script src="assets/plugins/select2/dist/js/select2.full.min.js"></script>

<script type="text/javascript">
    function editable_init() {
        $('.editable').editable({
            url: '/services/contact_status_manager.php',
            title: 'Enter Appointment Type Name',
            params: function(params) {
                //originally params contain pk, name and value
                params.action = 'edit_bucket';
                params.bucket_id = $(this).data('pk');
                params.bucket_name = params.value;
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
        $('.editable-transaction-status').editable({
            url: '/services/transaction_manager.php',
            title: 'Enter Transaction Status Name',
            select2: {
                width: 200,
                placeholder: 'Select country',
                allowClear: true
            },
            source: get_transaction_status({$company_id}),
            params: function(params) {
                //originally params contain pk, name and value
                params.action = 'edit_transaction_status';
                params.transaction_id = $(this).data('pk');
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
            }
        });
    });
</script>

{include file="includes/modal_new_transaction.tpl"}