{include file="includes/header.tpl"}

<link href="assets/plugins/DataTables/media/css/dataTables.bootstrap.min.css" rel="stylesheet" />
<link href="assets/plugins/DataTables/extensions/Responsive/css/responsive.bootstrap.min.css" rel="stylesheet" />
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
            <li><a href="/transaction_checklists.php">Transaction Checklists</a></li>
        </ol>
    </h1>
    <!-- end breadcrumb -->

    <div id="alert_error" class="alert alert-danger fade in m-b-15 hide">
        <strong>Permission Denied!</strong>
        You don't have permission to access the requested process.
        <span class="close" data-dismiss="alert">×</span>
    </div>

	<form action="/transaction_checklist_edit.php" method="post" data-parsley-validate="true">
        <!-- begin panel -->
        <div class="panel panel-inverse" data-sortable-id="new-contacts">
            <div class="panel-heading">
                <h4 class="panel-title">Checklist Configuration</h4>
            </div>
            <div class="panel-body">
                {if isset($display_message)}
                <p style="text-align:center" class="text-success">Checklist has been updated</p>
                {/if}
                <input type="hidden" name="checklist_id" value="{$checklist.checklist_id}">

                <fieldset>
                    <input type="hidden" name="company_id" value="{$company_id}">
                    <div class="row">
                        <div class="col-md-6">
                            <label> Date Created: </label> {$checklist.date_added|date_format} ({$checklist.created_by})
                        </div>
                        <div class="col-md-6">
                            <labeL> Date Last Modified: </label> {$checklist.date_added|date_format} ({$checklist.modified_by})
                        </div>
                        <div class="col-md-12"><hr></div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="checklist_name">Checklist Name</label>
                                <input type="text" class="form-control" value="{$checklist.checklist_name}" name="checklist_name" id="company_name" placeholder="Company or Organization Name" data-parsley-required="true"/>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="event_subject">Transaction Type</label>
                                <select class="form-control" name="transaction_type_id" id="transaction-type" data-parsley-required="true" data-parsley-errors-container="#transaction-type-errors">
                                    <option value="">--</option>
                                    {foreach item=row from=$transaction_types}
                                        <option value="{$row.transaction_type_id}" {if $row.transaction_type_id eq $checklist.transaction_type_id}selected="true"{/if}>{$row.transaction_type}</option>
                                    {/foreach}
                                </select>
                                <div id="transaction-type-errors"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <label class="control-label">Description</label>
                            <div style="width:100%;"  class="input-group">
                                <textarea id="description" name="description" class="form-control">{$checklist.description}</textarea>
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-sm btn-success m-r-5 m-t-15"><i class="fa fa-save"></i> Save</button>
                </fieldset>
            </div>
        </div>
        <!-- end panel -->
    </form>

    <!-- begin panel -->
    <div class="panel panel-inverse">
        <div class="panel-heading">
            <div class="panel-heading-btn">
                <a id="add-referral" href="#modal-step" data-toggle="modal" class="btn btn-xs btn-success" style="margin-top: -1px;"><i class="fa fa-plus"></i>Add Steps</a>
            </div>
            <h4 class="panel-title">Steps</h4>
        </div>
        <div id="alert_success" class="alert alert-success fade in m-b-15 hide flash">
            <strong>Success!</strong>
            <span id="msg"></span>
            <span class="close" data-dismiss="alert">×</span>
        </div>
        <div class="panel-body">
            <div class="table-responsive">
                <table id="tbl-checklists" class="table table-condensed table-striped"> 
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th class="text-center">Name</th>
                            <th class="text-center">Tooltip</th>
                            <th class="text-center">Has Agent</th>
                            <th class="text-center">Has Admin</th>
                            <th class="text-center">Due Event</th>
                            <th class="text-center">Due Days</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach item=row from=$steps}
                        <tr data-step-id="{$row.checklist_step_id}" data-checklist-id="{$row.checklist_id}">
                            <td>{$row.checklist_step_id}</td>
                            <td class="text-center">{$row.step_name}</td>
                            <td class="text-center">{$row.step_tooltip}</td>
                            <td class="text-center">
                                <div class="checkbox checkbox-css checkbox-success">
                                    <input type="checkbox" id="checkbox_has_agent{$row.checklist_step_id}" class="has-agent" {if $row.has_agent_checkbox eq '1'}checked="true"{/if} >
                                    <label for="checkbox_has_agent{$row.checklist_step_id}"></label>
                                </div>
                            </td>
                            <td>
                                <div class="checkbox checkbox-css checkbox-success">
                                    <input type="checkbox" id="checkbox_has_admin_{$row.checklist_step_id}" class="has-admin" {if $row.has_admin_checkbox eq '1'}checked="true"{/if} >
                                    <label for="checkbox_has_admin_{$row.checklist_step_id}"></label>
                                </div>
                            </td>
                            <td class="text-center">{$row.due_event}</td>
                            <td class="text-center">{$row.due_days}</td>
                            <td class="text-center">
                                <a href="javascript:;" class="btn btn-xs btn-danger btn-delete-step"><i class="glyphicon glyphicon-remove"></i>Delete</a>
                            </td>
                        </tr>
                        {foreachelse}
                        <tr class="no-data"><td class="text-center" colspan="8">No Steps Available</td></tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- end panel -->

    <input type="hidden" name="company_id" value="{$company_id}"/>

</div>
<!-- end #content -->


<div class="modal fade" id="modal-step" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Checklist Step</h4>
            </div>
            <div class="modal-body p-20">
                <form id="form-step" method="post" data-parsley-validate="true">

                    <label class="control-label">Step Name</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input type="text" id="step-name" name="step_name" class="form-control" data-parsley-required="true">
                        </div>
                    </div>

                    <label class="control-label">Step Tooltip</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input type="text" id="step-tooltip" name="step_tooltip" class="form-control" data-parsley-required="true">
                        </div>
                    </div>

                    <label class="control-label">Due Event</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <select id="select-due-event" name="due_event" class="form-control" data-parsley-required="true" data-parsley-errors-container="#select-due-event-errors">
                                <option value="">Select an option</option>
                                <option value="After Checklist Added">After Checklist Added</option>
                                <option value="After Mutual">After Mutual</option>
                                <option value="After Closing">After Closing</option>
                            </select>
                            <div id="select-due-event-errors"></div>
                        </div>
                    </div>

                    <label class="control-label">Due Days</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input type="number" step="1" min="0" id="due-days" name="due_days" class="form-control" onkeypress="return event.charCode >= 48 && event.charCode <= 57" data-parsley-required="true" title="Numbers only">
                        </div>
                    </div>

                    <input type="hidden" name="checklist_id" value="{$checklist.checklist_id}"/>

                </form>
            </div>
            <div class="modal-footer">
                <a id="close-add-modal" href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="javascript:;" id="btn-save-step" class="btn btn-sm btn-success"><i class="fa fa-save"></i>Save</a>
            </div>
        </div>
    </div>
</div>

{include file="includes/footer.tpl" company_settings_keyval="1"}