{include file="includes/header.tpl"}

<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">

<!-- begin #content -->
<div id="content" class="content">
    <div class="pull-right btn-group" role="group" aria-label="...">
        <a href="/settings.php" class="btn btn-sm btn-danger m-b-5"><i class="fa fa-arrow-left"></i> Back to Settings</a>
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$company.company_name} 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="/settings.php">Settings</a></li>
            <li class="active">Transaction Variables</li>
        </ol>
    </h1>
    <!-- end breadcrumb -->

    <div id="alert_error" class="alert alert-danger fade in m-b-15 hide">
        <strong>Permission Denied!</strong>
        You don't have permission to access the requested process.
        <span class="close" data-dismiss="alert">×</span>
    </div>

    <div class="row">
        <div class="col-md-6 col-sm-12">
            <!-- begin panel -->
            <div class="panel panel-inverse">
                <div class="panel-heading">
                    <div class="panel-heading-btn">
                        <a href="#modal-add-transaction-type" data-toggle="modal" class="btn btn-xs btn-success ellips" style="margin-top: -1px;"><i class="fa fa-plus"></i>Add Transaction Types</a>
                    </div>
                    <h4 class="panel-title">Transaction Types</h4>
                </div>
                <div id="alert_success_type" class="alert alert-success fade in hide flash">
                    <strong>Success!</strong>
                    <span id="msg"></span>
                    <span class="close" data-dismiss="alert">×</span>
                </div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <table id="tbl-transaction-types" class="table table-condensed">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th class="text-center">Transaction Type Name</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach item=row from=$transaction_types}
                                <tr>
                                    <td>{$row.transaction_type_id}</td> 
                                    <td class="text-center"><a href="javascript:void(0)" class="editable-tt" data-type="text" data-pk="{$row.transaction_type_id}" data-value="{$row.transaction_type}" data-name="{$row.transaction_type}">
                                        {$row.transaction_type}</a>
                                    </td>
                                    <td class="text-center">
                                        <a data-href="#alert_success_type" class="btn btn-xs btn-danger btn-delete-transaction-type" data-transaction-type-id="{$row.transaction_type_id}"><i class="glyphicon glyphicon-remove"></i>Delete</a>
                                    </td>
                                </tr>
                                {foreachelse}
                                <tr class="no-data"><td class="text-center" colspan="3">No Transaction Types Available</td></tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- end panel -->
        </div>
        <div class="col-md-6 col-sm-12">
            <!-- begin panel -->
            <div class="panel panel-inverse">
                <div class="panel-heading">
                    <div class="panel-heading-btn">
                        <a href="#modal-add-transaction-status" data-toggle="modal" class="btn btn-xs btn-success ellips" style="margin-top: -1px;"><i class="fa fa-plus"></i>Add Transaction Status</a>
                    </div>
                    <h4 class="panel-title">Transaction Status</h4>
                </div>
                <div id="alert_success_status" class="alert alert-success fade in hide flash">
                    <strong>Success!</strong>
                    <span id="msg"></span>
                    <span class="close" data-dismiss="alert">×</span>
                </div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <table id="tbl-transaction-status" class="table table-condensed">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th class="text-center">Transaction Status Name</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach item=row from=$transaction_status}
                                <tr>
                                    <td>{$row.transaction_status_id}</td>
                                    <td class="text-center"><a href="javascript:void(0)" class="editable-ts" data-type="text" data-pk="{$row.transaction_status_id}" data-value="{$row.transaction_status}" data-name="{$row.transaction_status}">
                                        {$row.transaction_status}</a>
                                    </td>
                                    <td class="text-center">
                                        <a data-href="#alert_success_status" class="btn btn-xs btn-danger btn-delete-transaction-status" data-transaction-status-id="{$row.transaction_status_id}"><i class="glyphicon glyphicon-remove"></i>Delete</a>
                                    </td>
                                </tr>
                                {foreachelse}
                                <tr class="no-data"><td class="text-center" colspan="3">No Transaction Status Available</td></tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- end panel -->
        </div>
    </div>
</div>
<!-- end #content -->


<div class="modal fade in" id="modal-add-transaction-status" style="display: none;" aria-hidden="false">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Add Transaction Status</h4>
            </div>
            <div class="modal-body">
                <form id="form-add-transaction-status" data-parsley-validate="true">
                    <label class="control-label">Transaction Status</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input id="transaction-status" type="text" class="form-control" placeholder="Enter transaction status here" data-parsley-required="true">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="javascript:void(0)" id="btn-save-transaction-status" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
            </div>
        </div>
    </div>
</div>


<div class="modal fade in" id="modal-add-transaction-type" style="display: none;" aria-hidden="false">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Add Transaction Type</h4>
            </div>
            <div class="modal-body">
                <form id="form-add-transaction-type" data-parsley-validate="true">
                    <label class="control-label">Transaction Type</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input id="transaction-type" type="text" class="form-control" placeholder="Enter transaction type here" data-parsley-required="true">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="javascript:void(0)" id="btn-save-transaction-type" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
            </div>
        </div>
    </div>
</div>

{include file="includes/footer.tpl" company_settings_keyval="1"}