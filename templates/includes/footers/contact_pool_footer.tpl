
<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
<script src="assets/plugins/select2/dist/js/select2.min.js"></script>

<script type="text/javascript">

    $(document).ready(function(){

        $("#btn-add-pool").on("click", function() {
            // var name = $("#pool-name").val();
            // var share_level = $("#share-level").val();
            // var description = $("#description").val();
            // var id = $("#pool-id").val();

            // $.ajax({
            //     type: "POST",
            //     url: '/services/pool_manager.php',
            //     data: { 'pool_name': name, 'share_level': share_level, 'description': description, 'action': $("#action").val() },
            //     dataType: "json",
            //     success: function(result) {

            //         $("#tbl-pool").append('<tr><td>'+result.id+'</td><td>'+
            //                     name+'</td><td>'+
            //                     share_level+'</td><td>'+
            //                     result.date_created+'</td><td>'+
            //                     +'</td><td>'+
            //                     result.uploaded_by+'</td></tr>'
            //                     );

            //         editable_init();
                    
            //         $('#modal-add-pool').modal('hide');

            //     },
            //     error: function (XMLHttpRequest, textStatus, errorThrown) {
            //         console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
            //     }
            // });
            $("#form-add-pool").submit();
        });

    });
</script>