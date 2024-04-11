    <script src="assets/plugins/dropzone/dropzone.js"></script>
    <script src="assets/plugins/sweetalert2/js/sweetalert2.all.min.js"></script>
    <script src="/assets/plugins/select2/dist/js/select2.full.min.js"></script>
    <script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
    
    <script type="text/javascript">
        var user_id;
        var unset_admin = 0;

        $("#timezone").editable({
            url: '/services/generic_manager.php',
            value: "{$user.timezone}", // The option with this value should be selected
            source: [
            {foreach item=row from=$timezones}
            { value: "{$row.value}", text: "{$row.name}" },
            {/foreach}
            ],
            select2: {
                width: 200,
                placeholder: 'Select timezone',
                allowClear: true,
                dropdownCssClass: "x-editable-select2",
            },
            
            params: function(params) {
                //originally params contain pk, name and value
                params.action = 'edit_my_profile';
                params.column = $(this).data('pk');
                params.value = params.value;
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

        $('.editable').editable({
            url: '/services/generic_manager.php',
            title: 'Enter new value',
            params: function(params) {
                //originally params contain pk, name and value
                params.action = 'edit_my_profile';
                params.column = $(this).data('pk');
                params.value = params.value;
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

        $('.editable-phone').editable({
            url: '/services/generic_manager.php',
            title: 'Enter new number',
            tpl:'   <input type="text" class="form-control input-sm editable-phone" style="padding-right: 24px;">',
            params: function(params) {
                //originally params contain pk, name and value
                params.action = 'edit_my_profile';
                params.column = $(this).data('pk');
                params.value = params.value;
                return params;
            },
            validate: function(value) {
                if($.trim(value) == '') {
                    return 'This field is required';
                }
                if(value.length < 14) {
                    return 'Phone format is invalid';
                }
            },
            success: function(response, newValue) {
                console.log(response);
            }
        });

        $('.editable-phone-mobile').editable({
            url: '/services/generic_manager.php',
            title: 'Enter new number',
            tpl:'   <input type="text" class="form-control input-sm editable-phone-mobile" style="padding-right: 24px;">',
            params: function(params) {
                //originally params contain pk, name and value
                params.action = 'edit_my_profile';
                params.column = $(this).data('pk');
                params.value = params.value.replace(/[^\d\+]/g,"");
                return params;
            },
            validate: function(value) {
                if($.trim(value) == '') {
                    return 'This field is required';
                }
                if(value.length < 14) {
                    return 'Phone format is invalid';
                }
            },
            success: function(response, newValue) {
                console.log(response);
            }
        });

        $('#state').editable({
            url: '/services/generic_manager.php',
            title: 'Enter new value',
            source: get_states(),
            select2: {
                width: 200,
                placeholder: 'Select state',
                allowClear: true,
                dropdownCssClass: "x-editable-select2",
            },
            
            params: function(params) {
                //originally params contain pk, name and value
                params.action = 'edit_my_profile';
                params.column = $(this).data('pk');
                params.value = params.value;
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

        // $(document).find('.editable-phone').mask('(000) 000-0000');
        $(document).find('.editable-phone-mobile').mask('(000) 000-0000');

        $('.editable-phone-mobile, .editable-phone').on('shown', function () {
            $(this).data('editable').input.$input.mask('(999) 999-9999');
        });

        {* Changed on 2-1-18
            $(document).find('.editable-phone-mobile').mask('(99) 9999Z9-9999',  {
            translation:  {
                'Z': { pattern: /[0-9]/, optional: true }
            }
        }); *}

        $(document).on("blur", ".editable-phone-mobile", function() {
            var last = $(this).val().substr( $(this).val().indexOf("-") + 1 );

            if( last.length == 3 ) {
                var move = $(this).val().substr( $(this).val().indexOf("-") - 1, 1 );
                var lastfour = move + last;
                var first = $(this).val().substr( 0, 9 );

                $(this).val( first + '-' + lastfour );
            }
        });

        Dropzone.options.myDropzone = {
            autoProcessQueue: false,
            uploadMultiple: false,
            maxFiles: 1,
            init: function() {
                // $(".needsclick").disabled(true);
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
                        window.location = "my_profile.php";
                  }
                });

            },
            success: function(file, response){

            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                $.log('XHR ERROR ' + XMLHttpRequest.status);
            }
        };

        Dropzone.options.emailHeader = {
            autoProcessQueue: false,
            uploadMultiple: false,
            maxFiles: 1,
            init: function() {
                var submitButton = $("#upload-email-header");
                emailHeader = this;
                submitButton.on("click", function() {
                    $("#page-loader").append("<p style='position:absolute; top: 70%; left: 46.5%; margin: -20px 0 0 -20px;'>Processing Email Header Photo</p>");
                    $("#page-loader").removeClass('hide');
                    emailHeader.processQueue(); 
                });
                this.on("addedfile", function() {
                    $("#upload-email-header").show();
                });
                this.on("complete", function (file) {
                    if (this.getUploadingFiles().length === 0 && this.getQueuedFiles().length === 0) {
                        console.log("done");
                        window.location = "my_profile_edit.php";
                    }
                });

            },
            success: function(file, response){

            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                $.log('XHR ERROR ' + XMLHttpRequest.status);
            }
        };

        $("#modal-pic-url .btn-success").click(function(){
            $("#url-profile-picture").submit();
        });
        
        $("#upload-image").hide();
    	$("#upload-email-header").hide();


        $(document).on("click", ".btn-unset-admin", function(){
            this.checked = true;

            user_id = $(this).data("id");

            swal({
                title: 'Are you sure?',
                html: "You won't be able to revert this!",
                type: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, unset it!',
                cancelButtonText: 'No, cancel!',
                confirmButtonClass: 'btn btn-sm btn-success m-r-5',
                cancelButtonClass: 'btn btn-sm btn-danger',
                buttonsStyling: false,
                allowOutsideClick: false
            }).then(function () {
                
                $.ajax({
                    type: "POST",
                    url: '/ws/user/admin_status',
                    data: { 'user_id': user_id, 'is_admin': unset_admin },
                    dataType: "json",
                    success: function(result) {
                        if(result) {
                
                            $.ajax({
                                type: "POST",
                                url: '/ws/users/update_session',
                                data: { 'user_id': user_id },
                                dataType: "json",
                                success: function(result) {
                                    console.log("HERE!!!");
                                    if(result) {
                                        window.location = "dashboard.php";
                                    }
                                    else {
                                        $("#alert_error").removeClass('hide');
                                    }
                                },
                                error: function (XMLHttpRequest, textStatus, errorThrown) {
                                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
                                }
                            });
                            // window.location = "/ws/users/update_session";
                        }
                        else {
                            $("#alert_error").removeClass('hide');
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
                    }
                });

            }, function (dismiss) {});
 
        });

        // $(document).on("click", "#upload-image", function(){
        // });

    </script>