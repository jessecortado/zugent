<script src="/assets/plugins/select2/dist/js/select2.full.min.js"></script>
<script src="assets/plugins/dropzone/dropzone.js"></script>
<script src="assets/plugins/summernote/summernote.min.js" defer></script>

<script type="text/javascript">

$(document).ready(function() {
	$("#shared_level").select2({
		minimumResultsForSearch: -1
	});
	
    $("#add-custom-string").on("click", function(){
        var var_key = $("#var-key").val();
        var var_val = $("#var-val").val();
        var campaign_id = {$campaign_id};
        var field = $('#form-add-custom-string').parsley();
        field.validate();

        console.log(field.isValid());
        if(field.isValid()) {

            $.ajax({
                type: "POST",
                url: '/services/custom_strings_manager.php',
                data: { 'action':'add_campaign_variable', 'var_key': var_key, "var_val": var_val, "campaign_id": campaign_id},
                dataType: "json",
                success: function(result) {
                    console.log(result);

                    $("#custom-strings tbody").append('<tr><td><a href="#custom-strings" class="editable-campaign-var" data-type="text" data-var-id="'+result.campaign_variable_id+'" data-pk="var_key" data-value="'+result.var_key+'">' + result.var_key + '</a></td><td><a href="#custom-strings" class="editable-campaign-var" data-type="text" data-var-id="'+result.campaign_variable_id+'" data-pk="var_val" data-value="'+result.var_val+'">' + result.var_val + '</a></td></tr>');

                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
                }
            });

    }
    else
        console.log("not valid");
    });



var editable = $('.editable-campaign-var-val').editable({
    url: '/services/custom_strings_manager.php',
    title: 'Enter new value',
    tpl:'<input type="text" class="form-control input-sm" data-type="alphanum" data-parsley-required="true" style="padding-right: 24px;">',
    params: function(params) {
            //originally params contain pk, name and value
            params.action = 'edit_campaign_variable';
            params.column = $(this).data('pk');
            params.value = params.value;
            params.id = $(this).data('var-id');
            return params;
        },
        validate: function(value) {
            var regex = /^[a-zA-Z]+$/;
            if(value == "") {
                return 'this field is required';
            }
            // var form = editable.next().find('form');
            // if (!form.parsley().isValid()) {
            //     return true;
            // }
        },
        success: function(response, newValue) {
            console.log(response);
        }
    });

var editable = $('.editable-campaign-var-key').editable({
    url: '/services/custom_strings_manager.php',
    title: 'Enter new value',
    tpl:'<input type="text" class="form-control input-sm" data-type="alphanum" data-parsley-required="true" style="padding-right: 24px;">',
    params: function(params) {
            //originally params contain pk, name and value
            params.action = 'edit_campaign_variable';
            params.column = $(this).data('pk');
            params.value = params.value;
            params.id = $(this).data('var-id');
            return params;
        },
        validate: function(value) {
            var regex = /^[a-zA-Z]+$/;
            if(! regex.test(value)) {
                return 'letters only';
            }
            // var form = editable.next().find('form');
            // if (!form.parsley().isValid()) {
            //     return true;
            // }
        },
        success: function(response, newValue) {
            console.log(response);
        }
    });
Dropzone.options.myDropzone = {
    autoProcessQueue: false,
    uploadMultiple: false,
    maxFiles: 1,
    init: function() {
                // $(".needsclick").disabled(true);
                var submitButton = $("#upload-file");
                myDropzone = this;
                submitButton.on("click", function() {
                    $("#page-loader").append("<p style='position:absolute; top: 70%; left: 46.5%; margin: -20px 0 0 -20px;'>Processing Campaign Upload</p>");
                    $("#page-loader").removeClass('hide');
                    myDropzone.processQueue(); 
                });
                this.on("addedfile", function() {
                    $("#upload-file").show();
                });
                this.on("complete", function (file) {
                  if (this.getUploadingFiles().length === 0 && this.getQueuedFiles().length === 0) {
                    console.log("done");
                    window.location = "campaign_edit.php?id={$smarty.request.id}";
                }
            });

            },
            success: function(file, response){

            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                $.log('XHR ERROR ' + XMLHttpRequest.status);
            }
        };
    
    $("#upload-file").hide();

    $("#file_label").on('change keyup paste', function() {
        $("#campaign_file_label").val($("#file_label").val());
    });

});

</script>