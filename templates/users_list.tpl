{include file="includes/header.tpl"}

<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link rel="stylesheet" href="assets/plugins/jquery-confirm/dist/jquery-confirm.min.css">

<!-- begin #content -->
<div id="content" class="content">
    <div class="pull-right">
        <a href="/settings.php" class="btn btn-sm btn-danger m-b-5"><i class="fa fa-arrow-left"></i> Back to Settings</a>
        {if $user.is_admin eq 1}
        <a href="#modal-add-user" class="btn btn-sm btn-info m-r-5 m-b-5" data-toggle="modal"><i class="fa fa-plus"></i> Add User</a>
        {/if}
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$company.company_name} 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="javascript:void(0)">Users Editor</a></li>
            <li class="active">View All Company Users</li>
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
            <h4 class="panel-title">Users</h4>
        </div>
        <div class="panel-body">
            <div class="table-responsive">
                <table id="acitveUsersTbl" class="table table-striped"> 
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Last Checkin</th>
                            <th class="text-center">Active</th>
                            <th class="text-center">Admin</th>
                            <th class="text-center">Coordinator</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    {foreach item=row from=$users}
                        <tr>
                            <td>{$row.first_name} {$row.last_name}</td>
                            <td>{$row.email}</td>
                            <td>{$row.phone_mobile}</td>
                            <td>{$row.unixtime_lastdrive|date_format:"%b %e, %Y %I:%M %p"}</td>
                            <td class="text-center">{if $row.is_active}<span class="fa fa-check"></span>{else}<span class="fa fa-times"></span>{/if}</td>
                            <td class="text-center">{if $row.is_admin}<span class="fa fa-check"></span>{else}<span class="fa fa-times"></span>{/if}</td>
                            <td class="text-center">{if $row.is_transaction_coordinator}<span class="fa fa-check"></span>{else}<span class="fa fa-times"></span>{/if}</td>
                            <td class="text-center">
                                <a href="/user_view.php?id={$row.user_id}" class="btn btn-success m-r-5 m-b-5 btn-xs"><i class="fa fa-eye"></i>Modify User</a>
                                {if $row.user_id ne $user.user_id}<a href="javascript:;" data-id="{$row.user_id}" data-is-active="0" class="btn btn-xs btn-danger m-r-5 m-b-5 btn-set-inactive"><i class="fa fa-close"></i>Set Inactive</a>{/if}
                            </td>
                        </tr>
                    {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- end panel -->

    <input type="hidden" name="company_id" value="{$company_id}"/>

    <!-- begin panel -->
    <div id="panel-inactive" class="panel panel-inverse" style="display:{if $inactive_users|count > 0}block{else}none{/if};" data-sortable-id="new-contacts">
        <div class="panel-heading">
            <div class="panel-heading-btn">
                <a href="javascript:void(0)" id="show-inactive" class="btn btn-xs btn-info ellips" data-click="panel-collapse" style="margin-top: -1px;">
                    <i class="fa fa-expand"></i> Show Inactive Users
                </a>
            </div>
            <h4 class="panel-title">Inactive Users</h4>
        </div>
        <div class="panel-body" style="display:none;">
            <div class="table-responsive">
                <table id="inactiveUsersTbl" class="table table-striped"> 
                    <thead>
                        <tr>
                            <th width="65%">Name</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    {foreach item=row from=$inactive_users}
                        <tr>
                            <td width="65%">
                                {$row.first_name} {$row.last_name}
                            </td>
                            <td class="text-center">
                                <a href="javascript:;" data-id="{$row.user_id}" data-is-active="1" class="btn btn-info m-b-5 btn-xs btn-set-active"><i class="fa fa-check"></i> Set Active</a>
                            </td>
                        </tr>
                    {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- end panel -->
</div>
<!-- end #content -->

<input type="hidden" name="company_id" value="{$company_id}"/>

<div class="modal fade" id="modal-add-user" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Add User</h4>
            </div>
            <div class="modal-body p-20">
                <form id="form-add-user" action="/ws/user/add" method="post" data-parsley-validate="true">
                    <label class="control-label">First Name</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input type="text" class="form-control" id="first-name" name="first_name" placeholder="Enter first name here" data-parsley-required="true"/>
                        </div>
                    </div>
                    <label class="control-label">Last Name</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input type="text" class="form-control" id="last-name" name="last_name" placeholder="Enter last name here" data-parsley-required="true"/>
                        </div>
                    </div>
                    <label class="control-label">Email</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input type="text" class="form-control" id="email" name="email" placeholder="Enter email address here" data-parsley-required="true"/>  
                        </div>
                    </div>
                    <input type="hidden" id="action" name="action" value="add_user"/>
                </form>
            </div>
            <div class="modal-footer">
                <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="javascript:void(0)" id="btn-add-user" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
            </div>
        </div>
    </div>
</div>

{include file="includes/footer.tpl" company_settings_keyval="1"}