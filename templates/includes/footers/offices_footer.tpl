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
              $(element).addClass('hide');
          });
        }, 2000);
    }

    $(document).ready(function() {

        /************************************************ Plugin Intialization ************************************************/
        $("#state").select2({
            placeholder: "Select an office", 
            width: "100%", 
            'max-width': "100%"
        });
        $("select").select2({ width:'100%' });
        /************************************************ End-Plugin Intialization ************************************************/

        $("#btn-show-add-office").on("click", function() {
            $("#modal-edit #office-id").val("");
            $("#modal-edit #office-name").val("");
            $("#modal-edit #street-address").val("");
            $("#modal-edit #city").val("");
            $("#modal-edit #state").val("");
            $("#modal-edit #zip").val("");
            $("#modal-edit #phone-office").val("");
            $("#modal-edit #phone-fax").val("");
            $("#modal-edit .modal-title").val("Add Office");
            $("#div-mls-office").hide();
        });


        $(".btn-edit-office").on("click", function() {
            var parent = $(this).closest('tr');
            $("#modal-edit #office-id").val($(parent).data("office-id"));
            $("#modal-edit #office-name").val($(parent).data("name"));
            $("#modal-edit #street-address").val($(parent).data("street-address"));
            $("#modal-edit #city").val($(parent).data("city"));
            $("#modal-edit #state").val($(parent).data("state")).trigger('change');
            $("#modal-edit #zip").val($(parent).data("zip"));
            $("#modal-edit #phone-office").val($(parent).data("phone-office"));
            $("#modal-edit #phone-fax").val($(parent).data("phone-fax"));
            $("#modal-edit #form-office").attr("action", "/ws/office/edit");
            $("#modal-edit .modal-title").val("Edit Office");
            $("#div-mls-office").show();
            $("#mls-office").html();
            $("#mls-office").prop("disabled", true);
            $("#tbl-mls-offices tbody").html("");
            $("#select-mls").val("").change();
            
            $.ajax({
                type: "POST",
                url: 'ws/office/get_linked_offices',
                data: { 'office_id': $(this).closest('tr').data("office-id") },
                dataType: "json",
                success: function(result) {
                    var temp = JSON.parse(JSON.stringify(result));
                    console.log(temp);
                    $.each(temp.data, function(index, val) {
                        $("#tbl-mls-offices tbody").append('<tr data-mls-id="'+val.mls_id+'"data-mls-office-id="'+val.office_id+'"><td class="text-center">' + val.office_name + '</td><td class="text-center">' + val.city + '</td><td class="text-center">'+val.state.toUpperCase()+'</td><td class="text-center"><a class="btn btn-danger btn-xs btn-unlink">x</a></td></tr>');
                    });
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                }
            });
        });

        $("#select-mls").on("change", function() {
            var id = $(this).find(":selected").val();
            if (id !== "") {
                $.ajax({
                    type: "POST",
                    url: 'ws/office/get_mls_offices',
                    data: { 'mls_id': id },
                    dataType: "json",
                    success: function(result) {
                        console.log(result);
                        $("#mls-office").html("");
                        $("#mls-office").append('<option value="">Select Office</option>');
                        $("#mls-office").prop("disabled", false);
                        var temp = JSON.parse(JSON.stringify(result));
                        $.each(temp.data, function(index, val) {
                            $("#mls-office").append('<option value=' + val.office_id + '>' + val.office_name + '</option>');
                        });
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                    }
                });
            }
            else {
                $("#mls-office").html("");
                $("#mls-office").prop("disabled", true);
            }
        });

        $("#form-link-office").on("submit", function(e) {
            e.preventDefault();
            $.ajax({
                type: "POST",
                url: 'ws/office/link_mls_office',
                data: $(this).serialize(),
                dataType: "json",
                success: function(result) {
                    console.log(result);
                    if (result) {
                        $("#tbl-mls-offices tbody").append('<tr data-mls-office-id="' + result.mls_office_id + '" data-office-id="' + result.office_id + '" data-mls-id="'+ result.mls_id +'"><td class="text-center">' + $("#mls-office").select2('data')[0].text + '</td><td class="text-center">' + "reload" + '</td><td class="text-center">'+ "reload" +'</td><td class="text-center"><a class="btn btn-danger btn-xs btn-unlink">x</a></td></tr>');
                        flash_alert('#alert-success-mls', 'Finished linking an office!');
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                }
            });
            return false;
        });

        $(document).on("click", ".btn-unlink", function() {
            
            var parent = $(this).closest('tr');

            $.ajax({
                type: "POST",
                url: 'ws/office/unlink_mls_office',
                data: {
                    "office_id": $("#office-id").val(),
                    "mls_office_id": $(parent).data("mls-office-id"),
                    "mls_id": $(parent).data("mls-id")
                },
                dataType: "json",
                success: function(result) {
                    console.log(result);
                    if (result) {
                        $(parent).remove();
                        flash_alert('#alert-success-mls', 'Unlinked an office!');
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                }
            });
        });


        $('#modal-edit').on('hide.bs.modal', function (){
            $('#form-office').parsley().reset();
        });


        $(document).on('click',"#btn-add-office", function() {
            $("#form-office").submit();
        });

        var newValue = "";

        $('.editable').editable({
            url: '/ws/office/edit',
            title: 'Enter new value',
            source: get_states(),
            select2: {
                width: 200,
                placeholder: 'Select State',
                allowClear: true,
                dropdownCssClass: "x-editable-select2",
            },
            ajaxOptions: { dataType: 'json' },
            params: function(params) {
                //originally params contain pk, name and value
                params.column = $(this).data('pk');
                params.value = params.value;
                newValue = params.value;
                var parent = $(this).closest('tr');
                $(parent).data($(this).data('pk'),newValue);
                params.office_id = $(this).data('office-id');
                return params;
            },
            validate: function(value) {
                if($.trim(value) == '') {
                    return 'This field is required';
                }
            },
            success: function(response, newValue) {
                console.log(response);
                var current = $(this).closest('tr');
                if (response) {
                    flash_alert('#alert_success', 'Updated '+$(this).data('pk')+' of office.');
                    $(current).attr("data-"+$(this).data('pk'), newValue);
                    $("#alert_error").addClass('hide');
                }
                else {
                    $("#alert_error").removeClass('hide');
                }
            }
        });


        $(document).on("click", ".chk-toggle-status", function(){
            var is_active;

            if($(this).is(":checked") || $(this).prop( "checked" ))
                is_active = 1;
            else
                is_active = 0;

            $.ajax({
                type: "POST",
                url: '/ws/office/set_active',
                data: { 'office_id': $(this).closest('tr').data("office-id"), 'is_active': is_active },
                dataType: "json",
                success: function(result) {
                    console.log(result);
                    if (result) {
                        flash_alert('#alert_success', (is_active == 1) ? 'Activated an office.' : 'Deactivated an office.');
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

    });

</script>