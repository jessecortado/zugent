
<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
<script src="assets/plugins/bootstrap-datetimepicker/js/bootstrap-datetimepicker.min.js"></script>
<script src="assets/js/jquery.validate.min.js"></script>
<script src="assets/plugins/jquery-confirm/dist/jquery-confirm.min.js"></script>
<script src="assets/plugins/dropzone/dropzone.js"></script>
<script src="assets/js/bootstrap-confirmation.min.js"></script>
<script src="assets/plugins/select2/dist/js/select2.full.min.js"></script>

<script type="text/javascript">

    function editable_init() {

    }

    function add_comment() {
        var comment = $('#comment').val();
        $.ajax({
            type: "POST",
            url: '/services/add_transaction_comment.php',
            data: { 'id': {$transaction.transaction_id}, comment: comment },
            success: function(result) {
                if (result == "1") {
                    $('#commentsTbl tr:last').after("<tr><td style='width:200px;'><b>{$user.first_name} {$user.last_name}</b><br/><small>Just Now</small></td><td>" + comment + "</td></tr>");
                    $('#comment').val("");
                } else {
                    alert("An Error has occured." + result);
                }
            },
            dataType: "json"
        });
    }

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

    function expose_more(more_id) { 
        var more_link = '#more_link_' + more_id;
        var more_span = '#more_desc_' + more_id;
        $(more_link).hide();
        $(more_span).show();
        return false;
    }

    function check_mls() {
        if ($("#is-on-mls").val() == "1") {
            $("#chk-mls").prop("checked",false)
            $("#is-on-mls").val("0");
            $("#listing-group").addClass('hide');
        }
        else {
            $("#chk-mls").prop("checked",true)
            $("#is-on-mls").val("1");
            $("#listing-group").removeClass('hide');
        }
    }


    $(document).ready(function() {
        
        $("#chk-mls").on("click", function() {
            check_mls();
        });
        
        if ($("#is-on-mls").val() == "0") {
            $("#listing-group").addClass('hide');
        }
        else {
            $("#listing-group").removeClass('hide');
        }

        $("select").select2({ width: "100%" });
        var checklist = $("#company-checklists").select2({ width: "100%" });
        $(".date").datepicker({ todayHighlight: true, dateFormat: 'yy-mm-dd' });
        $("#state").val("{$transaction.state}");

        editable_init();

        $('.editable-transaction-status, .editable-transaction-types').on("click", function(){
            $(".select2-selection__rendered").html("Select One");
        });

        $("#btn-add-checklist").on("click", function() {
            // e.preventDefault();
            // $("#page-loader").removeClass('hide');
            var checklist_id = $("#company-checklists").val();

            if (checklist_id !== "") {
                $("#page-loader").removeClass('hide');
                $("#error-add-checklist").addClass('hide');
                $.ajax({
                    type: "POST",
                    url: '/services/add_checklist_to_transaction.php',
                    data: { 'checklist_id': checklist_id, 'transaction_id': {$transaction.transaction_id} },
                    dataType: "json",
                    success: function(result) {
                        console.log(result.id);
                        $("#company-checklists option:selected").remove();
                        $("#company-checklists").val("");
                        var url = "/transaction/{$transaction.transaction_id}#panel-checklist-"+result.id;
                            window.location = "/transaction/{$transaction.transaction_id}#panel-checklist-"+result.id;
                        location.reload();
                    }
                });
                // window.location.href = ("/transaction/{$transaction.transaction_id}#panel-checklist-"+result.id);
            }
            else {
                // alert("Please select a checklist to be added");
                $("#error-add-checklist").removeClass('hide');
            }
            // return false;
        });

        var current;

        $(document).on("click", ".btn-remove-checklist", function() {
            current = $(this);
            $(this).confirmation('show');
            // jump page fix
            $('.popover-content a').removeAttr('href');
        });

        $(document).on("click", ".check-agent-step", function() {
            var id = $(this).data("checklist-step-id");
            var value = 0;

            if ($(this).prop("checked"))
                value = 1;

            $.ajax({
                type: "POST",
                url: '/services/check_checklist_step.php',
                data: { 'checklist_step_id': id, 'agent_checked': value, 'transaction_id': {$transaction.transaction_id} },
                success: function(result) {
                    if (result == 1) {
                        window.location = "transaction/{$transaction.transaction_id}#panel-checklist-"+id;
                        location.reload();
                    } 
                },
                dataType: "text"
            });
        });

        $(document).on("click", ".check-admin-step", function() {
            var id = $(this).data("checklist-step-id");
            var value = 0;

            if ($(this).prop("checked"))
                value = 1;


            $.ajax({
                type: "POST",
                url: '/services/check_checklist_step.php',
                data: { 'checklist_step_id': id, 'admin_checked': value, 'transaction_id': {$transaction.transaction_id} },
                success: function(result) {
                    if (result == 1) {
                        window.location = "transaction/{$transaction.transaction_id}#panel-checklist-"+id;
                        location.reload();
                    } 
                },
                dataType: "text"
            });

        });

        $(document).on("click", "#save-extended-data", function() {
            $("#page-loader").removeClass('hide');
            $.ajax({
                type: "POST",
                url: '/services/save_extended_data.php',
                data: { 'extended_data': $("#extended-data").val(), 'transaction_id': {$transaction.transaction_id} },
                success: function(result) {
                    location.reload();
                },
                dataType: "text"
            });

        });

        $('.btn-remove-checklist[data-toggle="confirmation"]').confirmation({
            title: 'Are you sure you want to remove this checklist from this transaction?',
            placement: "left",
            btnOkLabel: "Yes",
            btnOkIcon: "fa fa-check",
            btnOkClass: "btn btn-sm btn-success m-r-3",
            btnCancelLabel: "No",
            btnCancelClass: "btn btn-sm btn-danger",
            onConfirm: function(event, element) { 
                
                var checklist_id = $(current).data("checklist-id");
                var checklist_name = $(current).data("checklist-name");

                $.ajax({
                    type: "POST",
                    url: '/services/remove_checklist_from_transaction.php',
                    data: { 'checklist_id': checklist_id, 'transaction_id': {$transaction.transaction_id} },
                    success: function(result) {
                        if (result == 1) {
                            $("#panel-checklist-"+$(current).data('trc-id')).remove();
                            $("#company-checklists option:last-child").after('<option value="'+checklist_id+'">'+checklist_name+'</option>');
                            $("#company-checklists").select2({ width: "100%" });
                            
                        } 
                    },
                    dataType: "text"
                });
            },
            onCancel: function() { }
        });

        $("#btn-save-transaction").on("click", function() {
            $("#form-edit-transaction").submit();
        });

        $("#modal-edit-transaction").on("hide.bs.modal", function() {
            $("#form-edit-transaction").parsley().reset();
        });

        Dropzone.options.myDropzone = {
            autoProcessQueue: false,
            uploadMultiple: false,
            maxFiles: 1,
            init: function() {
                var submitButton = $("#upload-file");
                var target = $('#my-dropzone').closest('.panel');
                myDropzone = this;
                submitButton.on("click", function() {
                    if (myDropzone.getQueuedFiles().length > 0) {
                            $('#no-file-uploaded').addClass('hide');
                        if ($("#transaction-file-type").val() != '') {
                            if (!$(target).hasClass('panel-loading')) {
                                var targetBody = $(target).find('.panel-body');
                                var spinnerHtml = '<div class="panel-loader"><span class="spinner-small"></span></div>';
                                $(target).addClass('panel-loading');
                                $(targetBody).prepend(spinnerHtml);
                            }
                            myDropzone.processQueue();
                            $('#no-transaction-file-type').addClass('hide');
                        }
                        else {
                            $('#no-transaction-file-type').removeClass('hide');
                        }
                    }
                    else {
                        $('#no-file-uploaded').removeClass('hide');
                    }
                });
                this.on("sending", function(file, xhr, data) {
                    data.append("transaction_id", "{$transaction.transaction_id}");
                    data.append("file_type_id", $("#transaction-file-type").val());
                });
                this.on("addedfile", function() {
                    $("#upload-image").show();
                });
                this.on("complete", function (file) {
                    if (this.getUploadingFiles().length === 0 && this.getQueuedFiles().length === 0) {
                        console.log("done");
                        console.log("COMPLETE: "+file.xhr.respnse);
                        window.location = "/transaction/{$transaction.transaction_id}";
                    }
                });
                this.on("success", function(file, xhr){
                    // alert(file.xhr.response);
                    console.log(file.xhr.respnse);
                });
                this.on("error", function(XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status);
                });

            },
            success: function(file, response){

            }
        };

        $("#upload-file").click(function(){
            console.log("here");
            $("#file-type-id").val($("#contact-file-type").val());
            // $("#my-dropzone").submit();
        });

        $(document).on("click", ".edit-transaction-file", function() {
            $("#modal-transaction-file-name").val($(this).data("file-name"));
            $("#modal-transaction-file-type").val($(this).data("transaction-file-type"));
            $("#modal-transaction-file-id").val($(this).data("transaction-file-id"));
            $("#modal-transaction-file-id").val($(this).data("transaction-file-id")).trigger('change');
            // $("#select2-modal-transaction-file-type-container").html($("modal-transaction-file-type").find(":selected").text());
            $("#select2-modal-transaction-file-type-container").html($(this).data("file-type-name"));
            console.log($(this).data("file-name") + " " +
            $(this).data("transaction-file-type") + " " +
            $(this).data("file-type-name") + " " +
            $(this).data("transaction-file-id"));
        });

        $("#modal-transaction-file-type").on("change", function(){
            // $("#modal-transaction-file-type").val($(this).val(value).trigger("change"));
            // $("#select2-modal-transaction-file-type-container").html($(this).val());
        });

        $(".btn-delete-transaction-file").on("click", function(e) {
            e.preventDefault();
            current = this;
        });

        $(".btn-restore-transaction-file").on("click", function(e) {
            e.preventDefault();
            current = this;
        });

        $("#save-transaction-file").click(function() {
            $("#form-edit-transaction-file").submit();
        });

        $('.btn-delete-transaction-file').confirmation({
            title: "Are you sure you want to delete this file?",
            placement: "left",
            btnOkLabel: "Yes",
            btnOkIcon: "fa fa-check",
            btnOkClass: "btn btn-sm btn-success m-r-3",
            btnCancelLabel: "No",
            btnCancelClass: "btn btn-sm btn-danger",
            onConfirm: function(event, element) { 
                confirm_delete_transaction_file($(current).data("transaction-file-id"), {$transaction.transaction_id});
                $(current).closest('tr').remove();
            },
            onCancel: function() { }
        });

        $('.btn-restore-transaction-file').confirmation({
            title: "Are you sure you want to restore this file?",
            placement: "left",
            btnOkLabel: "Yes",
            btnOkIcon: "fa fa-check",
            btnOkClass: "btn btn-sm btn-success m-r-3",
            btnCancelLabel: "No",
            btnCancelClass: "btn btn-sm btn-danger",
            onConfirm: function(event, element) { 
                confirm_restore_transaction_file($(current).data("transaction-file-id"), {$transaction.transaction_id});
                $(current).closest('tr').remove();
            },
            onCancel: function() { }
        });

        var shownDeletedFiles = 0;

        // $("#toggle-deleted-files").on("click", function(){
        //     if(shownDeletedFiles == 0) {
        //         $("#deletedTransactionFilesTbl").toggleClass('hide');
        //         $(this).html("Hide Deleted File/s");
        //         shownDeletedFiles++;
        //     }
        //     else {
        //         $("#deletedTransactionFilesTbl").toggleClass('hide');
        //         $(this).html("Show Deleted File/s");
        //         shownDeletedFiles--;
        //     }
        // });

        $(document).on("click", "#toggle-deleted-files", function() {
            if(shownDeletedFiles == 0) {
                $(this).html('<i class="fa fa-minus"></i> Hide Deleted Files');
                shownDeletedFiles++;
            }
            else {
                $(this).html('<i class="fa fa-expand"></i> Show '+{$deleted_transaction_files|count}+' Deleted Files');
                shownDeletedFiles--;
            }
        });

        $("#modal-save-transaction-comment").click(function() {
            $("#form-add-transaction-comment").submit();
        });

        $('#modal-add-transaction-comment').on('hide.bs.modal', function (){
            $("#form-add-transaction-comment").parsley().reset();
        });

        $("#form-add-transaction-comment").on('submit',function(e) {
            e.preventDefault(); //=== To Avoid Page Refresh and Fire the Event "Click"===
            if ( $(this).parsley().isValid() ) {
                var comment = $('#comment').val();
                $.ajax({
                    type: "POST",
                    url: '/services/add_transaction_comment.php',
                    data: { 'id': {$transaction.transaction_id}, comment: comment },
                    success: function(result) {
                        if (result == "1") {
                            $('#commentsTbl tr:first').after("<tr><td style='width:200px;'><b>{$user.first_name} {$user.last_name}</b><br/><small>Just Now</small></td><td>" + comment + "</td></tr>");
                            $('#comment').val("");
                            $('#form-add-transaction-comment').parsley().reset();

                            $("table#commentsTbl tbody tr").each(function() {
                                if ($("table#commentsTbl tbody tr").hasClass('no-data')) { 
                                    $("table#commentsTbl tbody tr").remove();
                                }
                            });

                            $('#modal-add-transaction-comment').modal('hide');
                            flash_alert('#alert_success_comment', 'Added a comment.');
                        } else {
                            alert("An Error has occured." + result);
                        }
                    },
                    dataType: "json"
                });
            }
        });

    });
</script>
