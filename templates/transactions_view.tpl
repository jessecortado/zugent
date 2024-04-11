{include file="includes/header.tpl"}

<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap3-editable/inputs-ext/bootstrap-wysihtml5/dist/bootstrap-wysihtml5-0.0.2.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap-datetimepicker/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />

<style type="text/css">
    #transactionTbl input:disabled,
    #transactionTbl textarea:disabled {
        opacity: 1;
    }
    .date-box {
        display: block;
    }
</style>

<!-- begin #content -->
<div id="content" class="content">

    <div class="pull-right">
        <a href="#modal-new-transaction" class="btn btn-sm btn-info m-b-5" data-toggle="modal"><i class="fa fa-plus"></i> New Transactions</a>
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$company.company_name} 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="/transactions.php">Transactions</a></li>
            <li class="active">{$selected_user}</li>
        </ol>
    </h1>
    <!-- end breadcrumb -->

    <div id="alert_error" class="alert alert-danger fade in m-b-15 hide">
        <strong>Permission Denied!</strong>
        You don't have permission to access the requested process.
        <span class="close" data-dismiss="alert">×</span>
    </div>

    <!-- begin panel -->
    <div class="panel panel-inverse" data-sortable-id="new-contacts">
        <div class="panel-heading">
            <h4 class="panel-title">Transactions</h4>
        </div>
        <div class="panel-body">
            <div class="table-responsive">
                <table id="transactionTbl" class="table table-striped"> 
                    <thead>
                        <tr>
                            <th style="width:25%;">ID</th>
                            <th>Status</th>
                            <th>Type</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    {foreach item=row from=$transactions}
                        <tr>
                            <td>{$row.transaction_id}</td> 
                            <td><a href="#" class="editable-transaction-status" data-type="select2" data-pk="{$row.transaction_id}" data-value="{$row.transaction_status_id}" data-company-id="{$row.company_id}">{$row.transaction_status}</a></td>
                            <td><a href="#" class="editable-transaction-types" data-type="select2" data-pk="{$row.transaction_id}" data-value="{$row.transaction_type_id}" data-company-id="{$row.company_id}">{$row.transaction_type}</a></td>
                            <td class="text-center">
                                <button class="btn btn-info btn-xs m-r-5 m-b-5" data-toggle="collapse" data-target=".collapse-{$row.transaction_id}"><i class="glyphicon glyphicon-eye-open"></i>Show Details</button>
                                <a href="#" class="btn btn-danger btn-xs m-b-5 btn-delete" data-transaction-id="{$row.transaction_id}"><i class="glyphicon glyphicon-remove"></i>Delete</a>
                            </td>
                        </tr>
                        <tr class="collapse collapse-{$row.transaction_id}">
                            <td colspan="4" style="padding:15px;">
                                <div class="row">
                                    <div class="col-md-3" style="position: inherit;">
                                        <div class="form-group">
                                            <label>Date Created</label>
                                            <input type="text" class="form-control" value="{$row.date_created|date_format:'%b'}{$row.date_created|date_format:' jS, '}{$row.date_created|date_format:'%Y'}  {$row.date_created|date_format:'%I:%M %p'}" disabled/>
                                        </div>
                                    </div>
                                    <div class="col-md-3" style="position: inherit;">
                                        <div class="form-group">
                                            <label>Date Modified</label>
                                            <input type="text" class="form-control" value="{$row.date_modified|date_format:'%b'}{$row.date_modified|date_format:' jS, '}{$row.date_modified|date_format:'%Y'}  {$row.date_modified|date_format:'%I:%M %p'}" disabled/>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3" style="position: inherit;">
                                        <div class="form-group">
                                            <label>Date Pending</label>
                                            <div class="date-box">
                                                <a href="#" data-type="datetime" class="editable-date" data-pk="{$row.transaction_id}" data-value="{$row.date_pending}" data-column="date_pending">
                                                    {$row.date_pending|date_format:'%b'}{$row.date_pending|date_format:' jS, '}{$row.date_pending|date_format:'%Y'} {$row.date_pending|date_format:'%I:%M %p'}
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3" style="position: inherit;">
                                        <div class="form-group">
                                            <label>Date Ended</label>
                                            <div class="date-box">
                                                <a href="#" data-type="datetime" class="editable-date" data-pk="{$row.transaction_id}" data-value="{$row.date_ended}" data-column="date_ended">
                                                    {$row.date_ended|date_format:'%b'}{$row.date_ended|date_format:' jS, '}{$row.date_ended|date_format:'%Y'} {$row.date_ended|date_format:'%I:%M %p'}
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3" style="position: inherit;">
                                        <div class="form-group">
                                            <label>Date Projected Complete</label>
                                            <div class="date-box">
                                                <a href="#" data-type="datetime" class="editable-date" data-pk="{$row.transaction_id}" data-value="{$row.date_projected_complete}" data-column="date_projected_complete">
                                                    {$row.date_projected_complete|date_format:'%b'}{$row.date_projected_complete|date_format:' jS, '}{$row.date_projected_complete|date_format:'%Y'} {$row.date_projected_complete|date_format:'%I:%M %p'}
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3" style="position: inherit;">
                                        <div class="form-group">
                                            <label>Date Complete</label>
                                            <div class="date-box">
                                                <a href="#" data-type="datetime" class="editable-date" data-pk="{$row.transaction_id}" data-value="{$row.date_complete}" data-column="date_complete">
                                                    {$row.date_complete|date_format:'%b'}{$row.date_complete|date_format:' jS, '}{$row.date_complete|date_format:'%Y'} {$row.date_complete|date_format:'%I:%M %p'}
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6" style="position: inherit;">
                                        <div class="form-group">
                                            <label>Extended Data</label>
                                            <div class="date-box">
                                                <a href="#" class="editable-textarea" data-pk="{$row.transaction_id}" data-value="{$row.extended_data}">{$row.extended_data}</a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6" style="position: inherit;">
                                        <div class="form-group">
                                            <label>Source Id</label>
                                            <div class="date-box">
                                                <a href="#" class="editable-text" data-type="text" data-pk="{$row.transaction_id}" data-value="{$row.source_id}">{$row.source_id}</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12" style="position: inherit;">
                                        <div class="form-group">
                                            <label>Description</label>
                                            <div style="display: block;">
                                                {if $row.transaction_description|count_characters:true > 500}
                                                {$row.description_start}
                                                <a id="more_link_{$row.transaction_id}" onclick="return expose_more({$row.transaction_id});">[ more ]</a>
                                                <span style="display: none;" id="more_desc_{$row.transaction_id}">
                                                    {$row.description_end}
                                                </span>
                                                {else}
                                                <p>{$row.transaction_description|replace:'/\n':'<br>'}</p>
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <!-- <tr class="collapse collapse-{$row.transaction_id}">
                            <td colspan="2"><b>Date Created<b></td>
                            <td colspan="2"><b>Date Modified<b></td>
                        </tr>
                        <tr class="collapse collapse-{$row.transaction_id}">
                            <td colspan="2">{$row.date_created}</td>
                            <td colspan="2">{$row.date_modified}</td>
                        </tr>
                        <tr class="collapse collapse-{$row.transaction_id}">
                            <td><b>Date Pending</b></td>
                            <td><b>Date Ended</b></td>
                            <td><b>Date Projected Complete</b></td>
                            <td><b>Date Complete</b></td>
                        </tr>
                        <tr class="collapse collapse-{$row.transaction_id}">
                            <td>
                                <a href="#" data-type="datetime" data-placement="right" class="editable-date" data-pk="{$row.transaction_id}" data-value="{$row.date_pending}" data-column="date_pending">{$row.date_pending}</a></td>
                            <td>
                                <a href="#" data-type="datetime" data-placement="right" class="editable-date" data-pk="{$row.transaction_id}" data-value="{$row.date_ended}" data-column="date_ended">{$row.date_ended}</a></td>
                            <td>
                                <a href="#" data-type="datetime" data-placement="right" class="editable-date" data-pk="{$row.transaction_id}" data-value="{$row.date_projected_complete}" data-column="date_projected_complete">
                                    {$row.date_projected_complete}
                                </a>
                            </td>
                            <td>
                                <a href="#" data-type="datetime" data-placement="right" class="editable-date" data-pk="{$row.transaction_id}" data-value="{$row.date_projected_complete}" data-column="date_complete">{$row.date_complete}</a>
                            </td>
                        </tr>
                        <tr class="collapse collapse-{$row.transaction_id}">
                            <td colspan="2"><b>Extended Data<b></td>
                            <td colspan="2"><b>Source Id<b></td>
                        </tr>
                        <tr class="collapse collapse-{$row.transaction_id}">
                            <td colspan="2"><a href="#" class="editable-textarea" data-pk="{$row.transaction_id}" data-value="{$row.extended_data}">{$row.extended_data}</a></td>
                            <td colspan="2"><a href="#" class="editable-text" data-type="text" data-pk="{$row.transaction_id}" data-value="{$row.source_id}">{$row.source_id}</a></td>
                        </tr> 
                        <tr class="collapse collapse-{$row.transaction_id}">
                            <td colspan="4">
                                {if $row.transaction_description|count_characters:true > 500}
                                {$row.description_start}
                                <a id="more_link_{$row.transaction_id}" onclick="return expose_more({$row.transaction_id});">[ more ]</a>
                                <span style="display: none;" id="more_desc_{$row.transaction_id}">
                                    {$row.description_end}
                                </span>                                 
                                {else}
                                <p>{$row.transaction_description|replace:'/\n':'<br>'}</p>
                                {/if}
                            </td>
                        </tr> -->
                    {foreachelse}
                    <tr class="no-data"><td class="text-center" colspan="4">No Transactions Available</td></tr>
                    {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- end panel -->
</div>
<!-- end #content -->


{include file="includes/footer.tpl" company_settings_keyval="1"}