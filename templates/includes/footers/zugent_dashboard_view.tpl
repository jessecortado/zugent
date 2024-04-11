
<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
<script src="assets/plugins/jquery-confirm/dist/jquery-confirm.min.js"></script>
<script src="assets/js/bootstrap-confirmation.min.js"></script>
<script src="assets/plugins/select2/dist/js/select2.full.min.js"></script>
{* 
<script type="text/javascript">
    
    $(document).ready(function() {

        var user_id;
        var current;
        var shown = 0;

        window.onerror = function(e){
            console.log(e);
            return true;
        }

        $(document).on("click", "#modal-add-user #btn-add-user", function(){
            console.log("test");
            $("#form-add-user").submit();
        });

        $('.btn-set-inactive, .btn-set-active').on("click", function(){
            user_id = $(this).data("id");
            is_active = $(this).data('is-active');
            current = this;
        });

        $('.btn-set-active').confirmation({
            title: "Are you sure you want to set this user as active?",
            placement: "left",
            btnOkLabel: "Yes",
            btnOkClass: "btn btn-sm btn-success m-r-3",
            btnCancelLabel: "No",
            singleton: true,
            onConfirm: function(event, element) { 
                $.ajax({
                    type: "POST",
                    url: '/ws/user/change_status',
                    data: { 'user_id': user_id, 'is_active': is_active },
                    dataType: "json",
                })
                .fail(function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
                })
                .success(function(response) {
                    console.log(response);
                    if(response) {
                        var transfer = $(current).closest("tr");
                        transfer.remove();
                        // $("#activeUsersTbl tbody").append(transfer);
                        window.location = "users_list.php";
                    }
                });
            },
            onCancel: function() { }
        });

        $('.btn-set-inactive').confirmation({
            title: "Are you sure you want to set this user as inactive?",
            placement: "left",
            btnOkLabel: "Yes",
            btnOkClass: "btn btn-sm btn-success m-r-3",
            btnCancelLabel: "No",
            singleton: true,
            onConfirm: function(event, element) { 
                $.ajax({
                    type: "POST",
                    url: '/ws/user/change_status',
                    data: { 'user_id': user_id, 'is_active': is_active },
                    dataType: "json",
                })
                .fail(function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
                })
                .success(function(response) {
                    console.log(response);
                    if(response) {
                        var transfer = $(current).closest("tr");
                        transfer.remove();
                        // $("#inactiveUsersTbl tbody").append(transfer);
                        window.location = "users_list.php";
                    }
                });
            },
            onCancel: function() { }
        });

        $("#show-inactive").click(function() {
            if(shown == 0) {
                $(this).html("<i class='fa fa-minus'></i> Hide Inactive Users");
                shown++;
            }
            else {
                $(this).html("<i class='fa fa-expand'></i> Show Inactive Users");
                shown--;
            }
        });

    });
</script> *}