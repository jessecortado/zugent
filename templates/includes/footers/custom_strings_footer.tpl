<script src="/assets/plugins/select2/dist/js/select2.min.js" defer></script>
<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js" defer></script>
<script src="assets/plugins/parsley/dist/parsley.js" defer></script>

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

    function editable_var_val_init() {
        $('.editable-company-var-val').editable({
            url: '/ws/custom_string/edit',
            title: 'Enter new value',
            ajaxOptions: { dataType: 'json' },
            params: function(params) {
                //originally params contain pk, name and value
                params.column = $(this).data('pk');
                params.value = params.value;
                params.id = $(this).data('var-id');
                return params;
            },
            validate: function(value) {
                if($.trim(value) == '') {
                    return 'This field is required';
                }
            },
            success: function(response, newValue) {
                console.log(response);
                if (response) {
                    flash_alert('#alert_success', 'Updated a custom string value.');
                    $("#alert_error").addClass('hide');
                }
                else {
                    return 'Permission Denied';
                    $("#alert_error").removeClass('hide');
                }
            }
        });
    }

    function editable_var_key_init() {
        $('.editable-company-var-key').editable({
            url: '/ws/custom_string/edit',
            title: 'Enter new value',
            params: function(params) {
                //originally params contain pk, name and value
                params.column = $(this).data('pk');
                params.value = params.value;
                params.id = $(this).data('var-id');
                return params;
            },
            validate: function(value) {
                if($.trim(value) == '') {
                    return 'This field is required';
                }
                var regex = /^[a-zA-Z]+$/;
                if(! regex.test(value)) {
                    return 'Letters only';
                }
            },
            success: function(response, newValue) {
                console.log(response);
                if (response) {
                    flash_alert('#alert_success', 'Updated a custom string key.');
                    $("#alert_error").addClass('hide');
                }
                else {
                    $("#alert_error").removeClass('hide');
                }
            }
        });
    }

    $(document).ready(function() {

        editable_var_val_init();
        editable_var_key_init();

        $("#add-custom-string").on("submit", function(e){
            e.preventDefault();
            var var_key = $("#var-key").val();
            var var_val = $("#var-val").val();

            $.ajax({
                type: "POST",
                url: '/ws/custom_string/add',
                data: { 'var_key': var_key, "var_val": var_val },
                dataType: "json",
                success: function(result) {
                    console.log(result);
                    if (result.msg) {
                        var row_html = '';
                        row_html += '<tr>';
                        row_html += '<td><a href="#custom-strings" class="editable-company-var-key" data-type="text" data-var-id="'+result.company_variable_id+'" data-pk="var_key" data-value="'+result.var_key+'">' + result.var_key + '</a></td>';
                        row_html += '<td><a href="#custom-strings" class="editable-company-var-val" data-type="text" data-var-id="'+result.company_variable_id+'" data-pk="var_val" data-value="'+result.var_val+'">' + result.var_val + '</a></td>';
                        row_html += '</tr>';
                        $("#custom-strings tbody").append(row_html);

                        editable_var_val_init();
                        editable_var_key_init();
                        $("#var-key").val("");
                        $("#var-val").val("");

                        flash_alert('#alert_success', 'Added a custom string.');
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

    });
</script>