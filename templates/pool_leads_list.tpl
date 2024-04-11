{include file="includes/header.tpl"}

<link rel="stylesheet" type="text/css" href="assets/plugins/DataTables/datatables.min.css"/>
<link href="assets/plugins/DataTables/DataTables-1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet" />
<link href="assets/plugins/DataTables/Responsive-2.2.0//css/responsive.bootstrap.min.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/dropzone/min/dropzone.min.css" rel="stylesheet" />
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">

<!-- begin #content -->
<div id="content" class="content">

    <div class="pull-right">
        <a href="/import_pool_leads.php?id={$id}" class="btn btn-success btn-sm"><i class="fa fa-upload"></i> Import Leads</a>
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$pool.name} Leads 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="/contact_pool.php">Contact Pools</a></li>
            <li><a href="/pool_edit.php?id={$id}">Edit Pool</a></li>
            <li class="active">Leads List</li>
        </ol>
    </h1>
    <!-- end breadcrumb -->

    <!-- begin panel -->
    <div class="panel panel-inverse">
        <div class="panel-heading">
            <h4 class="panel-title">{$pool.name} Leads</h4>
        </div>
        <div class="panel-body">
            <!-- <div class="col-md-6">
                <h5 class="pull-left m-r-10">Filter: </h5>
                <select style="width: 50%;" class="form-control select2 pull-left" id="filter-leads">
                    <option value="">All</option>
                    {foreach item=row from=$filter}
                        <option value="{$row.name}">{$row.name}</option>
                    {/foreach}
                </select>
            </div> -->
            <p id="filter-leads-container" style="margin-left: 15px;">
                Filter:
                <select class="form-control pull-left" id="filter-leads">
                    <option value="">All</option>
                    {foreach item=row from=$filter}
                        <option value="{$row.name}">{$row.name}</option>
                    {/foreach}
                </select>
            </p>

            <!-- <div class="row">
                <div class="col-md-12"> -->
                    {*
                    <table id="tbl-pool-leads" class="table datatable" style="width: 100%;">
                        <thead>
                            <tr>
                                <th>Lead Id</th>
                                <th>Name</th>
                                <th>County</th>
                                <th>City</th>
                                <th>Date Added</th>
                                <th>Date Last Contacted</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                    </table>
                    *}

                    <table id="tbl-pool-leads" class="table table-striped table-responsive">
                        <thead>
                            <tr>
                                <th>Lead Id</th>
                                <th>Name</th>
                                <th>Date Added</th>
                                <th>Date Last Contacted</th>
                                <!-- <th>City</th>
                                <th>County</th> -->
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach item=row from=$pool_leads}
                            <tr id="pool-lead-{$row.pool_lead_id}">
                                <td>{$row.pool_lead_id}</td> 
                                <td>{$row.first_name} {$row.last_name} 
                                    {if $row.phone_0 ne ''} 
                                    <!-- <a href="tel:{$row.phone_0}"><span style="border-radius:50%; margin-left: 5px;" class="label label-xs label-success"><span class="fa fa-phone"></span></span></a> -->
                                    <a href="javascript:;"><span style="border-radius:50%; margin-left: 5px;" class="label label-xs label-success call-lead"><span class="fa fa-phone"></span></span></a>
                                    {/if}
                                    {if $row.email ne ''} 
                                    <a href="mailto:{$row.email}"><span style="border-radius:50%; margin-left: 3px;" class="label label-xs label-success"><span class="fa fa-envelope"></span></span></a>
                                    {/if}
                                </td>
                                <td>{$row.date_added|date_format}</td>
                                <td>{$row.date_last_contacted|date_format}</td>
                                <!-- <td>{$row.city}</td>
                                <td>{$row.county}</td> -->
                                <td>
                                    <a href="pool_lead_view.php?id={$row.pool_lead_id}" class="btn btn-xs btn-success m-r-5 m-b-5"><i class="glyphicon glyphicon-eye-open"></i>View Lead</a>
                                </td>
                            </tr>
                            {if $row.lead_note ne ''}
                            <tr>
                                <td colspan="5">
                                    {if $row.lead_note|count_characters:true > 500}
                                    {$row.lead_note_start}
                                    <a id="more_link_{$row.contact_appointment_id}" onclick="return expose_more({$row.contact_appointment_id});">[ more ]</a>
                                    <span style="display: none;" id="more_desc_{$row.contact_appointment_id}">
                                        {$row.lead_note_end}
                                    </span>                                 
                                    {else}
                                        <p>{$row.lead_note|replace:'/\n':'<br>'}</p>
                                    {/if}
                                </td>
                            </tr>
                            {/if}
                            {foreachelse}
                            <tr><td class="text-center" colspan="5">No leads</td></tr>
                            {/foreach}
                        </tbody>
                    </table>
            <!--     </div>
            </div> -->
        </div>
    </div>
    <!-- end panel -->

</div>
<!-- end #content -->


<div class="modal fade" id="modal-add-pool" style="display: none;">
    <div class="modal-dialog modal-lg ">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Add Pool</h4>
            </div>
            <div class="modal-body p-20">
                <form id="form-add-pool" action="/services/transaction_manager.php" class="form-horizontal" method="post">
                    <label class="control-label">Name</label>

                    <div style="width:100%;" fclass="input-group">
                        <input type="text" id="pool-name" name="pool_name" class="form-control">
                    </div>

                    <label class="control-label">Description</label>

                    <div style="width:100%;" fclass="input-group">
                        <textarea rows="7" id="description" name="description" class="form-control"></textarea>
                    </div>

                    <label class="control-label">Share Level</label>
                    
                    {* check share levels *}
                    <div style="width:100%;" fclass="input-group">
                        <select style="width:100%;" id="share-level" name="share_level" class="form-control">
                            <option value="1">1</option>
                            <option value="2">2</option>
                        </select>
                    </div>

                    <input type="hidden" id="action" name="action" value="add_pool"/>
                    <input type="hidden" id="pool-id" value=""/>
                </form>
            </div>
            <div class="modal-footer">
                <a id="close-add-modal" href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="#" id="btn-add-pool" class="btn btn-sm btn-success">Save</a>
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="modal-upload" style="display: none;">
    <div class="modal-dialog" style="width: 100%; padding: 0px 20px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Import Leads</h4>
            </div>
            <div class="modal-body">
                <div id="dropzone" class="text-center">
                    <form id="my-dropzone" action="/services/import_pool_leads.php" class="dropzone needsclick dz-clickable">
                        <div class="dz-message needsclick">
                            Drop file here or click to upload.<br>

                            <p class="dz-message-2 m-t-20">
                                RUOPEN requires that leads be uploaded in CSV format. The first row of the CSV should contain a heading row naming each column that has data.<br>

                                The following column names are used to create your lead and must be named in the header appropriately. <br><br>

                                <span style="font-size:13px; font-weight: 400">
                                    Name,
                                    First Name,
                                    Last Name,
                                    Phone,
                                    Phone 2,
                                    Phone 3,
                                    Phone 4,
                                    Phone 5,
                                    Phone 6,
                                    Phone 7,
                                    Phone 8,
                                    Phone 9,
                                    Phone 10,
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

                                Leads with the same address, city, state and zip will be considered duplicates. Any extra column will still be displayed when viewing the lead.
                            </p>

                            <div class="fallback">
                                <input name="file" type="file" />
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <a href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="#" id="upload-image" data-dz-remove class="btn btn-sm btn-success">Upload image</a>
            </div>
        </div>
    </div>
</div>

{include file="includes/side_dialer.tpl"}

{include file="includes/footer.tpl" company_settings_keyval="1"}