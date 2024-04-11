{include file="includes/header.tpl"}

<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link rel="stylesheet" href="assets/plugins/jquery-confirm/dist/jquery-confirm.min.css">
<link href="assets/plugins/dropzone/min/dropzone.min.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap-datetimepicker/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />


<style type="text/css">
    h6.step-heading {
        background-color: #009688;
        border-top: 2px solid #000;
        border-bottom: 2px solid #000;
        margin: 0;
        padding: 5px 0;
        color: #fff;
    }
    .other-details input:disabled,
    .other-details textarea:disabled {
        opacity: 1;
    }
    .checkbox label, .radio label {
        padding-left: 0;
        font-weight: bold;
    }
    .checkbox.checkbox-css label:before,
    .checkbox.checkbox-css input:checked+label:after {
        top: 2px;
    }
    .section-header, .steps-name {
        color: #3498db;
        font-weight: 400;
        font-size: 1.2em;
    }
    .steps-timeline {
        outline: 1px dashed rgba(255, 0, 0, 0);
    }
    .steps-timeline:after {
        content: "";
        display: table;
        clear: both;
    }
    .steps-box,
    .steps-box-last {
        outline: 1px dashed rgba(0, 128, 0, 0);
    }
    .steps-img {
        text-decoration: none;
        display: block;
        margin: auto;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        padding: 0 13px;
        background: #575d63;
        line-height: 40px;
        color: #fff;
        font-size: 14px;
        border: 5px solid #2d353c;
        transition: background .2s linear;
        -moz-transition: background .2s linear;
        -webkit-transition: background .2s linear;
    }
    .steps-timeline a.steps-img:hover, .steps-timeline a.steps-img:focus {
        background: #00acac;
        color: #fff;
    }
    .steps-name,
    .steps-description {
        margin: 0;
    }
    .steps-name {
        margin-top: 5px;
    }
    .steps-description {
        overflow: hidden;
        font-weight: bold;
    }

    @media screen and (max-width: 992px) {
        .steps-box {
            padding-bottom: 40px;
        }
        .steps-img {
            float: left;
            margin-right: 20px;
        }
        .steps-box-last {
            margin-bottom: -100%;
        }
        .steps-box,
        .steps-box-last {
            margin-left: -25px;
        }
        .steps-timeline {
            border-left: 2px solid #2d353c;
            margin-left: 25px;
        }
    }
    @media screen and (min-width: 992px) {
        .steps-box,
        .steps-box-last {
            float: left;
            width: 20%;
            margin-top: -50px;
        }
        .steps-box {
            margin-left: -10%;
            margin-right: 10%;
        }
        .steps-box-last {
            margin-left: 0;
            margin-right: -10%;
        }
        .steps-name {
            text-align: center;
        }
        .steps-description {
            text-align: center;
        }
        .steps-timeline {    
            border-top: 3px solid #2d353c;
            padding-top: 23px;
            margin-top: 40px;
            margin-left: 10%;
            margin-right: 10%;
        }
    }
</style>

<!-- begin #content -->
<div id="content" class="content">
    <div class="pull-right">
        {if $user.is_admin eq 1}
        <a href="#modal-edit-transaction" class="btn btn-sm btn-success m-r-5 m-b-5" data-toggle="modal"><i class="fa fa-edit"></i> Edit Transaction Details</a>
        {/if}
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$company.company_name} 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li class="active">Transaction</li>
            <li class="active">{if $user.is_admin eq 1}Edit{else}View{/if}</li>
        </ol>
    </h1>
    <!-- end breadcrumb -->

    <!-- begin panel -->
    <div class="panel panel-inverse">
        <div class="panel-heading">
            <h4 class="panel-title">Dates</h4>
        </div>
        <div class="panel-body">
            <section id="Steps" class="steps-section">
                <div class="steps-timeline">
                    <div class="steps-box">
                        <a href="javascript:;" class="steps-img"><i class="fa fa-star-o"></i></a>
                        <h3 class="steps-name">Date Created</h3>
                        <p class="steps-description">
                            {if $transaction.date_created eq '0000-00-00 00:00:00'}
                                N/A
                            {else}
                                {$transaction.date_created|date_format}
                            {/if}
                        </p>
                    </div>
                    <div class="steps-box">
                        <a href="javascript:;" class="steps-img"><i class="fa fa-edit"></i></a>
                        <h3 class="steps-name">Date Last Modified</h3>
                        <p class="steps-description">
                            {if $transaction.date_modified eq '0000-00-00 00:00:00'}
                                N/A
                            {else}
                                {$transaction.date_modified|date_format}
                            {/if}
                        </p>
                    </div>
                    <div class="steps-box">
                        <a href="javascript:;" class="steps-img"><i class="fa fa-calendar-o"></i></a>
                        <h3 class="steps-name">Date Pending</h3>
                        <p class="steps-description">
                            {if $transaction.date_pending eq '0000-00-00 00:00:00'}
                                N/A
                            {else}
                                {$transaction.date_pending|date_format}
                            {/if}
                        </p>
                    </div>
                    <div class="steps-box">
                        <a href="javascript:;" class="steps-img"><i class="fa fa-calendar"></i></a>
                        <h3 class="steps-name">Date Projected Complete</h3>
                        <p class="steps-description">
                            {if $transaction.date_projected_complete eq '0000-00-00 00:00:00'}
                                N/A
                            {else}
                                {$transaction.date_projected_complete|date_format}
                            {/if}
                        </p>
                    </div>
                    <div class="steps-box" style="margin-right: 0;">
                        <a href="javascript:;" class="steps-img"><i class="fa fa-check-square-o"></i></a>
                        <h3 class="steps-name">Date Complete</h3>
                        <p class="steps-description">
                            {if $transaction.date_complete eq '0000-00-00 00:00:00'}
                                N/A
                            {else}
                                {$transaction.date_complete|date_format}
                            {/if}
                        </p>
                    </div>
                    <div class="steps-box-last">
                        <a href="javascript:;" class="steps-img"><i class="fa fa-star"></i></a>
                        <h3 class="steps-name">Date Ended</h3>
                        <p class="steps-description">
                            {if $transaction.date_ended eq '0000-00-00 00:00:00'}
                                N/A
                            {else}
                                {$transaction.date_ended|date_format}
                            {/if}
                        </p>
                    </div>
                </div>
            </section>

            <!-- <div class="row text-center">
                <div class="col-md-3">
                    <label>Date Ended</label>
                    <p>{$transaction.date_ended|date_format}</p>
                </div>
                <div class="col-md-3">
                    <label>Date Pending</label>
                    <p>{$transaction.date_pending|date_format}</p>
                </div>
                <div class="col-md-3">
                    <label>Date Projected Complete</label>
                    <p>{$transaction.date_projected_complete|date_format}</p>
                </div>
                <div class="col-md-3">
                    <label>Date Complete</label>
                    <p>{$transaction.date_complete|date_format}</p>
                </div>
            </div>
            <div class="row text-center">
                <div class="col-md-6">
                    <label>Date Created</label>
                    <p>{$transaction.date_created|date_format}</p>
                </div>
                
                <div class="col-md-6">
                    <label>Date Last Modified</label>
                    <p>{$transaction.date_modified|date_format}</p>
                </div>
            </div> -->
        </div>
    </div>
    <!-- end panel -->

    <!-- begin panel -->
    <div class="panel panel-inverse">
        <div class="panel-heading">
            <h4 class="panel-title">Other Details</h4>
        </div>
        <div class="panel-body other-details">
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Added By</label>
                        <input type="text" class="form-control" value="{$transaction.created_by|default:'n/a'}" disabled/>
                    </div>
                    <!-- <label>Added By</label>
                    <p>{$transaction.created_by}</p> -->
                </div>
                {if $transaction.is_on_mls eq 0}
                <div class="col-md-3">
                    <div class="form-group">
                        <label>Listing Number</label>
                        <input type="text" class="form-control" value="{$transaction.listing_number|default:'n/a'}" disabled/>
                    </div>
                    <!-- <label>Listing Number</label>
                    <p>{$transaction.listing_number}</p> -->
                </div>
                {/if}
            </div>
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Source Id</label>
                        <input type="text" class="form-control" value="{$transaction.source_id|default:'n/a'}" disabled/>
                    </div>
                    <!-- <label>Source Id</label>
                    <p>{$transaction.source_id|default: "n/a"}</p> -->
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label>Transaction Type</label>
                        <input type="text" class="form-control" value="{$transaction.transaction_type|default:'n/a'}" disabled/>
                    </div>
                    <!-- <label>Transaction Type</label>
                    <p>{$transaction.transaction_type}</p> -->
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label>Transaction Status</label>
                        <input type="text" class="form-control" value="{$transaction.transaction_status|default:'n/a'}" disabled/>
                    </div>
                    <!-- <label>Transaction Status</label>
                    <p>{$transaction.transaction_status}</p> -->
                </div> 
            </div>
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Street Address</label>
                        <input type="text" class="form-control" value="{$transaction.street_address|default:'n/a'}" disabled/>
                    </div>
                    <!-- <label>Street Address</label>
                    <p>{$transaction.street_address}</p> -->
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label>City</label>
                        <input type="text" class="form-control" value="{$transaction.city|default:'n/a'}" disabled/>
                    </div>
                    <!-- <label>City</label>
                    <p>{$transaction.city}</p> -->
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label>State</label>
                        <input type="text" class="form-control" value="{$transaction.state|default:'n/a'}" disabled/>
                    </div>
                    <!-- <label>State</label>
                    <p>{$transaction.state}</p> -->
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label>Zip</label>
                        <input type="text" class="form-control" value="{$transaction.zip|default:'n/a'}" disabled/>
                    </div>
                    <!-- <label>Zip</label>
                    <p>{$transaction.zip}</p> -->
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Transaction Description</label>
                        <textarea type="text" class="form-control" value="{$transaction.transaction_description}" placeholder="No Description" rows="5" disabled></textarea>
                    </div>
                    <!-- <label>Transaction Description</label>
                    <p>{$transaction.transaction_description}</p> -->
                </div>
                <div class="col-md-8">
                    <label>Extended Data</label>
                    <!-- <p><textarea name="extended_data" style="width:100%" id="extended-data" rows="10"></textarea></p> -->
                    <p><textarea id="extended-data" name="extended_data" class="form-control" placeholder="No Extended Data" rows="5">{$transaction.extended_data}</textarea></p>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 text-right">
                    <button class="btn btn-sm btn-success" id="save-extended-data"><i class="fa fa-save"></i> Save</button>
                </div>
            </div>
        </div>
    </div>
    <!-- end panel -->
        
    <div class="row">
        <div class="col-md-6">
            <!-- begin panel -->
            <h4 class="text-center"> Checklists </h4>
            <div class="input-group control-group after-add-more m-b-10">
                <select name="checklist_id" id="company-checklists">
                    <option value="">Select a checklist to be added</option>
                    {foreach item=row from=$company_checklists}
                    <option value="{$row.checklist_id}">{$row.checklist_name}</option>
                    {/foreach}
                </select>
                <div class="input-group-btn"> 
                    <button class="btn btn-success" id="btn-add-checklist" type="button"><i class="glyphicon glyphicon-plus"></i> Add</button>
                </div>
            </div>
            <p id="error-add-checklist" class="hide" style="color:red;">Please select a checklist.</p>

            {foreach item=row from=$transaction_checklists}
            <div id="panel-checklist-{$row.transaction_rel_checklist_id}" class="panel panel-inverse">
                <div class="panel-heading">
                    <h4 class="panel-title">Transaction Checklists</h4>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive">
                                <table id="tbl-checklists" class="table table-striped"> 
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Checklist Name</th>
                                            <th class="text-center">Created</th>
                                            <th class="text-center">Updated</th>
                                            <th class="text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>{$row.transaction_rel_checklist_id}</td> 
                                            <td>{$row.checklist_name}</td>
                                            <td class="text-center">{$row.date_added|date_format} ({$row.created_by})</td>
                                            <td class="text-center">{$row.date_modified|date_format} ({$row.modified_by})</td>
                                            <td class="text-center">
                                                <a href="javascript:;" class="btn btn-xs btn-danger m-b-5 btn-remove-checklist" data-toggle="confirmation" data-placement="left" data-singleton="true" data-checklist-id="{$row.checklist_id}" data-trc-id="{$row.transaction_rel_checklist_id}" data-checklist-name="{$row.checklist_name}"><i class="glyphicon glyphicon-remove"></i>Remove</a>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <h6 class="text-center step-heading">Steps</h6>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive">
                                <table  class="table table-striped">
                                    <thead>
                                        <tr>
                                            <!-- <th>Step</th> -->
                                            <th>Step Name</th>
                                            <th>Event Due</th>
                                            <!-- <th>Days Due</th> -->
                                            <th class="text-center">Admin</th>
                                            <th class="text-center">Agent</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach item="step" from=$row.steps}
                                        <tr>
                                            <!-- <td>{$step.checklist_step_id}</td>  -->
                                            <td title="{$step.step_tooltip}">{$step.step_name}</td>
                                            <td>{$step.due_event}</td>
                                            <!-- <td>{$step.due_days}</td> -->
                                            <td> 
                                                {if $step.has_admin_checkbox eq '1'}
                                                    {if $user.is_admin eq 1 or $user.is_superadmin eq 1}
                                                        <!-- <input type="checkbox" class="check-admin-step" data-checklist-step-id="{$step.checklist_step_id}" {if $step.admin_checked} checked="true" {/if}> -->
                                                        <div class="checkbox checkbox-css checkbox-success">
                                                            <input id="checkbox_agentstep_{$step.checklist_step_id}" class="check-admin-step" data-checklist-step-id="{$step.checklist_step_id}" type="checkbox" {if $step.admin_checked} checked="true" {/if}>
                                                            <label for="checkbox_agentstep_{$step.checklist_step_id}"></label>
                                                        </div>
                                                    {else}
                                                        {if $step.admin_checked} Reviewed {else} Not Reviewed {/if}
                                                    {/if}
                                                {/if}
                                            </td>
                                            <td> 
                                                {if $step.has_agent_checkbox eq '1'}
                                                    <!-- <input type="checkbox" class="check-agent-step" data-checklist-step-id="{$step.checklist_step_id}" {if $step.agent_checked} checked="true" {/if}> -->
                                                    <div class="checkbox checkbox-css checkbox-success">
                                                        <input id="checkbox_agentstep_{$step.checklist_step_id}" class="check-agent-step" data-checklist-step-id="{$step.checklist_step_id}" type="checkbox" {if $step.agent_checked} checked="true" {/if}>
                                                        <label for="checkbox_agentstep_{$step.checklist_step_id}"></label>
                                                    </div>
                                                {/if}
                                            </td>
                                        </tr>
                                        {foreachelse}
                                        <tr class="no-data"><td class="text-center" colspan="4">No Steps</td></tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- end panel -->
            {/foreach}
        </div>
        <div class="col-md-6">
            <!-- begin panel -->
            <div class="panel panel-inverse">
                <div class="panel-heading">
                    <div class="panel-heading-btn">
                        <a href="#modal-add-transaction-comment" data-toggle="modal" class="btn btn-xs btn-success" style="margin-top: -1px;"><i class="fa fa-plus"></i>Add Comment</a>
                    </div>
                    <h4 class="panel-title">Comments</h4>
                </div>
                <div id="alert_success_comment" class="alert alert-success fade in hide flash">
                    <strong>Success!</strong>
                    <span id="msg"></span>
                    <span class="close" data-dismiss="alert">×</span>
                </div>
                <div class="panel-body">
                    <input type="hidden" name="id" value="{$campaign.campaign_id}"> 
                    <input type="hidden" name="action" value="n">
                    <fieldset>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="table-responsive">
                                    <table class="table table-condensed" id="commentsTbl" name="commentsTbl">
                                        <thead>
                                            <tr>
                                                <th>Source</th>
                                                <th>Message</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {foreach from=$transaction_comments item='comment'}
                                            <tr>
                                                <td style="width: 200px;">
                                                    <b>{$comment.first_name} {$comment.last_name}</b><br/>
                                                    <small>{$comment.date_created|date_format:'%b'}{$comment.date_created|date_format:" jS, "}{$comment.date_created|date_format:'%Y'}</small><br/>
                                                </td>
                                                <td>
                                                    {$comment.comment}
                                                </td>
                                            </tr>
                                            {foreachelse}
                                            <tr class="no-data"><td class="text-center" colspan="2">No Comments</td></tr>
                                            {/foreach}
                                        </tbody>
                                    </table>
                                </div>
                                <!-- <p>
                                    <b>New Comment</b>
                                    <textarea class="form-control" rows=5 name="comment" id="comment"></textarea>
                                    <p><a href="javascript:add_comment()" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Add Comment</a></p>
                                </p> -->
                            </div>
                        </div>
                    </fieldset>
                </div>
            </div>
            <!-- end panel -->

            <!-- begin panel -->
            <div class="panel panel-inverse">
                <div class="panel-heading">
                    <div class="panel-heading-btn">
                        <a href="#modal-add-contact-file" data-toggle="modal" class="btn btn-xs btn-success" style="margin-top: -1px;"><i class="fa fa-plus"></i>Attached Files</a>
                    </div>
                    <h4 class="panel-title">Attached Files</h4>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive">
                                <table class="table table-condensed" id="transactionFilesTbl" name="transactionFilesTbl">
                                    <thead>
                                        <tr>
                                            <th>File Name</th>
                                            <th class="text-center">File Type</th>
                                            <th class="text-center">Date Uploaded</th>
                                            <th class="text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach from=$transaction_files item='row'}
                                        <tr>
                                            <td>
                                                <b>{$row.file_name}</b>
                                            </td>
                                            <td class="text-center">
                                                {$row.file_type_name}
                                            </td>
                                            <td class="text-center">
                                                {$row.date_uploaded|date_format:'%b'}{$row.date_uploaded|date_format:" jS, "}{$row.date_uploaded|date_format:'%Y'}
                                            </td>
                                            <td class="text-center">
                                                <a href="#modal-edit-file" class="btn btn-xs btn-info m-r-5 m-b-5 edit-transaction-file" data-toggle="modal" data-transaction-file-id="{$row.transaction_file_id}" data-file-type-name="{$row.file_type_name}" data-transaction-file-type="{$row.file_type}" data-file-name="{$row.file_name}"><i class="glyphicon glyphicon-edit"></i>Edit</a>

                                                <a href="https://s3-us-west-2.amazonaws.com/zugent{$row.file_key}" target="_blank" class="btn btn-xs btn-info m-r-5 m-b-5 show-completion-notes" data-file-type-name="{$row.file_type_name}" data-transaction-file-id="{$row.transaction_file_id}"><i class="glyphicon glyphicon-edit"></i>Download</a>

                                                <a href="#transactionFilesTbl" class="btn btn-xs btn-danger m-b-5 btn-delete-transaction-file"  data-placement="left" data-transaction-file-id="{$row.transaction_file_id}"><i class="glyphicon glyphicon-remove"></i>Delete</a>
                                            </td>
                                        </tr>
                                        {foreachelse}
                                        <tr class="no-data"><td class="text-center" colspan="4">No Attached Files</td></tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <!-- <div class="col-md-12" style="min-height:300px">
                            <div id="dropzone" class="text-center">
                                <form id="my-dropzone" action="/services/upload_transaction_file.php" class="dropzone needsclick dz-clickable" enctype="multipart/form-data" method="post">
                                    <div class="dz-message needsclick">
                                        Drop files here or click to browse.<br>

                                        <div class="fallback">
                                            <input name="file" type="file" />
                                        </div>
                                    </div>
                                    
                                    <input type="hidden" name="action" value="upload_file">
                                </form>
                                <br/>
                                <p><a id="upload-file" href="#transactionFilesTbl" class="btn btn-sm btn-info">Upload File</a></p>
                            </div>


                            <label class="control-label">File Type</label>
                            <select id="transaction-file-type" name="transaction_file_type" class="text-center form-control" style="width:100%;" >
                                <option value="test">Select a file type</option>
                                {foreach from=$file_types item='row'}
                                <option value="{$row.file_type_id}">{$row.name}</option>
                                {/foreach}
                            </select>
                        </div> -->
                    </div>

                    <!-- {if $user.is_admin eq 1}
                    <div class="row">
                        <div class="col-md-12">
                            {if $deleted_transaction_files|count gt 0}
                            <a href="#deletedtransactionFilesTbl" id="toggle-deleted-files" class="btn btn-info">Show {$deleted_transaction_files|count} Deleted Files</a>

                            <div class="table-responsive">
                                <table class="table table-condensed hide" id="deletedTransactionFilesTbl" name="deletedTransactionFilesTbl">
                                    <thead>
                                        <tr>
                                            <th>File Name</th>
                                            <th>File Type</th>
                                            <th>Date Uploaded</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach from=$deleted_transaction_files item='row'}
                                        <tr>
                                            <td>
                                                <b>{$row.file_name}</b>
                                            </td>
                                            <td>
                                                {$row.file_type_name}
                                            </td>
                                            <td>
                                                {$row.date_uploaded|date_format:'%b'}{$row.date_uploaded|date_format:" jS, "}{$row.date_uploaded|date_format:'%Y'}
                                            </td>
                                            <td>
                                                <a href="#transactionFilesTbl" class="btn btn-xs btn-info m-r-5 m-b-5 btn-restore-transaction-file" data-transaction-file-id="{$row.transaction_file_id}" data-btn-ok-label="Restore" data-btn-ok-icon="glyphicon glyphicon-share-alt" data-btn-ok-class="btn-info btn-sm" data-btn-cancel-label="Cancel" data-placement="left" data-btn-cancel-icon="glyphicon glyphicon-ban-circle" data-btn-cancel-class="btn-danger btn-sm"data-toggle="confirmation" data-placement="left"><i class="glyphicon glyphicon-remove"></i>Restore</a>
                                            </td>
                                        </tr>
                                        {foreachelse}
                                        {/foreach}
                                    </tbody>
                                </table>
                            </div>
                            {/if}
                        </div>
                    </div>
                    {/if} -->

                    {if $user.is_admin eq 1}
                    <div class="panel panel-inverse" style="margin-bottom:0;display:{if $deleted_transaction_files|count gt 0}block{else}none{/if}" id="deleted-attachedfile-panel">
                        <div class="panel-heading" style="background:gray;">
                            <div class="panel-heading-btn">
                                <a href="javascript:void(0)" id="toggle-deleted-files" data-toggle="modal" class="btn btn-xs btn-info ellips" data-click="panel-collapse" style="margin-top: -1px;">
                                    <i class="fa fa-expand"></i> Show {$deleted_transaction_files|count} Deleted Files
                                </a>
                            </div>
                            <h4 class="panel-title">Deleted Files</h4>
                        </div>
                        <div class="panel-body" style="padding: 3px; display: none;">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="table-responsive">
                                        <table class="table table-condensed" id="deletedTransactionFilesTbl" name="deletedTransactionFilesTbl">
                                            <thead>
                                                <tr>
                                                    <th>File Name</th>
                                                    <th class="text-center">File Type</th>
                                                    <th class="text-center">Date Uploaded</th>
                                                    <th class="text-center">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {foreach from=$deleted_transaction_files item='row'}
                                                <tr>
                                                    <td>
                                                        <b>{$row.file_name}</b>
                                                    </td>
                                                    <td class="text-center">
                                                        {$row.file_type_name}
                                                    </td>
                                                    <td class="text-center">
                                                        {$row.date_uploaded|date_format:'%b'}{$row.date_uploaded|date_format:" jS, "}{$row.date_uploaded|date_format:'%Y'}
                                                    </td>
                                                    <td class="text-center">
                                                        <a href="#transactionFilesTbl" class="btn btn-xs btn-info m-b-5 btn-restore-transaction-file" data-transaction-file-id="{$row.transaction_file_id}" data-btn-ok-label="Restore" data-btn-ok-icon="glyphicon glyphicon-share-alt" data-btn-ok-class="btn-info btn-sm" data-btn-cancel-label="Cancel" data-placement="left" data-btn-cancel-icon="glyphicon glyphicon-ban-circle" data-btn-cancel-class="btn-danger btn-sm"data-toggle="confirmation" data-placement="left"><i class="glyphicon glyphicon-remove"></i>Restore</a>
                                                    </td>
                                                </tr>
                                                {/foreach}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    {/if}
                </div>
            </div>
            <!-- end panel -->
        </div>
    </div>
</div>
<!-- end #content -->

{if $user.is_admin eq 1 or $user.is_superadmin eq 1}
<div class="modal fade" id="modal-edit-transaction" style="display: none;">
    <div class="modal-dialog" style="width: 80vw;margin-left:auto;margin-right:auto;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Edit Transaction Details</h4>
            </div>
            <div class="modal-body p-20">
                <form id="form-edit-transaction" action="/services/edit_transaction.php" method="post" data-parsley-validate="true" data-parsley-excluded="input[type=hidden], [disabled], :hidden">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Source Id</label>
                                <input type="text" class="form-control" name="source_id" value="{$transaction.source_id}" data-parsley-required="true"/>
                            </div>
                            <!-- <label class="control-label">Source Id</label>
                            <input type="text" class="form-control" name="source_id" value="{$transaction.source_id}" data-parsley-required="true"> -->

                            <div class="form-group">
                                <!-- <label>Is on MLS</label> -->
                                <div class="checkbox checkbox-css checkbox-success">
                                    <input id="chk-mls" class="check-agent-step" value="{$transaction.is_on_mls}" data-checklist-step-id="{$step.checklist_step_id}" type="checkbox" {if $transaction.is_on_mls eq '1'}checked="true"{/if}>
                                    <label for="chk-mls">Is on MLS</label>
                                </div>
                            </div>
                            <!-- <label class="control-label">Is on MLS</label>
                            <input type="checkbox" class="form-control" id="chk-mls" value="{$transaction.is_on_mls}" {if $transaction.is_on_mls eq '1'}checked="true"{/if}> -->
                            
                            <div id="listing-group" class="hide">
                                <div class="form-group">
                                    <label>Listing Number</label>
                                    <input type="text" class="form-control" name="listing_number" value="{$transaction.listing_number}" data-parsley-required="true"/>
                                </div>
                                <!-- <label class="control-label">Listing Number</label>
                                <input type="text" class="form-control" name="listing_number" value="{$transaction.listing_number}" data-parsley-required="true"> -->
                            </div>

                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Transaction Type</label>
                                <select name="transaction_type_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#transaction-type-id-errors">
                                    <option value="">Select a Type</option>
                                    {foreach from=$transaction_types item='row'}
                                    <option value="{$row.transaction_type_id}" {if $transaction.transaction_type_id eq $row.transaction_type_id} selected="true" {/if}>{$row.transaction_type}</option>
                                    {/foreach}
                                </select>
                                <div id="transaction-type-id-errors"></div>
                            </div>

                            <div class="form-group">
                                <label>Transaction Status</label>
                                <select name="transaction_status_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#transaction-status-id-errors">
                                    <option value="">Select a Status</option>
                                    {foreach from=$transaction_status item='row'}
                                    <option value="{$row.transaction_status_id}" {if $transaction.transaction_status_id eq $row.transaction_status_id} selected="true" {/if}>{$row.transaction_status}</option>
                                    {/foreach}
                                </select>
                                <div id="transaction-status-id-errors"></div>
                            </div>

                            <div class="form-group">
                                <label>Description</label>
                                <textarea class="form-control" name="transaction_description" rows="5">{$transaction.transaction_description}</textarea>
                            </div>
                            
                            <!-- <label class="control-label">Transaction Type</label>

                            <div style="width:100%;" class="input-group">
                                <select style="width:100%;" id="" name="transaction_type_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#transaction-type-id-errors">
                                    <option value="">Select a Type</option>
                                    {foreach from=$transaction_types item='row'}
                                    <option value="{$row.transaction_type_id}" {if $transaction.transaction_type_id eq $row.transaction_type_id} selected="true" {/if}>{$row.transaction_type}</option>
                                    {/foreach}
                                </select>
                                <div id="transaction-type-id-errors"></div>
                            </div> -->

                            <!-- <label class="control-label">Transaction Status</label>

                            <div style="width:100%;" class="input-group">
                                <select style="width:100%;" id="" name="transaction_status_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#transaction-status-id-errors">
                                    <option value="">Select a Status</option>
                                    {foreach from=$transaction_status item='row'}
                                    <option value="{$row.transaction_status_id}" {if $transaction.transaction_status_id eq $row.transaction_status_id} selected="true" {/if}>{$row.transaction_status}</option>
                                    {/foreach}
                                </select>
                                <div id="transaction-status-id-errors"></div>
                            </div> -->

                            <!-- <label class="control-label">Description</label>

                            <div style="width:100%;" class="input-group">
                                <textarea class="form-control" name="transaction_description" rows="5">{$transaction.transaction_description}</textarea>
                            </div> -->
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Street Address</label>
                                <input type="text" class="form-control" name="street_address" value="{$transaction.street_address}" data-parsley-required="true"/>
                            </div>
                            <div class="form-group">
                                <label>City</label>
                                <input type="text" class="form-control" name="city" value="{$transaction.city}" data-parsley-required="true"/>
                            </div>
                            <div class="form-group">
                                <label>State</label>
                                <select id="state" name="state" class="form-control" data-parsley-required="true" data-parsley-errors-container="#transaction-state-id-errors">
                                    <option value="">Select a State</option>
                                    {include file="includes/states.tpl"}
                                </select>
                                <div id="transaction-state-id-errors"></div>
                            </div>
                            <div class="form-group">
                                <label>Zip</label>
                                <input type="text" class="form-control" name="zip" value="{$transaction.zip}"/>
                            </div>
                            
                            <!-- <label class="control-label">Street Address</label>
                            <input type="text" class="form-control" name="street_address" value="{$transaction.street_address}" data-parsley-required="true">

                            <label class="control-label">City</label>
                            <input type="text" class="form-control" name="city" value="{$transaction.city}" data-parsley-required="true">

                            <label>State</label>
                            <select class="form-control" name="state" id="state" data-parsley-required="true">
                                <option value="">--</option>
                                {include file="includes/states.tpl"}
                            </select>

                            <label class="control-label">Zip</label>
                            <input type="text" class="form-control" name="zip" value="{$transaction.zip}"> -->
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Date Ended</label>
                                <input type="text" class="form-control date" name="date_ended" placeholder="Select Date" value="{$transaction.date_ended|date_format: '%D'}">
                            </div>
                            <div class="form-group">
                                <label>Date Pending</label>
                                <input type="text" class="form-control date" name="date_pending" placeholder="Select Date" value="{$transaction.date_pending|date_format: '%D'}">
                            </div>
                            <div class="form-group">
                                <label>Date Projected Complete</label>
                                <input type="text" class="form-control date" name="date_projected_complete" placeholder="Select Date" value="{$transaction.date_projected_complete|date_format: '%D'}">
                            </div>
                            <div class="form-group">
                                <label>Date Complete</label>
                                <input type="text" class="form-control date" name="date_complete" placeholder="Select Date" value="{$transaction.date_complete|date_format: '%D'}">
                            </div>
                            
                            <!-- <label class="control-label">Date Ended</label>
                            <input type="text" class="form-control date" name="date_ended" placeholder="Select Date" value="{$transaction.date_ended|date_format: '%D'}">
                            
                            <label class="control-label">Date Pending</label>
                            <input type="text" class="form-control date" name="date_pending" placeholder="Select Date" value="{$transaction.date_pending|date_format: '%D'}">
                            
                            <label class="control-label">Date Projected Complete</label>
                            <input type="text" class="form-control date" name="date_projected_complete" placeholder="Select Date" value="{$transaction.date_projected_complete|date_format: '%D'}">
                            
                            <label class="control-label">Date Complete</label>
                            <input type="text" class="form-control date" name="date_complete" placeholder="Select Date" value="{$transaction.date_complete|date_format: '%D'}"> -->

                        </div>

                    </div>

                    <input type="text" style="display:none;" id="is-on-mls" name="is_on_mls" value="{$transaction.is_on_mls}"/>
                    <input type="hidden" id="transaction-id" name="transaction_id" value="{$transaction.transaction_id}"/>
                    <input type="hidden" id="action" name="action" value="update_transaction"/>
                </form>
            </div>
            <div class="modal-footer">
                <a id="close-add-modal" href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="#" id="btn-save-transaction" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modal-edit-file" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Edit Transaction File</h4>
            </div>
            <div class="modal-body p-20">
                <form id="form-edit-transaction-file" class="form-horizontal" action="/services/edit_transaction_file.php" method="post">

                    <label class="control-label">Completion Notes</label>

                    <div style="width:100%;" class="input-group">
                        <select style="width:100%;" name="file_type" class="form-control" id="modal-transaction-file-type">
                            {foreach from=$file_types item='row'}
                            <option value="{$row.file_type_id}">{$row.name}</option>
                            {/foreach}
                        </select>
                    </div>

                    <label class="control-label">File Name</label>

                    <div style="width:100%;" class="input-group">
                        <input class="form-control" type="text" name="file_name" id="modal-transaction-file-name"/>
                    </div>

                    <input type="hidden" id="modal-transaction-id" name="transaction_id" value="{$transaction.transaction_id}"/>
                    <input type="hidden" id="action" name="action" value="edit_transaction_file"/>
                    <input type="hidden" id="modal-transaction-file-id" name="transaction_file_id" value=""/>
                </form>
            </div>
            <div class="modal-footer">
                <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="#form-edit-transaction-file" id="save-transaction-file" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modal-add-transaction-comment" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Comments<span></span></h4>
            </div>
            <div class="modal-body p-20">
                <form id="form-add-transaction-comment" method="post" data-parsley-validate="true">
                    <label class="control-label">Message</label>
                    <div class="form-group">
                        <textarea class="form-control" rows=5 name="comment" id="comment" data-parsley-required="true"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="javascript:void(0)" id="modal-save-transaction-comment" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modal-add-contact-file" data-backdrop="static" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Attach Files<span></span></h4>
            </div>
            <div class="panel" style="margin-bottom:0;">
                <div class="modal-body panel-body p-20">
                    <div id="dropzone" class="text-center">
                        <form id="my-dropzone" action="/services/upload_transaction_file.php" class="dropzone needsclick dz-clickable" enctype="multipart/form-data" method="post">
                            <div class="dz-message needsclick">
                                Drop files here or click to browse.<br>

                                <div class="fallback">
                                    <input name="file" type="file" />
                                </div>
                                <input type="hidden" name="action" value="upload_file">
                            </div>
                        </form>
                        <p id="no-file-uploaded" class="hide" style="color:red;margin-bottom:0;margin-top:5px">Please choose a file to be uploaded</p>
                        <br/>
                    </div>

                    <label class="control-label">File Type</label>
                    <select id="transaction-file-type" name="transaction_file_type" class="text-center form-control" style="width:100%;" >
                        <option value="">Select a file type</option>
                        {foreach from=$file_types item='row'}
                        <option value="{$row.file_type_id}">{$row.name}</option>
                        {/foreach}
                    </select>
                    <p id="no-transaction-file-type" class="hide" style="color:red;margin-bottom:0;margin-top:5px">Please choose a file type</p>
                </div>
            </div>
            <div class="modal-footer">
                <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="javascript:void(0)" id="upload-file" class="btn btn-sm btn-success"><i class="fa fa-cloud-upload"></i>Upload File</a>
            </div>
        </div>
    </div>
</div>
{/if}


{include file="includes/footer.tpl" company_settings_keyval="1"}