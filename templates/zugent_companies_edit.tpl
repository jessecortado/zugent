{include file="includes/header.tpl"}
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
<link href="assets/plugins/bootstrap-eonasdan-datetimepicker/build/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap-toggle/css/bootstrap-toggle.min.css" rel="stylesheet" />
<link href="assets/css/settings.css" rel="stylesheet" />

<!-- begin #content -->
<div id="content" class="content">
    <div class="pull-right">
        <a href="/zugent_dashboard.php" class="btn btn-sm btn-info m-b-5"><i class="fa fa-arrow-left"></i> Back to Zugent Dashboard</a>
    </div>

    <!-- begin page-header -->
    <h3 class="page-header">{$company.0.company_name} <small>Settings</small></h3>
    <!-- end page-header -->

    <form action="/zugent_companies_edit.php" method="post" data-parsley-validate="true" data-parsley-excluded="[disabled=disabled]">
        <!-- begin panel -->
        <div class="panel panel-inverse" data-sortable-id="new-contacts">
            <div class="panel-heading">
                <h4 class="panel-title">General Settings</h4>
            </div>
            <div class="panel-body">
                {if isset($display_message)}
                <div class="alert alert-success fade in m-b-15">
                    <strong>Success </strong>
                    Company Settings has been updated.
                    <span class="close" data-dismiss="alert">×</span>
                </div>
                <!-- <p class="text-success text-center">Company Profile has been updated</p> -->
                {/if}
                <input type="hidden" name="id" value="{$campaign.campaign_id}"> 
                <input type="hidden" name="action" value="n">
                <fieldset>
                    <input type="hidden" name="company_id" value="{$company.0.company_id}">

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="event_subject">Company Name</label>
                                <input type="text" class="form-control" value="{$company.0.company_name}" name="company_name" id="company_name" placeholder="Company or Organization Name" data-parsley-required="true"/>
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
                                <input type="text" class="form-control" value="{$company.0.email_footer_line_1}" name="email_footer_line_1" id="email_footer_line_1" placeholder="Email Footer Line 1" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="event_subject">Email Footer Line 2</label>
                                <input type="text" class="form-control" value="{$company.0.email_footer_line_2}" name="email_footer_line_2" id="email_footer_line_2" placeholder="Email Footer Line 2" />
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="event_subject">Phone Office Number</label>
                                <input type="text" class="form-control phone-us" value="{$company.0.phone_office}" name="phone_office" id="phone_office" placeholder="Phone Office Number" data-parsley-required="true"/>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="event_subject">Phone Fax Number</label>
                                <input type="text" class="form-control phone-us" value="{$company.0.phone_fax}" name="phone_fax" id="phone_fax" placeholder="Phone Fax Number" data-parsley-required="true"/>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">

                            <div class="form-group">
                                <label for="event_subject">Street Address</label>
                                <input type="text" class="form-control" name="street_address" id="street_address" value="{$company.0.street_address}" placeholder="Street Address"/>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="event_subject">City</label>
                                <input type="text" class="form-control" name="city" id="city" placeholder="City" value="{$company.0.city}" />
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
                                <input type="text" class="form-control" name="zip" id="zip" placeholder="Zip Code" value="{$company.0.zip}"/>
                            </div>

                        </div>
                    </div>  

                    <hr>

                    <div class="row">
                        <div class="col-md-12">
                            <h5 style="font-weight: bold;margin-top: 0px;">Billing Details</h5>
                        </div>

                        <div class="col-md-6 info-toggle-box">
                            <div class="panel panel-inverse">
                                <div class="panel-heading">
                                    <div class="panel-title form-group" style="margin-bottom:0;">
                                        <label for="is_free" class="text-white" style="margin-right:10px;">Is Free?</label>
                                        <input type="checkbox" id="is_free" name="is_free" data-toggle="toggle"  data-on="Yes" data-off="No" data-onstyle="success" data-offstyle="danger" value="{$company.0.is_free}" {if $company.0.is_free eq 1}checked{/if}>
                                    </div>
                                </div>
                                <div class="panel-body bg-black">
                                
                                    <label class="control-label text-white">Date Free Ends</label>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <input id="date-free-ends" type="text" class="date form-control" data-parsley-required="true" {if $company.0.is_free eq 0}disabled{/if}/>
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                    </div>
                                    <input type="hidden" name="date_free_ends" value="{$company.0.date_free_ends}" id="selected-date-free" />

                                    <label class="control-label text-white">Discount Per User</label>
                                    <div class="form-group">
                                        <div style="width:100%;" class="input-group">
                                            <input type="text" id="discount-per-user" name="discount_per_user" value="{$company.0.discount_per_user}" class="form-control" data-parsley-required="true">
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>

                    <hr>

                    <div class="row">
                        <div class="col-md-12">
                            <h5 style="font-weight: bold;margin-top: 0px;">Feature Access</h5>
                        </div>

                        <div class="col-md-4 info-toggle-box">
                            <div class="panel panel-inverse">
                                <div class="panel-heading" style="border-radius: 3px;">
                                    <div class="panel-title form-group" style="margin-bottom:0;">
                                        <label for="has_transactions" class="text-white" style="margin-right:10px;">Show Transactions</label>
                                        <input type="checkbox" id="has_transactions" name="has_transactions" data-toggle="toggle"  data-on="Yes" data-off="No" data-onstyle="success" data-offstyle="danger" value="{$company.0.has_transactions}" {if $company.0.has_transactions eq 1}checked{/if}>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 info-toggle-box">
                            <div class="panel panel-inverse">
                                <div class="panel-heading" style="border-radius: 3px;">
                                    <div class="panel-title form-group" style="margin-bottom:0;">
                                        <label for="has_drive" class="text-white" style="margin-right:10px;">Show Drive</label>
                                        <input type="checkbox" id="has_drive" name="has_drive" data-toggle="toggle"  data-on="Yes" data-off="No" data-onstyle="success" data-offstyle="danger" value="{$company.0.has_drive}" {if $company.0.has_drive eq 1}checked{/if}>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 info-toggle-box">
                            <div class="panel panel-inverse">
                                <div class="panel-heading" style="border-radius: 3px;">
                                    <div class="panel-title form-group" style="margin-bottom:0;">
                                        <label for="has_pools" class="text-white" style="margin-right:10px;">Show Pools</label>
                                        <input type="checkbox" id="has_pools" name="has_pools" data-toggle="toggle"  data-on="Yes" data-off="No" data-onstyle="success" data-offstyle="danger" value="{$company.0.has_pools}" {if $company.0.has_pools eq 1}checked{/if}>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 info-toggle-box">
                            <div class="panel panel-inverse">
                                <div class="panel-heading" style="border-radius: 3px;">
                                    <div class="panel-title form-group" style="margin-bottom:0;">
                                        <label for="has_bulk_email" class="text-white" style="margin-right:10px;">Show Bulk Email</label>
                                        <input type="checkbox" id="has_bulk_email" name="has_bulk_email" data-toggle="toggle"  data-on="Yes" data-off="No" data-onstyle="success" data-offstyle="danger" value="{$company.0.has_bulk_email}" {if $company.0.has_bulk_email eq 1}checked{/if}>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 info-toggle-box">
                            <div class="panel panel-inverse">
                                <div class="panel-heading" style="border-radius: 3px;">
                                    <div class="panel-title form-group" style="margin-bottom:0;">
                                        <label for="has_referrals" class="text-white" style="margin-right:10px;">Show Referrals</label>
                                        <input type="checkbox" id="has_referrals" name="has_referrals" data-toggle="toggle"  data-on="Yes" data-off="No" data-onstyle="success" data-offstyle="danger" value="{$company.0.has_referrals}" {if $company.0.has_referrals eq 1}checked{/if}>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 info-toggle-box">
                            <div class="panel panel-inverse">
                                <div class="panel-heading" style="border-radius: 3px;">
                                    <div class="panel-title form-group" style="margin-bottom:0;">
                                        <label for="has_social" class="text-white" style="margin-right:10px;">Show Social</label>
                                        <input type="checkbox" id="has_social" name="has_social" data-toggle="toggle"  data-on="Yes" data-off="No" data-onstyle="success" data-offstyle="danger" value="{$company.0.has_social}" {if $company.0.has_social eq 1}checked{/if}>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 info-toggle-box">
                            <div class="panel panel-inverse">
                                <div class="panel-heading" style="border-radius: 3px;">
                                    <div class="panel-title form-group" style="margin-bottom:0;">
                                        <label for="has_broker_page" class="text-white" style="margin-right:10px;">Show Broker Page</label>
                                        <input type="checkbox" id="has_broker_page" name="has_broker_page" data-toggle="toggle"  data-on="Yes" data-off="No" data-onstyle="success" data-offstyle="danger" value="{$company.0.has_broker_page}" {if $company.0.has_broker_page eq 1}checked{/if}>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 info-toggle-box">
                            <div class="panel panel-inverse">
                                <div class="panel-heading" style="border-radius: 3px;">
                                    <div class="panel-title form-group" style="margin-bottom:0;">
                                        <label for="has_campaigns" class="text-white" style="margin-right:10px;">Show Campaigns</label>
                                        <input type="checkbox" id="has_campaigns" name="has_campaigns" data-toggle="toggle"  data-on="Yes" data-off="No" data-onstyle="success" data-offstyle="danger" value="{$company.0.has_campaigns}" {if $company.0.has_campaigns eq 1}checked{/if}>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 info-toggle-box">
                            <div class="panel panel-inverse">
                                <div class="panel-heading" style="border-radius: 3px;">
                                    <div class="panel-title form-group" style="margin-bottom:0;">
                                        <label for="has_offices" class="text-white" style="margin-right:10px;">Show Offices</label>
                                        <input type="checkbox" id="has_offices" name="has_offices" data-toggle="toggle"  data-on="Yes" data-off="No" data-onstyle="success" data-offstyle="danger" value="{$company.0.has_offices}" {if $company.0.has_offices eq 1}checked{/if}>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>


                </fieldset>
            </div>

            <button type="submit" class="btn btn-sm btn-primary m-l-15 m-t-0 m-b-15"><i class="fa fa-save"></i>Save Company Settings</button>
        </div>
        <!-- end panel -->
    </form>

</div>
<!-- end #content -->


{include file="includes/footer.tpl"}
