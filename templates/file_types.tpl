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
            <li class="active">Contact File Types</li>
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
            <h4 class="panel-title">Add Contact File Type</h4>
        </div>
        <div class="panel-body">
            <form id="add-file-type" data-parsley-validate="true">
                <div class="form-group col-sm-12 col-md-5">
                    <input id="name" type="text" class="form-control" data-parsley-required="true" placeholder="Enter file type name here">
                </div>
                <div class="form-group col-sm-12 col-md-5">
                    <input id="sequence" type="text" class="form-control" data-parsley-required="true" placeholder="Enter sequence number (numbers only)">
                </div>
                <div class="form-group-btn col-sm-12 col-md-2">
                    <button type="submit" class="btn btn-success ellips"><i class="glyphicon glyphicon-plus"></i> Add Contact File Type</button>
                </div>
            </form>
        </div>
    </div>
    <!-- end file type form -->

    <div class="panel panel-inverse" data-sortable-id="new-contacts">
        <div class="panel-heading">
            <h4 class="panel-title">Contact File Types</h4>
        </div>
        <div id="alert_success" class="alert alert-success fade in hide flash">
            <strong>Success!</strong>
            <span id="msg"></span>
            <span class="close" data-dismiss="alert">×</span>
        </div>
        <div class="panel-body">
            <div class="table-responsive">
                <table id="file-types" class="table table-condensed"> 
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th class="text-center">Name</th>
                            <th class="text-center">Sequence</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {if $file_types}
                        {foreach item=row from=$file_types}
                        <tr>
                            <td>{$row.file_type_id}</td>
                            <td class="text-center"><a href="#file-types" class="editable-file-type" data-type="text" data-pk="{$row.file_type_id}" data-value="{$row.name}" data-name="{$row.name}">{$row.name}</a></td>
                            <td class="text-center"><a href="#file-types" class="editable-sequence" data-type="text" data-pk="{$row.file_type_id}" data-value="{$row.sequence}">{$row.sequence}</a></td>
                            <td class="text-center">
                                <a data-href="#alert_success" data-toggle="confirmation" class="btn btn-xs btn-danger btn-delete-file-type" data-file-type-id="{$row.file_type_id}" data-name="{$row.name}">
                                    <i class="glyphicon glyphicon-remove"></i>Delete
                                </a>
                            </td>
                        </tr>
                        {/foreach}
                        {else}
                        <tr class="no-data"><td class="text-center" colspan="4">No Contact File Types Available</td></tr>
                        {/if}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<!-- end #content -->

{include file="includes/footer.tpl" company_settings_keyval="1"}