<script src="/assets/plugins/select2/dist/js/select2.full.min.js"></script>
<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
<script src="assets/plugins/jquery-confirm/dist/jquery-confirm.min.js"></script>
<script src="assets/js/bootstrap-confirmation.min.js"></script>
<script src="assets/plugins/dropzone/dropzone.js"></script>
<script src="assets/plugins/summernote/summernote.min.js"></script>
<script src="assets/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>

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

        var val = {$user_details.is_active};
        var is_beta = {$user_details.is_beta};
        var is_admin = {$user_details.is_admin};

        $("#state").select2({ 'width': '100%' });
        $("#timezone").select2({ width: "100%" });
        {if $admin.is_superadmin eq 1 or ($user_details.is_admin eq 0 and $admin.is_admin eq 1) }

        // $(".info-toggle-box").sortable("disable");

        $('#summernote').summernote({
            placeholder: 'Hi, tell us something about yourself',
            height: "300px"
        });

        $('#summernote').on('summernote.change', function (we, contents, $editable) {
            $("#bio").html(contents);
        });

        $('#save-profile').click(function () {
            console.log("help");
            $("#form-edit-profile").submit();
        });

        $('#state').val('{$user_details.state}').trigger('change');

        $('#accept-referral').on('change', function () {
            var x = ($(this).attr("checked")) ? 1 : 0;
            $("#accepting-outside-referral").val(x);
        });

{*
        $(document).find('.editable-phone').mask('(000) 000-0000');

        $(document).find('.editable-phone-mobile').mask('(000) 000-0000',  {
            translation:  {
                'Z': { pattern: /[0-9]/, optional: true }
            }
        });

        $(document).on("blur", ".editable-phone-mobile", function() {
            var last = $(this).val().substr( $(this).val().indexOf("-") + 1 );

            if( last.length == 3 ) {
                var move = $(this).val().substr( $(this).val().indexOf("-") - 1, 1 );
                var lastfour = move + last;
                var first = $(this).val().substr( 0, 9 );

                $(this).val( first + '-' + lastfour );
            }
        });

        $('.editable').editable({
            url: '/services/generic_manager.php',
            title: 'Enter new value',
            ajaxOptions: { dataType: 'json' },
            params: function(params) {
                //originally params contain pk, name and value
                params.action = 'edit_user';
                params.column = $(this).data('pk');
                params.value = params.value;
                params.user_id = {$user_details.user_id};
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
                    flash_alert('#alert_success', 'Updated '+$(this).data('pk')+' of user.');
                    $(current).attr("data-"+$(this).data('pk'), newValue);
                    $("#alert_error").addClass('hide');
                }
                else {
                    $("#alert_error").removeClass('hide');
                }
            }
        });


        $('.editable-phone').editable({
            url: '/services/generic_manager.php',
            title: 'Enter new number',
            tpl:'   <input type="text" class="form-control input-sm editable-phone" style="padding-right: 24px;">',
            ajaxOptions: { dataType: 'json' },
            params: function(params) {
                //originally params contain pk, name and value
                params.action = 'edit_user';
                params.column = $(this).data('pk');
                params.value = params.value;
                params.user_id = {$user_details.user_id};
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
                    flash_alert('#alert_success', 'Updated '+$(this).data('pk')+' of user.');
                    $(current).attr("data-"+$(this).data('pk'), newValue);
                    $("#alert_error").addClass('hide');
                }
                else {
                    $("#alert_error").removeClass('hide');
                }
            }
        });


        $('.editable-phone-mobile').editable({
            url: '/services/generic_manager.php',
            title: 'Enter new number',
            tpl:'   <input type="text" class="form-control input-sm editable-phone-mobile" style="padding-right: 24px;">',
            ajaxOptions: { dataType: 'json' },
            params: function(params) {
                //originally params contain pk, name and value
                params.action = 'edit_user';
                params.column = $(this).data('pk');
                params.value = params.value;
                params.user_id = {$user_details.user_id};
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
                    flash_alert('#alert_success', 'Updated '+$(this).data('pk')+' of user.');
                    $(current).attr("data-"+$(this).data('pk'), newValue);
                    $("#alert_error").addClass('hide');
                }
                else {
                    $("#alert_error").removeClass('hide');
                }
            }
        });


        $('#state').editable({
            url: '/services/generic_manager.php',
            title: 'Enter new value',
            source: get_states(),
            select2: {
                width: 200,
                placeholder: 'Pick a state',
                allowClear: true
            },
            ajaxOptions: { dataType: 'json' },
            params: function(params) {
                //originally params contain pk, name and value
                params.action = 'edit_user';
                params.column = $(this).data('pk');
                params.value = params.value;
                params.user_id = {$user_details.user_id};
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
                    flash_alert('#alert_success', 'Updated '+$(this).data('pk')+' of user.');
                    $(current).attr("data-"+$(this).data('pk'), newValue);
                    $("#alert_error").addClass('hide');
                }
                else {
                    $("#alert_error").removeClass('hide');
                }
            }
        });


        $('.editable-password').editable({
            url: '/ws/user/change_password',
            title: 'Enter new value',
            ajaxOptions: { dataType: 'json' },
            params: function(params) {
                //originally params contain pk, name and value
                params.action = 'change_password';
                params.value = params.value;
                params.user_id = {$user_details.user_id};
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
                    flash_alert('#alert_success', 'Updated '+$(this).data('pk')+' of user.');
                    $(current).attr("data-"+$(this).data('pk'), newValue);
                    $("#alert_error").addClass('hide');
                }
                else {
                    $("#alert_error").removeClass('hide');
                }
            }
        }); *}


        try {
            $('#btn-reset-password').confirmation({
                title: "Are you sure you want to reset the password of this user?",
                placement: "left",
                btnOkLabel: "Reset",
                btnOkIcon: "fa fa-check",
                btnOkClass: "btn btn-sm btn-success m-r-3",
                btnCancelLabel: "Cancel",
                btnCancelIcon: "fa fa-close",
                btnCancelClass: "btn btn-sm btn-danger",
                onConfirm: function(event, element) {
                    $.ajax({
                        type: "POST",
                        url: '/ws/user/reset_password',
                        data: { 'user_id': {$user_details.user_id} },
                        dataType: "json",
                    })
                    .fail(function (XMLHttpRequest, textStatus, errorThrown) {
                        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown)
                    })
                    .success(function(response) {
                        console.log(response.result);
                        if (response) {
                            flash_alert('#alert_success', 'Set Password to Default.');
                            $("#alert_error").addClass('hide');
                        }
                        else {
                            $("#alert_error").removeClass('hide');
                        }
                    });
                },
                onCancel: function() { }
            });
        } catch(e) {}


        $('#btn-set-active').on("click", function(){
            var action = "";

            if(val == 0) {
                // action = "set_active";
                val = 1;
                $(this).html('<i class="fa fa-close"></i>Set Inactive');
            }
            else {
                // action = "set_inactive";
                val = 0;
                $(this).html('<i class="fa fa-check"></i>Set Active');
            }

            $.ajax({
                type: "POST",
                url: '/ws/user/change_status',
                data: { 'user_id': '{$user_details.user_id}', 'is_active': val },
                dataType: "json",
            })
            .fail(function (XMLHttpRequest, textStatus, errorThrown) {
                console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown)
            })
            .success(function(response) {
                console.log(response.result);
                if (response) {
                    if(val == 1) {
                        flash_alert('#alert_success', 'Activated user.');
                    }
                    else {
                        flash_alert('#alert_success', 'Deactivated user.');
                    }
                    $("#alert_error").addClass('hide');
                }
                else {
                    $("#alert_error").removeClass('hide');
                }
            });
        });

        {/if}


        {if $admin.is_beta eq '1'}

        $('.btn-set-beta').on("click", function(){
            var action = "";
            var is_checked = $(this).prop("checked");

            if(is_checked) {
                is_beta = 1;
            }
            else {
                is_beta = 0;
            }

            $.ajax({
                type: "POST",
                url: '/ws/user/beta_status',
                data: { 'user_id': '{$user_details.user_id}', 'is_beta':is_beta },
                dataType: "json",
            })
            .fail(function (XMLHttpRequest, textStatus, errorThrown) {
                console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown)
            })
            .success(function(response) {
                console.log(response);
                if (response) {
                    if(is_beta == 1) {
                        flash_alert('#alert_success', 'Set user to beta.');
                    }
                    else {
                        flash_alert('#alert_success', 'Unset beta of user.');
                    }
                    $("#alert_error").addClass('hide');
                }
                else {
                    $("#alert_error").removeClass('hide');
                }
            });
        });

        {/if}


        {if $admin.is_superadmin eq '1' or $admin.is_admin eq '1'}

        $('.btn-set-admin').on("click", function(){
            var action = "";
            var is_checked = $(this).prop("checked");

            if(is_checked) {
                is_admin = 1;
            }
            else {
                is_admin = 0;
            }

            $.ajax({
                type: "POST",
                url: '/ws/user/admin_status',
                data: { 'user_id': '{$user_details.user_id}', 'is_admin':is_admin },
                dataType: "json",
            })
            .fail(function (XMLHttpRequest, textStatus, errorThrown) {
                console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown)
            })
            .success(function(response) {
                console.log(response.result);
                if (response) {
                    if(is_admin == 1) {
                        flash_alert('#alert_success', 'Set user to administrator.');
                    }
                    else {
                        flash_alert('#alert_success', 'Unset administrator of user.');
                    }
                    $("#alert_error").addClass('hide');
                }
                else {
                    $("#alert_error").removeClass('hide');
                }
            });
        });

        {/if}


        {if $admin.is_admin eq '1'}

        $('.btn-set-coordinator').on("click", function(){
            var action = "";
            var is_checked = $(this).prop("checked");

            if(is_checked) {
                is_transaction_coordinator = 1;
            }
            else {
                is_transaction_coordinator = 0;
            }

            $.ajax({
                type: "POST",
                url: '/ws/user/coordinator_status',
                data: { 'user_id': '{$user_details.user_id}', 'is_transaction_coordinator':is_transaction_coordinator },
                dataType: "json",
            })
            .fail(function (XMLHttpRequest, textStatus, errorThrown) {
                console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown)
            })
            .success(function(response) {
                console.log(response.result);
                if (response) {
                    if(is_transaction_coordinator == 1) {
                        flash_alert('#alert_success', 'Set user to transaction coordinator.');
                    }
                    else {
                        flash_alert('#alert_success', 'Unset transaction coordinator of user.');
                    }
                    $("#alert_error").addClass('hide');
                }
                else {
                    $("#alert_error").removeClass('hide');
                }
            });
        });

        {/if}

        Dropzone.options.myDropzone = {
            autoProcessQueue: false,
            uploadMultiple: false,
            maxFiles: 1,
            init: function() {
                var submitButton = $("#upload-image");
                myDropzone = this;
                submitButton.on("click", function() {
                    $("#page-loader").append("<p style='position:absolute; top: 70%; left: 46.5%; margin: -20px 0 0 -20px;'>Processing Profile Photo</p>");
                    $("#page-loader").removeClass('hide');
                    myDropzone.processQueue();
                });
                this.on("addedfile", function() {
                    $("#upload-image").show();
                });
                this.on("complete", function (file) {
                    if (this.getUploadingFiles().length === 0 && this.getQueuedFiles().length === 0) {
                        console.log("done");
                        window.location.reload(true)
                    }
                });
                this.on("sending", function(file, xhr, formData){
                        formData.append("user_id", "{$user_details.user_id}");
                });


            },
            success: function(file, response){

            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                $.log('XHR ERROR ' + XMLHttpRequest.status);
            }
        };

        $("#upload-image").hide();

        $("#modal-pic-url .btn-success").click(function(){
            $("#url-profile-picture").submit();
        });

        /************************************************ PASSWORD RESET Section ************************************************/

        $("#btn-reset-random").on("click", function() {
            var chars = "abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNP23456789";
            var pass = "";
            for (var x = 0; x < 8; x++) {
                var i = Math.floor(Math.random() * chars.length);
                pass += chars.charAt(i);
            }
            document.getElementById('pass_val').value = pass;
			$("#frm-reset-password").parsley().reset();
        });
        
        /************************************************ User Offices Section ************************************************/
        $("#offices").select2({ placeholder: "Select an office to assign this user to", width: "100%", 'max-width': "100%" });

        $("#btn-add-office").on("click", function() {
            console.log("tsxt");
            $("#form-add-offices").submit();
        });

        $("#modal-add-office").on("hide.bs.modal", function() {
            $("#form-add-offices").parsley().reset();
        });

        $("#form-add-offices").on("submit", function(e){
            e.preventDefault();
            console.log("submittid");
            if ( $(this).parsley().isValid() ) {
                console.log("valid");
                $.ajax({
                    type: "POST",
                    url: '/ws/user/office/add',
                    data: { 'office_id': $("#offices").val(), 'user_id': '{$user_details.user_id}' },
                    dataType: "json",
                    success: function(result) {
                        var temp = JSON.parse(JSON.stringify(result));

                        if(temp.result) {
                            $("#tr-no-records").remove();

                            var row_html = '';
                            row_html += '<tr>';
                            row_html += '<td>'+$("#offices").val()+'</td>';
                            row_html += '<td width=60%>'+$("#offices option:selected").text()+'</td>';
                            row_html += '<td class="text-center">'+'<a href="javascript:;" class="btn btn-xs btn-danger m-b-5 btn-unassign" data-toggle="confirmation" data-user-rel-office-id="'+temp.id+'" data-office-id="'+$("#offices").val()+'" data-office-name="'+$("#offices option:selected").text()+'"><i class="glyphicon glyphicon-remove"></i>Unassign</a>'+'</td>';
                            row_html += '</tr>';
                            $("#officesTbl tbody").append(row_html);

                            $("#offices").find(":selected").remove();

                            flash_alert('#alert_success', 'Assigned office to user.');
                            $("#alert_error").addClass('hide');
                            $('#modal-add-office').modal('hide');
                        }
                        else {
                            $("#alert_error").removeClass('hide');
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                    }
                });
            }
        });


        $(document).on("click", ".btn-unassign",function() {
            var current = this;
            var id = $(this).data("user-rel-office-id");

            $.ajax({
                type: "POST",
                url: '/ws/user/office/remove',
                data: { 'user_rel_office_id': id, 'user_id': '{$user_details.user_id}' },
                dataType: "json",
                success: function(result) {
                    var temp = JSON.parse(JSON.stringify(result));

                    if(temp.result) {
                        $("select#offices").append('<option value="'+$(current).data("office-id")+'">'+$(current).data("office-name")+'</option>');
                        console.log()
                        $(current).closest("tr").remove();

                        if ($( "table#officesTbl tbody tr" ).length == 0) {
                            $("table#officesTbl tbody").append('<tr id="tr-no-records"><td class="text-center" colspan="4">Not assigned to any office</td></tr>');
                        }

                        flash_alert('#alert_success', 'Unassigned office to user.');
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
        /************************************************ End-User Offices Section ************************************************/

        {if $user.is_superadmin eq 1 || $user.company_id eq 1}
        /************************************************ Start-Impersonate User ************************************************/

        $("#impersonate-user").on("click", function() {
            console.log("impersonating");

            $.ajax({
                type: "POST",
                url: '/ws/user/impersonate',
                data: { 'user_id': '{$user_details.user_id}', 'company_id': '{$user_details.company_id}' },
                dataType: "json",
                success: function(result) {

                    if(result) {
                        console.log(result);
                        window.location = "dashboard.php";
                    }
                    else {

                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                }
            });

        });

        /************************************************ End-Impersonate User ************************************************/
        {/if}

    });
</script>
