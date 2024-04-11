{include file="includes/header.tpl"}
<link href="assets/plugins/dropzone/min/dropzone.min.css" rel="stylesheet" />
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap-toggle/css/bootstrap-toggle.min.css" rel="stylesheet" />
<link href="assets/css/settings.css" rel="stylesheet" />

<!-- begin #content -->
<div id="content" class="content">
    <!-- begin page-header -->
    <h3 class="page-header">{$company.company_name} <small>Settings</small></h3>
    <!-- end page-header -->

    {if $user.is_admin eq 1 or $user.is_superadmin eq 1}

    <form action="/settings.php" method="post" data-parsley-validate="true">

        <!-- begin panel -->
        <div class="panel panel-inverse" data-sortable-id="new-contacts">
            <div class="panel-heading">
                <h4 class="panel-title">Company Configuration</h4>
            </div>
            <div class="panel-body">
                {if isset($display_message)}
                <div class="alert alert-success fade in m-b-15">
                    <strong>Success </strong>
                    Company Profile has been updated.
                    <span class="close" data-dismiss="alert">×</span>
                </div>
                <!-- <p class="text-success text-center">Company Profile has been updated</p> -->
                {/if}
                <input type="hidden" name="id" value="{$campaign.campaign_id}"> 
                <input type="hidden" name="action" value="n">
                <fieldset>
                    <input type="hidden" name="company_id" value="{$company.company_id}">

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="event_subject">Company Name</label>
                                <input type="text" class="form-control" value="{$company.company_name}" name="company_name" id="company_name" placeholder="Company or Organization Name" data-parsley-required="true"/>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="event_subject">Timezone</label>
                                <select class="form-control" name="timezone" id="timezone">
                                    {foreach item=row from=$timezones}
                                    <option value="{$row.value}" {if $company.timezone eq $row.value}selected="true"{/if}>{$row.name}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="event_subject">Email Footer Line 1</label>
                                <input type="text" class="form-control" value="{$company.email_footer_line_1}" name="email_footer_line_1" id="email_footer_line_1" placeholder="Email Footer Line 1" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="event_subject">Email Footer Line 2</label>
                                <input type="text" class="form-control" value="{$company.email_footer_line_2}" name="email_footer_line_2" id="email_footer_line_2" placeholder="Email Footer Line 2" />
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="event_subject">Phone Office Number</label>
                                <input type="text" class="form-control phone-us" value="{$company.phone_office}" name="phone_office" id="phone_office" placeholder="Phone Office Number" data-parsley-required="true"/>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="event_subject">Phone Fax Number</label>
                                <input type="text" class="form-control phone-us" value="{$company.phone_fax}" name="phone_fax" id="phone_fax" placeholder="Phone Fax Number"/>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">

                            <div class="form-group">
                                <label for="event_subject">Street Address</label>
                                <input type="text" class="form-control" name="street_address" id="street_address" value="{$company.street_address}" placeholder="Street Address" data-parsley-required="true"/>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="event_subject">City</label>
                                <input type="text" class="form-control" name="city" id="city" placeholder="City" value="{$company.city}" />
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="event_subject">State</label>
                                <select class="form-control" name="state" id="state">
                                    <option value="">--</option>
                                    {include file="includes/states.tpl"}
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="event_subject">Zip</label>
                                <input type="text" class="form-control" name="zip" id="zip" placeholder="Zip Code" value="{$company.zip}"/>
                            </div>

                        </div>
                    </div>

                    {*
                    <hr>

                    <div class="row">
                        <div class="col-md-4 info-toggle-box">
                            <div class="panel panel-inverse">
                                <div class="panel-heading">
                                    <div class="panel-title form-group" style="margin-bottom:0;">
                                        <label for="allow_agents_email_logo" class="text-white" style="margin-right:10px;">Allow agents to use their own custom email logo?</label>
                                        <input type="checkbox" id="allow_agents_email_logo" name="allow_agents_email_logo" data-toggle="toggle"  data-on="Yes" data-off="No" data-onstyle="success" data-offstyle="danger" {if $company.allow_agents_email_logo eq 1}checked{/if}>
                                    </div>
                                </div>
                                <!-- <div class="panel-body bg-black text-white">
                                    <p>Allow agents to use their own custom email logos.</p>
                                </div> -->
                            </div>
                        </div>
                    </div>
                    *}

                    <!-- <hr>

                    <pre>{$company.url_email_logo}</pre>

                    <div class="row">
                        <div class="col-md-12">
                            <label>Company Email Header Photo</label>
                            <div class="profile-image">
                                {if $company.url_email_logo ne ''}
                                    <img src="{$company.url_email_logo}" />
                                {else}
                                    <h3 style="margin: 10px 0;">Company Email Header Photo Not Set</h3>
                                {/if}
                            </div>
                            <div class="m-b-10">
                                <a href="#modal-cupload-email-header" class="btn btn-success btn-block btn-sm" data-toggle="modal">Upload Email Header Photo</a>
                            </div>
                        </div>
                    </div> -->

                </fieldset>
            </div>

            <button type="submit" class="btn btn-sm btn-primary m-l-15 m-t-0 m-b-15"><i class="fa fa-save"></i>Save Company Settings</button>
        </div>
        <!-- end panel -->

        <!-- begin panel -->
        {*
        <div class="panel panel-inverse" data-sortable-id="new-contacts">
            <div class="panel-heading">
                <h4 class="panel-title">Company Email Header Photo</h4>
            </div>
            <div class="panel-body">
                
                <div class="row">
                    <div class="col-md-12">
                        <!-- <label>Company Email Header Photo</label> -->
                        <div class="profile-image">
                            {if $company.url_email_logo ne ''}
                                <img src="{$company.url_email_logo}" />
                            {else}
                                <h3 style="margin: 10px 0;">Company Email Header Photo Not Set</h3>
                            {/if}
                        </div>
                        <div class="m-b-10">
                            <a href="#modal-cupload-email-header" class="btn btn-success btn-block btn-sm" data-toggle="modal">Upload Email Header Photo</a>
                        </div>
                    </div>
                </div>
                
            </div>
        </div>
        *}
        <!-- end panel -->
    </form>

    {/if}


    <div class="row">
       {include file="includes/admin_card.tpl" href="/users_list.php" title="User Editor" desc="Manage your user accounts. Assign administrators and roles. Reset passwords." fa_icon="fa-user" metric="Users" params=$user_editor_data}

       {include file="includes/admin_card.tpl" href="/bucket_manager.php" title="Contact Status" desc="Contact status configuration for sorting your contacts into logical folders." fa_icon="fa-filter" metric="Statuses" params=$buckets_data}

       
       {if $company.has_offices eq 1}
       {include file="includes/admin_card.tpl" href="/offices.php" title="Office Manager" desc="Create your office list that users can be assigned to." fa_icon="fa-building" metric="Offices" params=$office_manager_data}
       {/if}

       {include file="includes/admin_card.tpl" href="/appointment_types.php" title="Follow-Up / Contact Types" desc="Define your follow-up / contact types." fa_icon="fa-calendar" metric="Contact Types" params=$appointment_types_data}

       {include file="includes/admin_card.tpl" href="/file_types.php" title="File Types" desc="Setup your file designations (Form, etc) for reporting and transaction management." fa_icon="fa-file" metric="File Types" params=$file_types_data}

       {if $company.has_campaigns eq 1}
       {include file="includes/admin_card.tpl" href="/custom_strings.php" title="Custom Strings" desc="Configure shortcut variables and downloadable content for your email campaigns." fa_icon="fa-envelope" metric="Strings" params=$custom_strings_data}
       {/if}

       {if $company.has_transactions eq 1}
       {include file="includes/admin_card.tpl" href="/transaction_variables.php" title="Transaction Settings" desc="Setup your transaction types and status indicators for your team." fa_icon="fa-balance-scale" metric="Types/Status" params=$transaction_settings_data}

       {include file="includes/admin_card.tpl" href="/transaction_checklists.php" title="Transaction Checklists" desc="Create checklists for different transaction types to manage your workflow." fa_icon="fa-check-circle" metric="Checklists" params=$transaction_checklists_data}
       {/if}

       {if $company.has_campaigns eq 1}
       {include file="includes/admin_card.tpl" href="/campaign_list.php" title="Campaigns" desc="Manage your campaigns" fa_icon="fa-envelope-open" metric="Campaigns" params=$campaigns_data}
       {/if}

       {if $user.company_id eq 1 && $user.is_admin ne 0}
       {include file="includes/admin_card.tpl" href="/zugent_dashboard.php" title="Zugent Company Portal" desc="View companies in zugent" fa_icon="fa-user-circle-o" metric="Companies" params=$zugent_portal_data}
       {/if}
       
   </div>

</div>
<!-- end #content -->


<div class="modal fade" id="modal-cupload-email-header" style="display: none;">
    <div class="modal-dialog" style="max-width: 300px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Upload Email Header Photo</h4>
            </div>
            <div class="modal-body">
                <div class="text-center">
                    <form id="cemail-header" action="/services/company_email_header_photo.php" class="dropzone">
                        <div class="dz-message">
                            Drop files here or click to upload.<br>

                            <div class="fallback">
                                <input name="file" type="file" />
                            </div>
                        </div>
                        <input type="hidden" name="company_id" value="{$company.company_id}">
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <a href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="#" id="cupload-email-header" data-dz-remove class="btn btn-sm btn-success">Upload image</a>
            </div>
        </div>
    </div>
</div>

{include file="includes/footer.tpl" company_settings_keyval="1"}
