<script src="assets/plugins/dropzone/dropzone.js"></script>

<script type="text/javascript">


    defer(deferred_method);
    function defer(method){
        if (window.jQuery)
            method();
        else
            setTimeout(function() { defer(method) }, 500);
    }

    function deferred_method() {

        var file_url = "";
        var import_id = "";
        var uploaded = false;

        Dropzone.options.myDropzone = {
            autoProcessQueue: false,
            uploadMultiple: false,
            maxFiles: 1,
            init: function() {
                // $(".needsclick").disabled(true);
                var submitButton = $("#upload-file");
                myDropzone = this;
                submitButton.on("click", function() {
                    $("#page-loader").append("<p style='position:absolute; top: 70%; left: 46.5%; margin: -20px 0 0 -20px;'>Processing File</p>");
                    $("#page-loader").removeClass('hide');
                    console.log("processing");
                    $("#panel-dropzone").addClass('hide');
                    myDropzone.processQueue(); 
                });
                this.on("sending", function(file, xhr, data) {
                    data.append("action", "upload_file");
                    data.append("pool_id", "{$id}");
                });
                this.on("addedfile", function() {
                    $("#upload-file").show();
                });
                this.on("complete", function (file) {
                  if (this.getUploadingFiles().length === 0 && this.getQueuedFiles().length === 0) {
                        console.log("done");
                        $("#page-loader").addClass('hide');
                        $("#panel-imported-data").removeClass('hide');
                        // window.location = "campaign_edit.php?id={ $smarty.request.id }";
                  }
                });
                this.on("success", function(file, response) {
                    var obj = jQuery.parseJSON(response)
                    console.log(obj);

                    var temp = jQuery.parseJSON(JSON.stringify(response));

                    var headerStr = "";
                    var bodyStr = "";

                    // for(var k in temp) {
                    //    console.log(k, temp[k]);
                    // }

                    // for(var i = 0; i < temp.length; i++) {
                    //     console.log(temp[i]);
                    //     if(i == 0) 
                    //         headerStr+="<th>" + temp[i] + "</th>";
                    //     else {

                    //     }
                    // }

                    $.each(obj.fields, function(index, val) {
                        headerStr+="<th>" + val + "</th>";
                        console.log(index + ": " + val);
                    });

                    $.each(obj.leads, function(index, row) {
                        console.log(index + ": " + row);
                        bodyStr+="<tr>";
                        $.each(row, function(key, val) {
                            bodyStr+="<td>" + val + "</td>";
                        });
                        bodyStr+="</tr>";
                    });

                    $("#tbl-leads thead tr").append(headerStr);
                    $("#tbl-leads tbody").append(bodyStr);

                    uploaded = true;
                    console.log(obj.url);
                    file_url = obj.url;
                    import_id = obj.id;
                });


            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log('XHR ERROR ' + XMLHttpRequest.status);
            }
        };

        $("#confirm-import").on("click", function() {
            if(uploaded) {
                $("#page-loader").removeClass('hide');
                $.ajax({
                    type: "POST",
                    url: '/services/upload_pool_leads.php',
                    data: { 'pool_id':'{$id}', 'file_url':file_url, 'import_id':import_id, 'action':'confirm_upload' },
                    dataType: "json",
                    success: function(result) {
                        console.log(result);
                        $("#created").html(result.created_count);
                        $("#skipped").html(result.duplicate_count);
                        $("#error").html(result.error_count);
                        $("#result-message").removeClass('hide');
                        $("#page-loader").addClass('hide');
                        $("#panel-imported-data").remove();
                        $("#panel-dropzone").remove();
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                    }
                });
            }
        });

    }

	$("#upload-file").hide();

	

</script>