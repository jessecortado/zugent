{include file="includes/header.tpl"}

<link rel="stylesheet" type="text/css" href="assets/plugins/DataTables/datatables.min.css"/>
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/dropzone/min/dropzone.min.css" rel="stylesheet" />

<!-- begin #content -->
<div id="content" class="content">

    <div class="pull-right">
        <a href="/pool_leads_list.php?id={$id}" class="btn btn-success btn-block btn-sm"><i class="fa fa-arrow-left"></i> Back to List</a>
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$pool.name} Leads 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="/contact_pool.php">Contact Pools</a></li>
            <li><a href="/pool_edit.php?id={$id}">Edit Pool</a></li>
            <li class="active">Import Leads</li>
        </ol>
    </h1>
    <!-- end breadcrumb -->

    <div id="result-message" class="well well-success text-center hide">
        <h4 class="title">Finished Importing</h4>
        <p><span id="created"></span> lead/s created</p>
        <p><span id="skipped"></span> lead/s skipped due to duplicates</p>
        <p><span id="error"></span> processing error/s</p>
    </div>

    <!-- begin panel -->
    <div id="panel-dropzone" class="panel panel-inverse">
        <div class="panel-heading">
            <h4 class="panel-title">Import Leads</h4>
            <p><a class="btn btn-xs btn-info" href="/pool_leads_list.php?id={$id}">Go to Pool Leads list</a></p>
        </div>
        <div class="panel-body">
            <div id="dropzone" class="text-center">
                <form id="my-dropzone" action="/services/upload_pool_leads.php" class="dropzone needsclick dz-clickable">
                    <div class="dz-message needsclick">
                        Drop file here or click to upload.<br>

                        <p class="dz-message-2 m-t-20">
                            RUOPEN requires that leads be uploaded in CSV format. The first row of the CSV should contain a heading row naming each column that has data.<br>

                            The following column names are used to create your lead and must be named in the header appropriately. <br><br>

                            <span style="font-size:13px; font-weight: 400">
                                Name,
                                First Name,
                                Last Name,
                                Phone 0,
                                Phone 1,
                                Phone 2,
                                Phone 3,
                                Phone 4,
                                Phone 5,
                                Phone 6,
                                Phone 7,
                                Phone 8,
                                Phone 9,
                                Address,
                                Address 2,
                                City,
                                State,
                                Zip,
                                County,
                                Email,
                                Notes,
                            </span>

                            <br><br>

                            Leads with the same address, city, state and zip will be considered duplicates.
                        </p>

                        <div class="fallback">
                            <input name="file" type="file" />
                        </div>
                    </div>
                </form>
            </div>

            <div class="text-center">
                <button class="btn btn-success m-t-20" id="upload-file">Upload File</button>
            </div>
        </div>
    </div>
    <!-- end panel -->

    <!-- begin panel -->
    <div id="panel-imported-data" class="panel panel-inverse hide">
        <div class="panel-heading">
            <h4 class="panel-title">{$pool.name} Import Confirmation</h4>
        </div>
        <div class="panel-body" style="overflow-x: scroll;">
            <table id="tbl-leads" class="table table-responsive table-striped"> 
                <thead>
                    <tr>

                    </tr>
                </thead>
                <tbody>
                   
                </tbody>
            </table>
            <p class="m-t-15 m-b-10 text-center"><b>Does this look correct?</b></p>
            
            <div class="text-center">

                <button class="btn btn-success" id="confirm-import">Yes</button>
                <a href="pool_edit.php?id={$id}" class="btn btn-danger" id="cancel-import">No</a>
            </div>
        </div>
    </div>
    <!-- end panel -->

</div>

<!-- <script src="assets/plugins/DataTables/media/js/jquery.dataTables.js" defer></script>
<script src="assets/plugins/DataTables/media/js/dataTables.bootstrap.min.js" defer></script>
<script src="assets/plugins/DataTables/extensions/Responsive/js/dataTables.responsive.min.js" defer></script> -->
<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js" defer></script>

<script type="text/javascript">
defer(deferred_method);

function editable_init() {
    // $('.editable').editable({
    //     url: '/services/contact_status_manager.php',
    //     title: 'Enter Appointment Type Name',
    //     params: function(params) {
    //         //originally params contain pk, name and value
    //         params.action = 'edit_bucket';
    //         params.bucket_id = $(this).data('pk');
    //         params.bucket_name = params.value;
    //         return params;
    //     },
    //     validate: function(value) {
    //         if($.trim(value) == '') {
    //             return 'This field is required';
    //         }
    //     },
    //     success: function(response, newValue) {
    //         console.log(response);
    //     }
    // });
}
function defer(method){
    if (window.jQuery)
        method();
    else
        setTimeout(function() { defer(method) }, 50);
}

function deferred_method(){


    editable_init();

    // $("select").select2();

}
</script>

<script src="assets/plugins/select2/dist/js/select2.min.js" defer></script>

{include file="includes/footer.tpl" company_settings_keyval="1"}


