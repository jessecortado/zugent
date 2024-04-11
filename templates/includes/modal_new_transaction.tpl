<div class="modal fade" id="modal-new-transaction" data-backdrop="static" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title" id="xmodal-title">Add New Transaction</h4>
            </div>
            <div class="modal-body p-20">
                <!-- For New Transactions -->
                <form id="xform-new-transaction" method="post" data-parsley-validate="true">

                    {if $is_dashboard eq 1}
                    <input type="hidden" name="transaction_alert_id" id="transaction_alert_id">
                    <input type="hidden" name="listing_number" id="listing_number">
                    <input type="hidden" name="mls_id" id="mls_id">
                    {/if}

                    <div class="row">
                        {if $user.is_admin or $user.is_transaction_coordinator}
                        <div class="col-md-6">
                            <label class="control-label">User</label>
                            <div class="form-group">
                                <div style="width:100%;" class="input-group">
                                    <select style="width:100%;" id="xusrs1" class="form-control">
                                        <option value="">Select a User</option>
                                        {foreach from=$company_users item='row'}
                                        <option value="{$row.user_id}">{$row.first_name} {$row.last_name}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>
                        </div>
                        {/if}
                        <div class="{if $user.is_admin}col-md-6{else}col-md-12{/if}">
                            <label class="control-label">Contacts</label>
                            <div class="form-group">
                                <div style="width:100%;" class="input-group">
                                    <select style="width:100%;" name="contact_id" id="xcontacts" class="form-control" data-parsley-required="true" data-parsley-errors-container="#xc_id_error">
                                        <option value="">Select a Contact</option>
                                        {foreach from=$user_contacts item='row'}
                                        <option value="{$row.contact_id}">{$row.client}</option>
                                        {/foreach}
                                    </select>
                                </div>
                                <div id="xc_id_error"></div>
                            </div>
                        </div>
                    </div>

                    <label class="control-label">Transaction Type</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <select style="width:100%;" name="transaction_type_id" id="xtransaction_type" class="form-control" data-parsley-required="true" data-parsley-errors-container="#xtt_id_error">
                                <option value="">Select a Type</option>
                                {foreach from=$transaction_types item='row'}
                                <option value="{$row.transaction_type_id}">{$row.transaction_type}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div id="xtt_id_error"></div>
                    </div>

                    <label class="control-label">Transaction Status</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <select style="width:100%;" name="transaction_status_id" id="xtransaction_status" class="form-control" data-parsley-required="true" data-parsley-errors-container="#xts_id_error">
                                <option value="">Select a Status</option>
                                {foreach from=$transaction_status item='row'}
                                <option value="{$row.transaction_status_id}">{$row.transaction_status}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div id="xts_id_error"></div>
                    </div>

                    <label class="control-label">Description</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <textarea style="width:100%;" name="description" class="form-control" data-parsley-required="true" data-parsley-errors-container="#xtdesc_id_error"></textarea>
                        </div>
                        <div id="xtdesc_id_error"></div>
                    </div>

                    {if $user.is_admin or $user.is_transaction_coordinator}
                    <div class="text-right">
                        <a href="javascript:void(0)" id="xcreate-new-contact">Create New Contact</a>
                    </div>
                    {/if}
                </form>

                <!-- For New Contacts -->
                <form id="xform-new-contact" method="post" data-parsley-validate="true">
                    <div class="row">
                        <div class="col-md-6">
                            <label class="control-label">User</label>
                            <div class="form-group">
                                <div style="width:100%;" class="input-group">
                                    <select style="width:100%;" name="user_id" id="xusrs2" class="form-control" data-parsley-required="true" data-parsley-errors-container="#xusr2_id_error">
                                        <option value="">Select a User</option>
                                        {foreach from=$company_users item='row'}
                                        <option value="{$row.user_id}">{$row.first_name} {$row.last_name}</option>
                                        {/foreach}
                                    </select>
                                </div>
                                <div id="xusr2_id_error"></div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="control-label">Bucket</label>
                            <div class="form-group">
                                <div style="width:100%;" class="input-group">
                                    <select style="width:100%;" name="bucket_id" id="xbuckets" class="form-control" data-parsley-required="true" data-parsley-errors-container="#xbct_id_error">
                                        <option value="">Select a Bucket</option>
                                        {foreach from=$buckets item='row'}
                                        <option value="{$row.bucket_id}">{$row.bucket_name}</option>
                                        {/foreach}
                                    </select>
                                </div>
                                <div id="xbct_id_error"></div>
                            </div>
                        </div>
                    </div>

                    <label class="control-label">First Name</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input type="text" class="form-control" name="first_name" id="xfirst_name" placeholder="First Name" data-parsley-required="true">
                        </div>
                    </div>

                    <label class="control-label">Last Name</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input type="text" class="form-control" name="last_name" id="xlast_name" placeholder="Latt Name" data-parsley-required="true">
                        </div>
                    </div>

                    <div class="text-right">
                        <a href="javascript:void(0)" id="xselect-exist-contact">Select an Existing Contact</a>
                    </div>

                    <input type="hidden" name="action" value="n">
                </form>
            </div>
            <div class="modal-footer">
                <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="javascript:void(0)" id="xbtnmodal-add-new-transaction" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
                <a href="javascript:void(0)" id="xbtnmodal-add-new-contact" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

    $(document).ready(function() {

        $("#xcontacts").select2({ allowClear: true, placeholder:'Select a Client', width:'100%'});
        $("#xusrs1").select2({ allowClear: true, placeholder:'Select a User', width:'100%'});
        $("#xtransaction_type").select2({ placeholder:'Select a Type', width:'100%'});
        $("#xtransaction_status").select2({ placeholder:'Select a Status', width:'100%'});
        $("#xusrs2").select2({ allowClear: true, placeholder:'Select a User', width:'100%'});
        $("#xbuckets").select2({ placeholder:'Select a Bucket', width:'100%'});

        /************************************************ New Transaction Section ************************************************/

        $("#xform-new-contact").css("display", "none");
        $("#xbtnmodal-add-new-contact").css("display", "none");

        $("#xcreate-new-contact").click(function(){
            $("#xform-new-transaction").css("display", "none");
            $("#xbtnmodal-add-new-transaction").css("display", "none");
            $("#xform-new-contact").css("display", "block");
            $("#xbtnmodal-add-new-contact").css("display", "inline-block");
            $("#xmodal-title").text("Add New Contact");
        });

        $("#xselect-exist-contact").click(function(){
            $("#xform-new-transaction").css("display", "block");
            $("#xbtnmodal-add-new-transaction").css("display", "inline-block");
            $("#xform-new-contact").css("display", "none");
            $("#xbtnmodal-add-new-contact").css("display", "none");
            $("#xmodal-title").text("Add New Transaction");
        });

        $("#xbtnmodal-add-new-transaction").click(function(){
            $("#xform-new-transaction").submit();
        });

        $("#xbtnmodal-add-new-contact").click(function(){
            $("#xform-new-contact").submit();
        });

        $('#xmodal-new-transaction').on('hide.bs.modal', function(){
            $('#xform-new-transaction').parsley().reset();
            $('#xform-new-contact').parsley().reset();
        });

        {if $is_dashboard eq 1}
        $(".mnt").on("click", function(){
            $("#transaction_alert_id").val($(this).attr("data-transaction-alert-id"));
            $("#listing_number").val($(this).attr("data-listing-number"));
            $("#mls_id").val($(this).attr("data-mls-id"));
        });
        {/if}

        $("#xform-new-transaction").on("submit", function(e){
            e.preventDefault();
            if ( $(this).parsley().isValid() ) {
                var target = $('#form-add-transaction').closest('.panel');

                $.ajax({
                    type: "POST",
                    url: '/ws/transaction/add_contact_transaction',
                    data: $(this).serialize(),
                    dataType: "json",
                    success: function(result) {
                        console.log(result);

                        if (result.msg) {
                            window.location = "transaction/"+result.data[0].transaction_id;
                        }
                        else {
                            alert("Something went wrong.")
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                    },
                    complete: function() {
                        $("#xmodal-new-transaction").modal('hide');
                    }
                });
            }
        });

        {if $user.is_admin or $user.is_transaction_coordinator}
        $('#xusrs1').on('change', function(){
            $("#xcontacts").val([]);
            $.ajax({
                type: "POST",
                url: '/ws/contact/user_contacts',
                data: { 'user_id': $(this).val() },
                dataType: "json",
                success: function(result) {
                    if (result.msg) {
                        console.log(result.user_contacts);

                        $('#xcontacts').select2({
                            placeholder: 'Select a Client',
                            ajax: {
                                transport: function(params, success, failure) {
                                    var items = result.user_contacts;
                                    
                                    if (params.data && params.data.q) {
                                        items = items.filter(function(item) {
                                            return new RegExp(params.data.q).test(item.text);
                                        });
                                    }
                                    
                                    var promise = new Promise(function(resolve, reject) {
                                        resolve({
                                            results: items
                                        });
                                    });
                                    
                                    promise.then(success);
                                    promise.catch(failure);
                                }
                            }
                        });
                    }
                    else {
                        alert("Something went wrong.");
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
                }
            });
        });

        $("#xform-new-contact").on("submit", function(e){
            e.preventDefault();
            if ( $(this).parsley().isValid() ) {
                var target = $('#form-add-transaction').closest('.panel');

                $.ajax({
                    type: "POST",
                    url: '/ws/contact/new_contact',
                    data: $(this).serialize(),
                    dataType: "json",
                    success: function(result) {
                        console.log(result);

                        if (result.msg) {
                            window.location = "contacts_edit.php?id="+result.contact_id;
                        }
                        else {
                            alert("Something went wrong.")
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                    },
                    complete: function() {
                        $("#xmodal-new-transaction").modal('hide');
                    }
                });
            }
        });
        {/if}

        /********************************************** End-New Transaction Section **********************************************/
    });
    
</script>