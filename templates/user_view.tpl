{include file="includes/header.tpl"}
<link href="assets/plugins/dropzone/min/dropzone.min.css" rel="stylesheet" />
<link href="/assets/plugins/bootstrap-social/bootstrap-social.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
<link rel="stylesheet" href="assets/plugins/jquery-confirm/dist/jquery-confirm.min.css">
<link href="assets/plugins/summernote/summernote.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap-toggle/css/bootstrap-toggle.min.css" rel="stylesheet" />


<style type="text/css">
    .profile-highlight .checkbox.checkbox-css {
        margin-bottom: 5px !important;
    }
    .profile-highlight .checkbox.checkbox-css:first-of-type {
        margin-top: 10px !important;
    }
    .profile-highlight .checkbox.checkbox-css:last-child {
        margin-bottom: 0 !important;
    }
    .checkbox-css label:before,
    .checkbox-css label:after {
        left: 5px !important;
        top: 0 !important;
    }
    label[for=checkbox_admin][disabled] {
        cursor: not-allowed;
    }
</style>

<!-- begin #content -->
<div id="content" class="content">

    <!-- begin controls -->
    <div class="pull-right">
        <a href="/users_list.php" class="btn btn-sm btn-danger m-b-5">
            <i class="fa fa-arrow-left"></i> Back to Users</a>
        <span id="active-status" class="hide">{if $user_details.is_active eq 0}Inactive{else}Active{/if}</span>
        {if $admin.is_superadmin eq 1 or ($user_details.is_admin eq 0 and $admin.is_admin eq 1) }
        <a id="btn-set-active" href="javascript:;" class="btn btn-info btn-sm m-b-5">{if $user_details.is_active eq 0}
            <i class="fa fa-check"></i>Set Active{else}
            <i class="fa fa-close"></i>Set Inactive{/if}</a>
        <!--<a id="btn-reset-password" href="javascript:;" class="btn btn-info btn-sm m-b-5">-->
        <a id="btn-password-reset" href="#modal-reset-password" data-toggle="modal" class="btn btn-info btn-sm m-b-5">
            <i class="fa fa-unlock-alt"></i> Reset Password</a>
        {/if}
    </div>
    <!-- end controls -->

    <!-- start breadcrumb -->
    <h1 class="page-header">{$company.company_name}
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li>
                <a href="/users_list.php">Users Editor</a>
            </li>
            <li class="active">Edit {$user_details.first_name} {$user_details.last_name}</li>
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

    <!-- begin profile-container -->
    <div class="profile-container" style="margin-bottom: 20px;">
        <!-- begin profile-section -->
        <div class="profile-section">
            <!-- begin profile-left -->
            <div class="profile-left">
                <!-- begin profile-image -->
                <div class="profile-image">
                    {if $user_details.is_profile_photo eq 1}
                    <img src="{$profile_url}" /> {else}
                    <div class="profile-text" style="font-size: 12px;">Profile Picture not set</div>
                    {/if}
                    <i class="fa fa-user hide"></i>
                </div>
                <!-- end profile-image -->

                <div class="m-b-10">
                    <a href="#modal-upload" class="btn btn-warning btn-block btn-sm" data-toggle="modal">Upload Profile Photo</a>
                </div>
                <div class="m-b-10">
                    <a href="#modal-pic-url" class="btn btn-warning btn-block btn-sm" data-toggle="modal">Picture Url</a>
                </div>

                <div class="profile-highlight m-b-10">
                    <h4><i class="fa fa-cog"></i> Account Roles</h4>
                    {if $admin.is_beta eq '1'}
                    <div class="checkbox checkbox-css checkbox-success">
                        <input id="checkbox_beta" type="checkbox" class="btn-set-beta" {if $user_details.is_beta eq 1}checked="true" {/if}>
                        <label for="checkbox_beta">Set to Beta</label>
                    </div>
                    {/if}
                    {if $admin.is_admin eq '1'}
                    <div class="checkbox checkbox-css checkbox-success">
                        <input id="checkbox_admin" type="checkbox" class="btn-set-admin" {if $user_details.is_admin eq 1}checked="true" {/if}{if $user_details.is_superadmin eq 1}disabled{/if}>
                        <label for="checkbox_admin" {if $user_details.is_superadmin eq 1}disabled{/if}>Set to Administrator</label>
                    </div>
                    <div class="checkbox checkbox-css checkbox-success">
                        <input id="checkbox_coordinator" type="checkbox" class="btn-set-coordinator" {if $user_details.is_transaction_coordinator eq 1}checked="true" {/if}>
                        <label for="checkbox_coordinator">Set to Coordinator</label>
                    </div>
                    {/if}
                </div>

                {if $user_details.is_superadmin eq 1 || $user_details.company_id eq 1}
                    <div class="m-b-10">
                        <a id="impersonate-user" href="javascript:;" class="btn btn-danger btn-block btn-sm">Impersonate User</a>
                    </div>
                {/if}

                <!-- <table class="table table-profile">
                    <tbody>
                        {*
                        <tr>
                            <th>First Name: </th>
                            <th>
                                <a href="#" class="editable" data-type="text" data-pk="first_name" data-value="{$user_details.first_name}">{$user_details.first_name}</a>
                            </th>
                        </tr>
                        <tr>
                            <th>Last Name: </th>
                            <th>
                                <a href="#" class="editable" data-type="text" data-pk="last_name" data-value="{$user_details.last_name}">{$user_details.last_name}</a>
                            </th>
                        </tr>
                        <tr>
                            <th>Password: </th>
                            <th>
                                <a href="#" class="editable-password" data-type="password" data-pk="password" data-value="[hidden]">*********</a>
                            </th>
                        </tr> *}
                        {if $admin.is_beta eq '1'}
                        <tr>
                            <th style="vertical-align:middle;">Beta: </th>
                            <th>
                                <div class="checkbox checkbox-css checkbox-success">
                                    <input id="checkbox_beta" type="checkbox" class="btn-set-beta" {if $user_details.is_beta eq 1}checked="true" {/if}>
                                    <label for="checkbox_beta"></label>
                                </div>
                            </th>
                        </tr>
                        {/if}
                        {if $admin.is_superadmin eq '1'}
                        <tr>
                            <th style="vertical-align:middle;">Admin: </th>
                            <th>
                                <div class="checkbox checkbox-css checkbox-success">
                                    <input id="checkbox_admin" type="checkbox" class="btn-set-admin" {if $user_details.is_admin eq 1}checked="true" {/if}>
                                    <label for="checkbox_admin"></label>
                                </div>
                            </th>
                        </tr>
                        {/if}
                        {if $admin.is_admin eq '1'}
                        <tr>
                            <th style="vertical-align:middle;">Cooodinator: </th>
                            <th>
                                <div class="checkbox checkbox-css checkbox-success">
                                    <input id="checkbox_beta" type="checkbox" class="btn-set-coordinator" {if $user_details.is_transaction_coordinator eq 1}checked="true" {/if}>
                                    <label for="checkbox_beta"></label>
                                </div>
                            </th>
                        </tr>
                        {/if}
                        <tr>
                            <th></th>
                            <th></th>
                        </tr>
                    </tbody>
                </table> -->
            </div>
            <!-- end profile-left -->

            <!-- begin profile-right -->
            <div class="profile-right">
                <!-- begin profile-info -->
                <div class="profile-info">
                    <form id="form-edit-profile" action="/services/users/update_user_profile.php" method="POST">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="event_subject">First Name</label>
                                <input type="text" class="form-control" value="{$user_details.first_name}" name="first_name" id="first_name" placeholder="John"
                                />
                            </div>

                            <div class="form-group">
                                <label for="event_subject">Last Name</label>
                                <input type="text" class="form-control" value="{$user_details.last_name}" name="last_name" id="last_name" placeholder="Doe"
                                />
                            </div>

                            <div class="form-group">
                                <label for="event_subject">Email</label>
                                <input type="text" class="form-control" name="email" id="email" value="{$user_details.email}" placeholder="fetu@ccini.com"
                                />
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="event_subject">Phone (office)</label>
                                <input type="text" class="form-control phone-us" name="phone_office" id="phone_office" value="{$user_details.phone_office}"
                                    placeholder="(000) 000-0000" />
                            </div>

                            <div class="form-group">
                                <label for="event_subject">Phone (mobile)</label>
                                <input type="text" class="form-control phone-us" name="phone_mobile" id="phone_mobile" value="{$user_details.phone_mobile}"
                                    placeholder="(000) 000-0000" />
                            </div>

                            <div class="form-group">
                                <label for="event_subject">Phone (fax)</label>
                                <input type="text" class="form-control phone-us" name="phone_fax" id="phone_fax" value="{$user_details.phone_fax}" placeholder="(000) 000-0000"
                                />
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="event_subject">City</label>
                                <input type="text" class="form-control" name="city" id="city" placeholder="City" value="{$user_details.city}" />
                            </div>
                            <div class="form-group">
                                <label for="event_subject">State</label>
                                <select class="form-control" name="state" id="state">
                                    <option value="">--</option>
                                    {include file="includes/states.tpl"}
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="event_subject">Zip</label>
                                <input type="text" class="form-control" name="zip" id="zip" placeholder="Zip Code" value="{$user_details.zip}" />
                            </div>
                        </div>
                        <div class="col-md-8">
                            <div class="form-group">
                                <label for="event_subject">Street Address</label>
                                <input type="text" class="form-control" name="street_address" id="street_address" value="{$user_details.street_address}"
                                    placeholder="00 ABC Street" />
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="event_subject">Timezone</label>
                                <select class="form-control" name="timezone" id="timezone">
                                    {foreach item=row from=$timezones}
                                    <option value="{$row.value}" {if $user_details.timezone eq $row.value}selected="true"{/if}>{$row.name}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>


                        <div class="row">
                            <div class="col-md-12 m-t-20">
                                <legend class="m-b-15">Vehicle</legend>
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label for="event_subject">Make</label>
                                            <input type="text" class="form-control" name="car_make" id="car_make" placeholder="Make" value="{$user_details.car_make}" />
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label for="event_subject">Model</label>
                                            <input type="text" class="form-control" name="car_model" id="car_model" placeholder="Model" value="{$user_details.car_model}"/>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label for="event_subject">Year</label>
                                            <input type="text" class="form-control" name="car_year" id="car_year" placeholder="Year" value="{$user_details.car_year}"/>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label for="event_subject">License Plate No.</label>
                                            <input type="text" class="form-control" name="car_license_num" id="car_license_num" placeholder="License Plate" value="{$user_details.car_license_num}"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row m-t-20">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="event_subject">Bio</label>
                                    <div id="summernote">{$user_details.bio}</div>
                                    <textarea class="form-control" id="bio" style="display:none" placeholder="about yourself" name="bio">{$user_details.bio}</textarea>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="event_subject">Agent Website</label>
                                    <input type="text" class="form-control" value="{$user_details.url_website}" name="url_website" id="url_website" placeholder="Agent Website" />
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="event_subject">Profile Photo Url</label>
                                    <input type="text" class="form-control" value="{$user_details.url_profile_photo}" name="url_profile_photo" id="url_profile_photo" placeholder="twitter.com/pictureofme.jpg" />
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="event_subject">Twitter</label>
                                    <input type="text" class="form-control" value="{$user_details.url_twitter}" name="url_twitter" id="url_twitter" placeholder="twitter.com/tweetums"
                                    />
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="event_subject">Facebook</label>
                                    <input type="text" class="form-control" value="{$user_details.url_facebook}" name="url_facebook" id="url_facebook" placeholder="facebook.com/myprofile"
                                    />
                                </div>
                            </div>
                        </div>

                        <hr>

                        <div class="row">
                            <div class="col-md-12 info-toggle-box pull-right">
                                <div class="panel panel-inverse">
                                    <div class="panel-heading">
                                        <div class="panel-title form-group" style="margin-bottom:0;">
                                            <label for="accept-referral" class="text-white" style="margin-right:10px;">Accept Referrals from Outside of my Company?</label>
                                            <input type="checkbox" id="accept-referral" data-toggle="toggle" data-on="Yes" data-off="No" data-onstyle="success" data-offstyle="danger"
                                                {if $user_details.is_accepting_outside_referral eq 1}checked{/if}>
                                            <input id="accepting-outside-referral" type="hidden" value="{$user_details.is_accepting_outside_referral}" name="accepting_outside_referral">
                                        </div>
                                    </div>
                                    <div class="panel-body bg-black text-white">
                                        <p>Choosing to accept referrals from outside of your company will allow other agents
                                            to find you if they have a referral they are unable to show a home to or has
                                            a buyer they're unable to service at the time. This will allow that agent to
                                            easily find a colleague close to their client who is open to a referral.</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        </fieldset>

                        <input type="hidden" name="user_id" value="{$user_details.user_id}">
                        <button id="save-profile" type="submit" class="btn btn-sm btn-primary m-r-5 pull-right">
                            <i class="fa fa-floppy-o"></i>Save Profile Details</button>

                    </form>
                    <!-- end profile-info -->
                </div>
                <!-- end profile-right -->
            </div>
            <!-- end profile-section -->
        </div>
        <!-- end profile-container -->


        {*
        {if $company.has_offices eq 1}
        <div class="panel panel-inverse m-t-20" data-sortable-id="new-contacts">
            <div class="panel-heading">
                <div class="panel-heading-btn">

                    <a id="add-office" href="#modal-add-office" data-toggle="modal" class="btn btn-xs btn-success" style="margin-top: -1px;">

                        <i class="fa fa-plus"></i>Assign an Office</a>
                </div>
                <h4 class="panel-title">User Offices</h4>
            </div>
            <div class="panel-body">
                <table id="officesTbl" class="table table-responsive table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th style="width:60%;">Name</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach item=row from=$user_offices}
                        <tr>
                            <td>{$row.office_id}</td>
                            <td style="width:60%;">
                                {$row.name}
                            </td>
                            <td class="text-center">
                                <a href="javascript:;" class="btn btn-xs btn-danger m-b-5 btn-unassign" data-toggle="confirmation" data-user-rel-office-id="{$row.user_rel_office_id}"
                                    data-office-id="{$row.office_id}" data-office-name="{$row.name}">
                                    <i class="glyphicon glyphicon-remove"></i>Unassign</a>
                            </td>
                        </tr>
                        {foreachelse}
                        <tr id="tr-no-records">
                            <td class="text-center" colspan="3">
                                Not assigned to any office
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
        {/if}
        *}

    </div>
    <!-- end #content -->

        
    <!-- begin panel -->
    <div class="panel panel-inverse">
        <div class="panel-heading">
            <h4 class="panel-title">Email Header Photo</h4>
        </div>
        <div class="panel-body">

            <div class="row">
                <div class="col-md-12">
                    <!-- <label>Company Email Header Photo</label> -->
                    <div class="profile-image">
                        {if $user_details.url_email_logo ne ''}
                            <img src="{$user_details.url_email_logo}" />
                        {else}
                            <h3 style="margin: 10px 0;">Email Header Photo Not Set</h3>
                        {/if}
                    </div>
                    <div class="m-b-10">
                        <a href="#modal-upload-email-header" class="btn btn-success btn-block btn-sm" data-toggle="modal">Upload Email Header Photo</a>
                    </div>
                </div>
            </div>
            
        </div>
    </div>
    <!-- end panel -->

    <div class="modal fade" id="modal-upload" style="display: none;">
        <div class="modal-dialog" style="max-width: 300px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title">Upload Profile Photo</h4>
                </div>
                <div class="modal-body">
                    <div id="dropzone" class="text-center">
                        <form id="my-dropzone" action="/services/upload_profile_picture.php" class="dropzone needsclick dz-clickable">
                            <div class="dz-message needsclick">
                                Drop files here or click to upload.
                                <br>

                                <div class="fallback">
                                    <input name="file" type="file" />
                                    <input type="hidden" name="user_id" value="{$user_details.user_id}" </div>
                                </div>
                        </form>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                        <a href="#" id="upload-image" data-dz-remove class="btn btn-sm btn-success">Upload image</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="modal-pic-url" style="display: none;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title">Insert Profile Picture Url</h4>
                </div>
                <div class="modal-body p-20">
                    <form id="url-profile-picture" action="/user_view.php/?source=user_view" class="form-horizontal" method="post">
                        <label for="event_subject">Url of Profile Picture</label>
                        <input type="text" class="form-control" name="url_profile_photo" placeholder="https://cool.com/reallycoolimage.jpg" />
                        <input type="hidden" name="user_id" value="{$user_details.user_id}" </form>
                </div>
                <div class="modal-footer">
                    <a href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                    <a href="#" class="btn btn-sm btn-success">Save</a>
                </div>
            </div>
        </div>
    </div>
</form>
    <div class="modal fade" id="modal-add-office" style="display: none;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title">Assign an Office</h4>
                </div>
                <div class="modal-body p-20">
                    <form action="" id="form-add-offices" data-parsley-validate="true" method="post">
                        <label class="control-label">Office</label>
                        <div class="form-group">
                            <div style="width:100%;" class="input-group">
                                <select class="form-control select2" name="offices" id="offices" data-parsley-required="true" data-parsley-errors-container="#offices-errors">
                                    <option value="">Select One</option>
                                    {foreach item=row from=$offices}
                                    <option value="{$row.office_id}">{$row.name}</option>
                                    {/foreach}
                                </select>
                                <div id="offices-errors"></div>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="modal-footer">
                    <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                    <a href="javascript:void(0)" id="btn-add-office" class="btn btn-sm btn-success">
                        <i class="glyphicon glyphicon-plus"></i> Assign</a>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modal-reset-password" style="display: none;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title">Reset Password</h4>
                </div>
                <div class="modal-body p-20">
                    <form action="/services/reset_password.php" method="post" id="frm-reset-password" data-parsley-validate="true">
                        <div class="form-group">
                          <label class="control-label">Please enter the new password for {$user_details.first_name} {$user_details.last_name}</label>
                        </div>

                        <div class="form-group">
                            <div style="width:100%;" class="input-group">
                              <!--<div class="form-group">
                                <input class="form-control" name="pass_val" id="pass_val" type="text" size="40">&nbsp;
                                <a href="javascript:void(0)" id="btn-reset-random" class="btn btn-sm btn-success">Generate</a>
                              </div>-->
                              <div class="input-group">
                                <input type="text" class="form-control" name="pass_val" id="pass_val" type="text" data-parsley-required="true" data-parsley-errors-container="#pass_val-error">
                                <div class="input-group-btn">
                                  <a href="javascript:void(0)" id="btn-reset-random" class="btn btn-success"><i class="fa fa-recycle"></i> Generate</a>
                                  <!--<button class="btn btn-default" id="btn-reset-random" type="button" onclick="javascript:void(0)">Generate</button>-->
                                </div>
                              </div>
								<div id="pass_val-error"></div>
                              <div class="input-group">
								<div class="checkbox checkbox-css checkbox-success" style="margin:10px 0 0 3px;">
									<input id="email_to_user" type="checkbox" name="email_to_user" value="send_email" checked="checked">
									<label for="email_to_user"> Email new password to {$user_details.first_name}</label>
								</div>
                              </div>
                            </div>
                            <input name="email" id="email" type="hidden" value="{$user_details.email}">
                            <input name="id" id="id" type="hidden" value="{$user_details.user_id}">
                            <input name="action" id="action" type="hidden" value="reset_random">
                        </div>
                </div>
                <div class="modal-footer">
                    <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                    <button type="submit" class="btn btn-sm btn-primary m-r-5"><i class="fa fa-unlock-alt"></i> Reset</button>
                </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modal-upload-email-header" style="display: none;">
        <div class="modal-dialog" style="max-width: 300px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title">Upload Email Header Photo</h4>
                </div>
                <div class="modal-body">
                    <div class="text-center">
                        <form id="email-header" action="/services/user_email_header_photo.php" class="dropzone">
                            <div class="dz-message">
                                Drop files here or click to upload.<br>

                                <div class="fallback">
                                    <input name="file" type="file" />
                                </div>
                            </div>
                            <input type="hidden" name="user_id" value="{$user_details.user_id}"/>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <a href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                    <a href="#" id="upload-email-header" data-dz-remove class="btn btn-sm btn-success">Upload image</a>
                </div>
            </div>
        </div>
    </div>


    {include file="includes/footer.tpl"}

    <script type="text/javascript">
        
        Dropzone.options.emailHeader = {
            autoProcessQueue: false,
            uploadMultiple: false,
            maxFiles: 1,
            init: function() {
                var submitButton = $("#upload-email-header");
                emailHeader = this;
                submitButton.on("click", function() {
                    $("#page-loader").append("<p style='position:absolute; top: 70%; left: 46.5%; margin: -20px 0 0 -20px;'>Processing Email Header Photo</p>");
                    $("#page-loader").removeClass('hide');
                    emailHeader.processQueue(); 
                });
                this.on("addedfile", function() {
                    $("#upload-email-header").show();
                });
                this.on("complete", function (file) {
                    if (this.getUploadingFiles().length === 0 && this.getQueuedFiles().length === 0) {
                        console.log("done");
                        window.location = "user_view.php?id={$user_details.user_id}";
                    }
                });

            },
            success: function(file, response){

            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                $.log('XHR ERROR ' + XMLHttpRequest.status);
            }
        };

    </script>
