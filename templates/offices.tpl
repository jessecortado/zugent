{include file="includes/header.tpl"}

<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">

<!-- begin #content -->
<div id="content" class="content">
    <div class="pull-right" role="group" aria-label="...">
        <a href="/settings.php" class="btn btn-sm btn-danger m-b-5"><i class="fa fa-arrow-left"></i> Back to Settings</a>
        <a id="btn-show-add-office" href="#modal-edit" data-toggle="modal" class="btn btn-sm btn-info m-b-5"><i class="fa fa-plus"></i> Add Office</a>
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$company.company_name} 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="/settings.php">Settings</a></li>
            <li class="active">Offices</li>
        </ol>
    </h1>
    <!-- end breadcrumb -->

    <div id="alert_error" class="alert alert-danger fade in m-b-15 hide">
        <strong>Permission Denied!</strong>
        You don't have permission to access the requested process.
        <span class="close" data-dismiss="alert">×</span>
    </div>

    <div class="panel panel-inverse" data-sortable-id="new-contacts">
        <div class="panel-heading">
            <h4 class="panel-title">Offices</h4>
        </div>
        <div id="alert_success" class="alert alert-success fade in hide flash">
            <strong>Success!</strong>
            <span id="msg"></span>
            <span class="close" data-dismiss="alert">×</span>
        </div>
        <div class="panel-body">
            <div class="table-responsive">
                <table id="offices" class="table table-condensed table-striped"> 
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th class="text-center">Name</th>
                            <th class="text-center">City</th>
                            <th class="text-center">State</th>
                            <th class="text-center">MLS</th>
                            <th class="text-center">Is Active</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach item=row from=$all_offices}
                        <tr data-office-id="{$row.office_id}" 
                            data-name="{$row.name}" 
                            data-city="{$row.city}" 
                            data-state="{$row.state}" 
                            data-zip="{$row.zip}" 
                            data-phone-office="{$row.phone_office}" 
                            data-phone-fax="{$row.phone_fax}" 
                            data-street-address="{$row.street_address}">

                            <td>{$row.office_id}</td> 
                            
                            <td class="text-center"><a href="javascript:;" class="editable" data-type="text" data-pk="name" data-value="{$row.name}" data-office-id="{$row.office_id}">{$row.name}</a></td> 
                            <td class="text-center"><a href="javascript:;" class="editable" data-type="text" data-pk="city" data-value="{$row.city}" data-office-id="{$row.office_id}">{$row.city}</a></td>
                            <td class="text-center">
                                <a href="#" class="editable" data-title="Select State" data-type="select2" data-pk="state" data-value="{$row.state}" data-office-id="{$row.office_id}">{$row.state}</a>
                            </td>
                            <td class="text-center">
                                {if !empty($row.is_mls)}
                                    <i style="{* color:#01acac; *}color:#30ca3c; font-size:16px;" class="fa fa-check-square"></i>
                                {else}
                                    {* Not Set *}
                                {/if}
                            </td>

                            {* non-x-editable 
                            <td>{$row.name}</a>
                            <td>{$row.city}</td>
                            <td>{$row.phone_fax}</td>
                            *}

                            <td class="text-center">
                                <div class="checkbox checkbox-css checkbox-success">
                                    <input id="checkbox_css_{$row.office_id}" class="chk-toggle-status form-control" data-office-id="{$row.office_id}" type="checkbox" {if $row.is_active} checked {/if}>
                                    <label for="checkbox_css_{$row.office_id}"></label>
                                </div>
                            </td>
                            <td class="text-center">
                                <a href="#modal-edit" class="btn btn-xs btn-success m-r-5 m-b-5 btn-edit-office" data-toggle="modal" data-user-rel-office-id="{$row.user_rel_office_id}" data-office-id="{$row.office_id}" data-office-name="{$row.name}"><i class="glyphicon glyphicon-edit"></i>Edit</a>
                            </td>
                        </tr>
                        {foreachelse}
                        <tr class="no-data"><td class="text-center" colspan="6">No Offices Available</td></tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <div class="modal fade" id="modal-edit" style="display: none;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title">Add Office</h4>
                </div>
                <div class="modal-body p-20">
                    <form id="form-office" action="/ws/office/add" method="post" data-parsley-validate="true">
                        <label class="control-label">Office Name</label>
                        <div class="form-group">
                            <div style="width:100%;" class="input-group">
                                <input type="text" class="form-control" id="office-name" name="name" placeholder="Enter office name here" data-parsley-required="true" data-parsley-minlength="3"/>
                            </div>
                        </div>
                        <label class="control-label">Office Phone Number</label>
                        <div class="form-group">
                            <div style="width:100%;" class="input-group">
                                <input type="text" class="form-control phone-us" id="phone-office" name="phone_office" placeholder="Enter office phone number here" data-parsley-required="true" data-parsley-minlength="10"/>
                            </div>
                        </div>
                        <label class="control-label">Office Fax Number</label>
                        <div class="form-group">
                            <div style="width:100%;" class="input-group">
                                <input type="text" class="form-control phone-us" id="phone-fax" name="phone_fax" placeholder="Enter office fax number here"/>
                            </div>
                        </div>
                        <label class="control-label">Street Address</label>
                        <div class="form-group">
                            <div style="width:100%;" class="input-group">
                                <input type="text" class="form-control" id="street-address" name="street_address" placeholder="Enter street address here" data-parsley-required="true"/>
                            </div>
                        </div>
                        <label class="control-label">City</label>
                        <div class="form-group">
                            <div style="width:100%;" class="input-group">
                                <input type="text" class="form-control" id="city" name="city" placeholder="Enter city here" data-parsley-required="true"/>
                            </div>
                        </div>
                        <label class="control-label">State</label>
                        <div class="form-group">
                            <div style="width:100%;" class="input-group">
                                <select class="form-control zip-code" name="state" id="state" placeholder="Enter state here" data-parsley-required="true" data-parsley-errors-container="#state-errors">
                                    <option value="">--</option>
                                    {include file="includes/states.tpl"}
                                </select>
                                <div id="state-errors"></div>
                            </div>
                        </div>
                        <label class="control-label">Zip</label>
                        <div class="form-group">
                            <div style="width:100%;" class="input-group">
                                <input type="text" class="form-control" id="zip" name="zip" placeholder="Enter zip here"/>
                            </div>
                        </div>

                        <input type="hidden" id="office-id" name="office_id" value=""/>
                        <input type="hidden" name="column" value="all"/>
                    </form> 

                    <div id="div-mls-office" class="table-responsive">

                        <div id="alert-success-mls" class="alert alert-success fade in hide flash">
                            <strong>Success!</strong>
                            <span id="msg"></span>
                            <span class="close" data-dismiss="alert">×</span>
                        </div>
                        <table id="tbl-mls-offices" class="table table-condensed table-striped"> 
                            <thead>
                                <tr>
                                    <th class="text-center">Office Name</th>
                                    <th class="text-center">City</th>
                                    <th class="text-center">State</th>
                                    <th class="text-center"></th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>

                        <form class="m-t-15" id="form-link-office" action="/ws/office/link_mls_office" method="post" data-parsley-validate="true">
                            <div class="col-md-6">
                                <label class="control-label">MLS</label>
                                <div class="form-group">
                                    <div style="width:100%;" class="input-group">
                                        <select class="form-control" name="mls_id" id="select-mls" placeholder="Select MLS" data-parsley-required="true" data-parsley-errors-container="#mls-errors">
                                            <option value="">--</option>
                                            {foreach item=row from=$mls}
                                            <option value="{$row.mls_id}">{$row.mls_name}</option>
                                            {/foreach}
                                        </select>
                                        <div id="mls-errors"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="control-label">Office</label>
                                <div class="form-group">
                                    <div style="width:100%;" class="input-group">
                                        <select class="form-control" name="mls_office_id" disabled="true" id="mls-office" placeholder="Select Office" data-parsley-required="true" data-parsley-errors-container="#link-errors">
                                            {* <option value="">--</option> *}
                                        </select>
                                        <div id="link-errors"></div>
                                    </div>
                                </div>
                            </div>

                            <input type="hidden" id="office-id" name="office_id" value=""/>

                            <div class="col-md-12 text-center">
                                <button type="submit" class="btn btn-success btn-sm">Add Office</button>
                            </div>

                        </form>


                    </div>
                </div>
                <div class="modal-footer">
                    <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                    <a href="javascript:void(0)" id="btn-add-office" class="btn btn-sm btn-success"><i class="fa fa-save"></i>Save</a>
                </div>
            </div>
        </div>
    </div>

</div>
<!-- end #content -->

{include file="includes/footer.tpl" footer_js="includes/footers/offices_footer.tpl" company_settings_keyval="1"}