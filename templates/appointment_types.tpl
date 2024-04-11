{include file="includes/header.tpl"}

<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">

<!-- begin #content -->
<div id="content" class="content">
    <div class="pull-right btn-group" role="group" aria-label="...">
        <a href="/settings.php" class="btn btn-sm btn-danger m-b-5"><i class="fa fa-arrow-left"></i>Back to Settings</a>
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$company.company_name} 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="/settings.php">Settings</a></li>
            <li class="active">Follow-Up / Contact Types</li>
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
            <h4 class="panel-title">Add Contact Type</h4>
        </div>
        <div class="panel-body">
            <form id="add-appointment-type" data-parsley-validate="true">
                <div class="form-group col-sm-12 col-md-5">
                    <input id="appointment-type" type="text" class="form-control" placeholder="Enter contact type name here" data-parsley-required="true">
                </div>
                <div class="form-group col-sm-12 col-md-5">
                    <div style="width:100%;" class="input-group">
                        <select style="width:100%;" name="appointment-icon" id="appointment-icon" class="form-control" data-parsley-required="true" data-parsley-errors-container="#ai_error">
                            <option value="">Select Appointment Icon</option>
                            {foreach from=$appointment_icon_addselect item='row'}
                            <option value="{$row.id}"><i class="fa {$row.text}"></i> {$row.text}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div id="ai_error"></div>
                </div>
                <div class="form-group-btn col-sm-12 col-md-2">
                    <button type="sumbit" class="btn btn-success ellips"><i class="glyphicon glyphicon-plus"></i> Add Contact Type</button>
                </div>
            </form>
        </div>
    </div>
    <!-- end file type form -->

    <div class="row">
        <!-- begin panel -->
        <div class="col-md-6">
            <div class="panel panel-inverse">
                <div class="panel-heading">
                    <h4 class="panel-title">Active Follow-Up / Contact Types</h4>
                </div>
                <div id="alert_success_activetypes" class="alert alert-success fade in hide flash">
                    <strong>Success!</strong>
                    <span id="msg"></span>
                    <span class="close" data-dismiss="alert">×</span>
                </div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <table id="appointment-types" class="table table-condensed"> 
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th class="text-center">Follow-Up / Contact Type</th>
                                    <th class="text-center">Icon</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach item=row from=$appointment_active_types}
                                <tr>
                                    <td>{$row.appointment_type_id}</td>
                                    <td class="text-center">
                                        <a href="javascript:;" class="editable-appointment-name" data-type="text" data-pk="{$row.appointment_type_id}" data-value="{$row.appointment_type}" data-name="{$row.appointment_type}">
                                            {$row.appointment_type}
                                        </a>
                                    </td>
                                    <td class="text-center">
                                        <a href="javascript:;" class="editable-appointment-icon" data-type="select2" data-pk="{$row.appointment_type_id}" data-value="{$row.appointment_icon}" data-name="{$row.appointment_icon}" data-icon="{$row.appointment_icon}">
                                            <i class="fa {$row.appointment_icon}"></i> {$row.appointment_icon|replace:'fa-':''}
                                        </a>
                                    </td>
                                    <td class="text-center">
                                        <a href="#alert_success_activetypes" class="btn btn-xs btn-danger btn-disable" data-appointment-type-id="{$row.appointment_type_id}" data-appointment-type="{$row.appointment_type}" data-appointment-icon="{$row.appointment_icon}">
                                            <i class="glyphicon glyphicon-remove"></i>Disable
                                        </a>
                                    </td>
                                </tr>
                                {foreachelse}
                                <tr class="no-data"><td class="text-center" colspan="4">No Contact File Types Available</td></tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="panel panel-inverse">
                <div class="panel-heading">
                    <h4 class="panel-title">Disabled Follow-Up / Contact Types</h4>
                </div>
                <div id="alert_success_disabledtypes" class="alert alert-success fade in hide flash">
                    <strong>Success!</strong>
                    <span id="msg"></span>
                    <span class="close" data-dismiss="alert">×</span>
                </div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <table id="disabled-appointment-types" class="table table-condensed"> 
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th class="text-center">Follow-Up / Contact Type</th>
                                    <th class="text-center">Icon</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach item=row from=$appointment_inactive_types}
                                <tr>
                                    <td>{$row.appointment_type_id}</td>
                                    <td class="text-center">{$row.appointment_type}</td>
                                    <td class="text-center"><i class="fa {$row.appointment_icon}"></i> {$row.appointment_icon|replace:'fa-':''}</td>
                                    <td class="text-center">
                                        <a href="#alert_success_disabledtypes" class="btn btn-xs btn-success btn-activate" data-appointment-type-id="{$row.appointment_type_id}" data-appointment-type="{$row.appointment_type}" data-appointment-icon="{$row.appointment_icon}">
                                            <i class="glyphicon glyphicon-check"></i>Enable
                                        </a>
                                    </td>
                                </tr>
                                {foreachelse}
                                <tr class="no-data"><td class="text-center" colspan="4">No Contact File Types Available</td></tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- end panel -->
    </div>

</div>
<!-- end #content -->

{include file="includes/footer.tpl" company_settings_keyval="1"}