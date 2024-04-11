<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
<script src="assets/plugins/sweetalert2/js/sweetalert2.all.min.js"></script>
<script src="assets/plugins/select2/dist/js/select2.min.js"></script>
<script src="assets/plugins/bootstrap-tagsinput/bootstrap-tagsinput.min.js"></script>
<script src="assets/plugins/bootstrap-tagsinput/bootstrap-tagsinput-typeahead.js"></script>
<script src="assets/plugins/jquery-tag-it/js/tag-it.min.js"></script>

<script type="text/javascript">

    var bucket_id, current, removed_tags = [];

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

    function editable_init() {
        $('.editable').editable({
            url: '/ws/bucket/edit_bucket',
            title: 'Enter Appointment Type Name',
            ajaxOptions: { dataType: 'json' },
            params: function(params) {
                //originally params contain pk, name and value
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
                if (!response) {
                    return 'Permission Denied';
                    $("#alert_error").removeClass('hide');
                }
                else {
                    flash_alert('#alert_success', 'Updated bucket name.');
                    $('#alert_error').addClass('hide');
                }
            }
        });
    }

    $(document).ready(function() {

        $(".bootstrap-tagsinput input").focus(function() {
            $(this).closest(".bootstrap-tagsinput").addClass("bootstrap-tagsinput-focus");
        });

        $(".bootstrap-tagsinput input").focusout(function() {
            $(this).closest(".bootstrap-tagsinput").removeClass("bootstrap-tagsinput-focus");
        });

        $("#bucket-tags").tagit({
            availableTags: {$tags|json_encode},
            caseSensitive: false,
            beforeTagRemoved: function(event, ui) {
                // console.log(ui.tag[0].firstElementChild.innerText);
                removed_tags.push(ui.tag[0].firstElementChild.innerText);
            }
        });

        $(document).on("click", ".btn-tags", function(){
            $("#bucket-id").val($(this).data('bucket-id'));
            $("#bucket-tags").tagit("removeAll");
            removed_tags = [];

            $.ajax({
                type: "POST",
                url: '/ws/bucket/fetch_tags',
                data: { 'bucket_id': $(this).data('bucket-id') },
                dataType: "json",
                success: function(result) {
                    if (result.msg) {
                        if (result.tags.length != 0) {
                            $.each(result.tags, function(index, val) {
                                $("#bucket-tags").tagit("createTag", val);
                            });
                        }
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

        $(document).on("click", "#update-tags", function(){
            var tag_names = $("#bucket-tags").tagit("assignedTags");

            $.ajax({
                type: "POST",
                url: '/ws/bucket/update_tags',
                data: { 'bucket_id': $("#bucket-id").val(), 'tags': tag_names, 'removed_tags': removed_tags },
                dataType: "json",
                success: function(result) {
                    if (result) {
                        $("#modal-add-tag").modal('hide');
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

        editable_init();

        $("#add-bucket").on("submit", function(e){
            e.preventDefault();
            var bucket_name = $("#bucket-name").val();
            $.ajax({
                type: "POST",
                url: '/ws/bucket/add_bucket',
                data: { 'bucket_name': bucket_name },
                dataType: "json",
                success: function(result) {
                    console.log(result.msg);

                    if (result.msg) {
                        var row_html = '';
                        row_html += '<tr>';
                        row_html += '<td>'+result.bucket_id+'</td>';
                        row_html += '<td class="text-center"><a href="#" class="editable" data-type="text" data-pk="'+result.bucket_id+'" data-value="'+result.bucket_name+'">'+result.bucket_name+'</a></td>';
                        row_html += '<td class="text-center"><div class="checkbox checkbox-css checkbox-success"><input id="checkbox_css_'+result.bucket_id+'" class="dashboard-checkbox" data-bucket-id="'+result.bucket_id+'" type="checkbox"><label for="checkbox_css_'+result.bucket_id+'"></label></div>';
                        row_html += '<td class="text-center">';
                        row_html += '<a href="#modal-add-tag" class="btn btn-xs btn-primary m-r-5 m-b-5 btn-tags" data-toggle="modal" data-bucket-id="'+result.bucket_id+'"><i class="fa fa-tags"></i>Tags</a>';
                        row_html += ' ';
                        row_html += '<a href="javascript:;" class="btn btn-xs btn-danger m-b-5 btn-delete" data-bucket-id="'+result.bucket_id+'"><i class="glyphicon glyphicon-remove"></i>Delete</a>';
                        row_html += '</td>';
                        row_html += '</tr>';
                        $("#buckets tbody").append(row_html);

                        editable_init();
                        $("#bucket-name").val("");

                        flash_alert('#alert_success', 'Added a bucket.');
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

        $(document).on("click", ".dashboard-checkbox", function(){
            var bucket_id = $(this).data("bucket-id");
            var current = this;
            
            $.ajax({
                type: "POST",
                url: '/ws/bucket/show_dashboard',
                data: { 'bucket_id': bucket_id, 'value' : $(current).is(":checked") },
                dataType: "json",
                success: function(result) {
                    console.log(result);

                    if (result) {
                        flash_alert('#alert_success', ($(current).is(":checked")) ? 'Show bucket on dashboard.' :'Unshow bucket on dashboard.');
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

        $(document).on("click", ".btn-delete", function(){
            bucket_id = $(this).data("bucket-id");
            current = this;

            $.ajax({
                type: "POST",
                url: '/ws/bucket/check_delete_bucket',
                data: { 'bucket_id': bucket_id },
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
                                url: '/ws/bucket/delete_bucket',
                                data: { 'bucket_id': bucket_id, 'tag_ids': result.tag_ids, 'has_tags': result.has_tags },
                                dataType: "json",
                                success: function(result) {
                                    console.log(result);

                                    if (result) {
                                        swal('Deleted!','Bucket has been deleted.','success');
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
