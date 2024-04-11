{include file="includes/header.tpl"}

<link href="assets/plugins/DataTables/media/css/dataTables.bootstrap.min.css" rel="stylesheet" />
<link href="assets/plugins/DataTables/extensions/Responsive/css/responsive.bootstrap.min.css" rel="stylesheet" />
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">

<!-- begin #content -->
<div id="content" class="content">
    <div class="pull-right">
        <a href="/settings.php" class="btn btn-sm btn-danger m-b-5"><i class="fa fa-arrow-left"></i> Back to Settings</a>
        {* {if $user.is_admin eq 1}
        <a href="#modal-add-user" class="btn btn-sm btn-info m-r-5 m-b-5" data-toggle="modal"><i class="fa fa-plus"></i> Add User</a>
        {/if} *}
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$company.company_name} 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="javascript:void(0)">Users List</a></li>
            <li class="active">Users Logs</li>
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
            <h4 class="panel-title">Log</h4>
        </div>
        <div class="panel-body">
            <div class="table-responsive">
                <table id="acitveUsersTbl" class="table table-striped"> 
                    <thead>
                        <tr>
                            <th>Id</th>
                            <th>Name (ID)</th>
                            <th>Message</th>
                            <th>Type</th>
                            <th>Date Added</th>
                        </tr>
                    </thead>
                    <tbody>
                    {foreach item=row from=$log}
                        <tr>
                            <td>{$row.user_log_id}</td>
                            <td>{$row.first_name} {$row.last_name} ({$row.user_id})</td>
                            <td>{$row.message}</td>
                            <td>{$row.page}</td>
                            <td>{$row.date_created}</td>
                        </tr>
                    {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- end panel -->


{include file="includes/footer.tpl" company_settings_keyval="1"}