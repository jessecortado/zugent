{include file="includes/header.tpl"}

<!-- begin #content -->
<div id="content" class="content">
    <div class="pull-right">
        <a href="#modal-new-template" class="btn btn-sm btn-success m-b-5" data-toggle="modal"><i class="fa fa-plus"></i> Add New Template</a>
        <a href="/bulk_email.php" class="btn btn-sm btn-info m-b-5" data-toggle="modal"><i class="fa fa-send"></i> Send an Email</a>
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">Email Templates 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="javascript:void(0)">Bulk Email</a></li>
            <li class="active">Email Templates</li>
        </ol>
    </h1>
    <!-- end breadcrumb -->

    <div id="alert_error" class="alert alert-danger fade in m-b-15 hide">
        <strong>Permission Denied!</strong>
        You don't have permission to access the requested process.
        <span class="close" data-dismiss="alert">×</span>
    </div>
    
    <div id="alert_success" class="alert alert-success fade in hide flash">
        <strong>Success!</strong>
        <span id="msg"></span>
        <span class="close" data-dismiss="alert">×</span>
    </div>

    <div class="row">
        <div class="col-md-12">
            <h4>Personal Templates</h4>
        </div>
        {foreach from=$personal_templates item="row"}
        <div class="col-md-4">
            <!-- begin panel -->
            <div class="panel panel-inverse" data-sortable-id="form-stuff-1">
                <div class="panel-heading">
                    <div class="panel-heading-btn">
                        <a href="/bulk_template_edit.php?id={$row.bulk_template_id}" class="btn btn-success btn-xs"><i class="fa fa-pencil"></i>Edit Template</a>
                        <button type="button" class="btn btn-xs btn-primary stm" data-tid="{$row.bulk_template_id}"><i class="fa fa-send"></i> Send Test Message</button>
                    </div>
                    <h4 class="panel-title">Template Name: {$row.name}</h4>
                </div>
                <div class="panel-body">
                    <table id="personalTemplatesTbl" class="table table-striped"> 
                        <thead>
                            <tr>
                                <th>Subject</th>
                                <th class="text-center" style="width:25%">Company Wide</th>
                                <th class="text-center" style="width:15%">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>{$row.subject}</td>
                                <td class="text-center">{if $row.is_company_shared}<span class="fa fa-check"></span>{else}<span class="fa fa-times"></span>{/if}</td></td>
                                <td class="text-center">{if $row.is_active}<span class="fa fa-check"></span>{else}<span class="fa fa-times"></span>{/if}</td></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- end panel -->
        </div>
        {foreachelse}
        <p class="p-10 p-b-0">No Template Available</p>
        {/foreach}
    </div>

    <hr>

    <div class="row">
        <div class="col-md-12">
            <h4>Company Templates</h4>
        </div>
        {foreach from=$company_templates item="row"}
        <div class="col-md-4">
            <!-- begin panel -->
            <div class="panel panel-inverse" data-sortable-id="form-stuff-1">
                <div class="panel-heading">
                    <div class="panel-heading-btn">
                        {if $row.user_id eq $user_id}
                        <a href="/bulk_template_edit.php?id={$row.bulk_template_id}" class="btn btn-success btn-xs"><i class="fa fa-pencil"></i>Edit Template</a>
                        {/if}
                        <button type="button" class="btn btn-xs btn-primary stm" data-tid="{$row.bulk_template_id}"><i class="fa fa-send"></i> Send Test Message</button>
                    </div>
                    <h4 class="panel-title">Template Name: {$row.name}</h4>
                </div>
                <div class="panel-body">
                    <table id="personalTemplatesTbl" class="table table-striped">
                        <thead>
                            <tr>
                                <th>Subject</th>
                                <th class="text-center" style="width:25%">Company Wide</th>
                                <th class="text-center" style="width:15%">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>{$row.subject}</td>
                                <td class="text-center">{if $row.is_company_shared}<span class="fa fa-check"></span>{else}<span class="fa fa-times"></span>{/if}</td></td>
                                <td class="text-center">{if $row.is_active}<span class="fa fa-check"></span>{else}<span class="fa fa-times"></span>{/if}</td></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- end panel -->
        </div>
        {foreachelse}
        <p class="p-10 p-b-0">No Template Available</p>
        {/foreach}
    </div>
</div>
<!-- end #content -->


<div class="modal fade" id="modal-new-template" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">New Email Template</h4>
            </div>
            <div class="modal-body p-20">
                <form id="form-new-template" method="post" data-parsley-validate="true">
                    <label class="control-label">Template Name</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input type="text" class="form-control" id="template-name" name="template_name" placeholder="Enter template name here" data-parsley-required="true"/>
                        </div>
                    </div>
                    <input type="hidden" id="action" name="action" value="new_email_template"/>
                </form>
            </div>
            <div class="modal-footer">
                <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="javascript:void(0)" id="btn-add-new-template" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
            </div>
        </div>
    </div>
</div>

{include file="includes/footer.tpl"}