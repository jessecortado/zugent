{include file="includes/header.tpl"}

<link href="assets/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet" />
<link href="assets/plugins/jquery-tag-it/css/jquery.tagit.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />

<style type="text/css">
    span.tagit-label {
        font-size: 14px;
        font-weight: bold;
    }
    .tagit-autocomplete { z-index: 9999 !important; }
</style>

<!-- begin #content -->
<div id="content" class="content">
    <div class="pull-right btn-group" role="group" aria-label="...">
        <a href="/settings.php" class="btn btn-sm btn-danger m-b-5"><i class="fa fa-arrow-left"></i> Back to Settings</a>
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$company.company_name} 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="/settings.php">Settings</a></li>
            <li class="active">Bucket Manager</li>
        </ol>
    </h1>
    <!-- end breadcrumb -->

    <div id="alert_error" class="alert alert-danger fade in m-b-15 hide">
        <strong>Permission Denied!</strong>
        You don't have permission to access the requested process.
        <span class="close" data-dismiss="alert">×</span>
    </div>

    <!-- begin file type form -->
    <div class="panel panel-inverse">
        <div class="panel-heading">
            <h4 class="panel-title">Add Bucket</h4>
        </div>
        <div class="panel-body">
            <form id="add-bucket" class="form-inline" data-parsley-validate="true">
                <div class="form-group col-sm-10">
                    <input type="text" id="bucket-name" class="form-control" style="width: 100%" placeholder="Enter Bucket Name Here" data-parsley-required="true">
                </div>
                <div class="form-group-btn col-sm-2">
                    <button type="sumbit" class="btn btn-success" style="width: 100%"><i class="glyphicon glyphicon-plus"></i> Add Bucket</button>
                </div>
            </form>
        </div>
    </div>
    <!-- end file type form -->

	<form action="/settings.php" method="post">
	
        <!-- begin panel -->
        <div class="panel panel-inverse" data-sortable-id="new-contacts">
            <div class="panel-heading">
                <h4 class="panel-title">Buckets</h4>
            </div>
            <div id="alert_success" class="alert alert-success fade in hide flash">
                <strong>Success!</strong>
                <span id="msg"></span>
                <span class="close" data-dismiss="alert">×</span>
            </div>
            <div class="panel-body">
                <div class="table-responsive">
                    <table id="buckets" class="table table-striped"> 
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th class="text-center">Bucket Name</th>
                                <th class="text-center">Dashboard</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        {foreach item=row from=$buckets}
                            <tr>
                                <td>{$row.bucket_id}</td> 
                                <td class="text-center"><a href="#" class="editable" data-type="text" data-pk="{$row.bucket_id}" data-value="{$row.bucket_name}">{$row.bucket_name}</a></td>
                                <td class="text-center">
                                    <div class="checkbox checkbox-css checkbox-success">
                                        <input id="checkbox_css_{$row.bucket_id}" class="dashboard-checkbox" data-bucket-id="{$row.bucket_id}" type="checkbox" {if $row.is_dashboard eq 1} checked {/if}>
                                        <label for="checkbox_css_{$row.bucket_id}"></label>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <!-- <a href="status_manager.php?bucket_id={$row.bucket_id}&bucket_name={$row.bucket_name}" class="btn btn-xs btn-info m-r-5 m-b-5 btn-edit"><i class="glyphicon glyphicon-eye-open"></i>View</a> -->
                                    <a href="#modal-add-tag" class="btn btn-xs btn-primary m-r-5 m-b-5 btn-tags" data-toggle="modal" data-bucket-id="{$row.bucket_id}"><i class="fa fa-tags"></i>Tags</a>
                                    <a data-href="#alert_success" class="btn btn-xs btn-danger m-b-5 btn-delete" data-bucket-id="{$row.bucket_id}"><i class="glyphicon glyphicon-remove"></i>Delete</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    {foreach item=tag from=$bucket_tags}
                                        {if $row.bucket_id eq $tag.bucket_id}
                                        <span class="label label-inverse" style="font-size:12px;padding:1px 5px;line-height:1.5;">{$tag.tag_name}</span>
                                        {/if}
                                    {/foreach}
                                </td>
                            </tr>
                        {foreachelse}
                        <tr class="no-data"><td class="text-center" colspan="4">No Buckets Available</td></tr>
                        {/foreach}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <!-- end panel -->

        <input type="hidden" name="company_id" value="{$company_id}"/>

	</form>

</div>
<!-- end #content -->

<div class="modal fade" id="modal-add-tag" data-backdrop="static" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Bucket Tags<span></span></h4>
            </div>
            <div class="modal-body panel-body p-20">

                <input type="hidden" id="bucket-id">
                
                <div class="form-group">
                    <div class="col-md-12">
                        <ul id="bucket-tags" class="primary"></ul>
                    </div>
                </div>

            </div>
            <div class="modal-footer">
                <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="javascript:void(0)" id="update-tags" class="btn btn-sm btn-success"><i class="fa fa-save"></i>Update</a>
            </div>
        </div>
    </div>
</div>

{include file="includes/footer.tpl" company_settings_keyval="1"}