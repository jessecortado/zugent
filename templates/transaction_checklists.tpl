{include file="includes/header.tpl"}

<link href="assets/plugins/DataTables/media/css/dataTables.bootstrap.min.css" rel="stylesheet" />
<link href="assets/plugins/DataTables/extensions/Responsive/css/responsive.bootstrap.min.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />

<!-- begin #content -->
<div id="content" class="content">
    <div class="pull-right btn-group" role="group" aria-label="...">
        <a href="/settings.php" class="btn btn-sm btn-danger m-b-5"><i class="fa fa-arrow-left"></i> Back to Settings</a>
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$company.company_name} 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="/settings.php">Settings</a></li>
            <li class="active">Transaction Checklists</li>
        </ol>
    </h1>
    <!-- end breadcrumb -->

    <div id="alert_error" class="alert alert-danger fade in m-b-15 hide">
        <strong>Permission Denied!</strong>
        You don't have permission to access the requested process.
        <span class="close" data-dismiss="alert">×</span>
    </div>

    <!-- begin form -->
    <div class="panel panel-inverse">
        <div class="panel-heading">
            <h4 class="panel-title">Add Transaction Checklist</h4>
        </div>
        <div class="panel-body">
            <form id="add-checklist" data-parsley-validate="true">
                <div class="form-group col-sm-12 col-md-10">
                    <input type="text" id="checklist-name" data-parsley-required="true" class="form-control" placeholder="Enter Checklist Name Here">
                </div>
                <div class="form-group-btn col-sm-12 col-md-2">
                    <button type="submit" class="btn btn-success ellips"><i class="glyphicon glyphicon-plus"></i> Add Checklist</button>
                </div>
            </form>
        </div>
    </div>
    <!-- end form -->

    <!-- begin panel -->
    <div class="panel panel-inverse">
        <div class="panel-heading">
            <h4 class="panel-title">Transaction Checklists</h4>
        </div>
        <div id="alert_success" class="alert alert-success fade in hide flash">
            <strong>Success!</strong>
            <span id="msg"></span>
            <span class="close" data-dismiss="alert">×</span>
        </div>
        <div class="panel-body">
            <div class="table-responsive">
                <table id="tbl-checklists" class="table table-striped"> 
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th class="text-center">Checklist Name</th>
                            <th class="text-center">Created</th>
                            <th class="text-center">Updated</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach item=row from=$checklists}
                        <tr>
                            <td>{$row.checklist_id}</td> 
                            <td class="text-center">{$row.checklist_name}</td>
                            <td class="text-center">{$row.date_added|date_format:'%b'}{$row.date_added|date_format:" jS, "}{$row.date_added|date_format:'%Y'} ({$row.created_by})</td>
                            <td class="text-center">{$row.date_modified|date_format:'%b'}{$row.date_modified|date_format:" jS, "}{$row.date_modified|date_format:'%Y'} ({$row.modified_by|default:"n/a"})</td>
                            <td class="text-center">
                                <a href="transaction_checklist_edit.php?checklist_id={$row.checklist_id}&checklist_name={$row.checklist_name}" class="btn btn-xs btn-info m-r-5 btn-edit"><i class="glyphicon glyphicon-eye-open"></i>Edit</a>
                                <a href="#" class="btn btn-xs btn-danger m-r-5 btn-status" data-checklist-id="{$row.checklist_id}" data-status="active"><i class="glyphicon glyphicon-remove"></i>Set Inactive</a>
                            </td>
                        </tr>
                        {foreachelse}
                        <tr class="no-data"><td class="text-center" colspan="5">No Transaction Checklists Available</td></tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- end panel -->

    <input type="hidden" name="company_id" value="{$company_id}"/>

    {if $inactive_checklists|@count gt 0}
    <!-- begin panel -->
    <div id="panel-inactive" class="panel panel-inverse">
        <div class="panel-heading">
            <div class="panel-heading-btn">
                <a href="javascript:void(0)" id="show-inactive" class="btn btn-xs btn-info" data-click="panel-collapse" style="margin-top: -1px;">
                    <i class="fa fa-expand"></i> Show Inactive Checklists
                </a>
            </div>
            <h4 class="panel-title">Inactive Checklists</h4>
        </div>
        <div class="panel-body" style="display:none;">
            <div class="table-responsive">
                <table id="tbl-inactive-checklists" class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th class="text-center">Checklist Name</th>
                            <th class="text-center">Created</th>
                            <th class="text-center">Updated</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach item=row from=$inactive_checklists}
                        <tr>
                            <td>{$row.checklist_id}</td>
                            <td class="text-center">{$row.checklist_name}</td>
                            <td class="text-center">{$row.date_added|date_format:'%b'}{$row.date_added|date_format:" jS, "}{$row.date_added|date_format:'%Y'} ({$row.created_by})</td>
                            <td class="text-center">{$row.date_modified|date_format:'%b'}{$row.date_modified|date_format:" jS, "}{$row.date_modified|date_format:'%Y'} ({$row.modified_by|default:"n/a"})</td>
                            <td class="text-center">
                                <a href="#" class="btn btn-xs btn-danger m-r-5 btn-status" data-checklist-id="{$row.checklist_id}" data-status="inactive"><i class="glyphicon glyphicon-remove"></i>Set Active</a>
                            </td>
                        </tr>
                        {foreachelse}
                        <tr>
                            <td class="text-center" colspan="5">No results</td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- end panel -->
    {/if}

</div>
<!-- end #content -->

{include file="includes/footer.tpl" company_settings_keyval="1"}