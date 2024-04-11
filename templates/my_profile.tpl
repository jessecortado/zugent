{include file="includes/header.tpl"}

<link href="assets/plugins/dropzone/min/dropzone.min.css" rel="stylesheet" />
<link href="/assets/plugins/bootstrap-social/bootstrap-social.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">


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
    label[for=checkbox_admin][disabled]  {
        cursor: not-allowed;
    }



    .profile-header {
        position: relative;
        overflow: hidden;
    }
    .profile-header .profile-header-cover {
        background-image: url(/assets/img/profile-cover2.jpg);
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
        position: absolute;
        left: 0;
        right: 0;
        top: 0;
        bottom: 0;
    }
    .profile-header .profile-header-cover:before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(to bottom,rgba(0,0,0,0) 0,rgba(0,0,0,.75) 100%);
    }
    .profile-header .profile-header-content, .profile-header .profile-header-tab {
        position: relative;
    }
    .profile-header .profile-header-content {
        color: #fff;
        padding: 25px;
    }
    .profile-header-img {
        float: left;
        width: 120px;
        height: 120px;
        overflow: hidden;
        position: relative;
        z-index: 10;
        margin: 0 0 -20px;
        padding: 3px;
        border-radius: 4px;
        background: #fff;
    }
    .profile-header-img img {
        max-width: 100%;
    }
    .profile-header-img+.profile-header-info {
        margin-left: 140px;
    }
    .profile-header-info h4 {
        font-weight: 500;
        color: #fff;
    }
    .profile-header .profile-header-tab {
        background: #fff;
        list-style-type: none;
        margin: -10px 0 0;
        padding: 0 0 0 140px;
        white-space: nowrap;
        border-radius: 0;
    }
    .profile-header .profile-header-tab>li {
        display: inline-block;
        margin: 0;
    }
    .profile-header .profile-header-tab>li.active>a, .profile-header .profile-header-tab>li>a.active {
        color: #242a30;
    }
    
    .btn.btn-yellow, .btn.btn-yellow.disabled, .btn.btn-yellow.disabled:focus, .btn.btn-yellow.disabled:hover, .btn.btn-yellow[disabled], .btn.btn-yellow[disabled]:focus, .btn.btn-yellow[disabled]:hover {
        color: #000;
        background: #ffd900;
        border-color: #ffd900;
    }
    .btn-yellow.active, .btn-yellow.active.focus, .btn-yellow.active:focus, .btn-yellow.active:hover, .btn-yellow:active, .btn-yellow:active.focus, .btn-yellow:active:focus, .btn-yellow:active:hover, .btn-yellow:focus, .btn-yellow:hover, .btn-yellow:not(:disabled):not(.disabled).active, .btn-yellow:not(:disabled):not(.disabled):active, .open>.dropdown-toggle.btn-yellow, .open>.dropdown-toggle.btn-yellow:focus, .open>.dropdown-toggle.btn-yellow:hover, .show>.btn-yellow.dropdown-toggle {
        background: #bfa300;
        border-color: #bfa300;
    }

    .profile-header .profile-header-tab>li>a {
        display: block;
        color: #929ba1;
        line-height: 20px;
        padding: 10px 20px;
        text-decoration: none;
        font-weight: 700;
        font-size: 12px;
        border: none;
    }
    .profile-header .profile-header-tab>li {
        display: inline-block;
        margin: 0;
    }
    .profile-header .profile-header-tab>li.active>a, .profile-header .profile-header-tab>li>a.active {
        color: #242a30 !important;
    }
    .btn.btn-yellow {
        margin-right: 6px;
    }
    .table.table-profile > tbody > tr > td.field {
        width: 150px;
    }

    @media (max-width: 767px) {
        .profile-content, .profile-header .profile-header-content {
            padding: 20px;
        }
        .profile-header-img {
            width: 66px;
            height: 66px;
            margin-top: 10px;
        }
        .profile-header-img+.profile-header-info {
            margin-left: 80px;
        }
        .profile-header .profile-header-tab {
            margin: 0;
            padding: 0;
            white-space: nowrap;
            overflow-y: scroll;
            display: block;
        }
        .profile-header .profile-header-tab>li {
            float: none;
        }
        .btn.btn-yellow {
            margin-top: 8px;
        }
    }
</style>

<!-- begin #content -->
<div id="content" class="content content-full-width">



    <div class="profile">
        <div class="profile-header">
            <!-- BEGIN profile-header-cover -->
            <div class="profile-header-cover"></div>
            <!-- END profile-header-cover -->
            <!-- BEGIN profile-header-content -->
            <div class="profile-header-content">
                <!-- BEGIN profile-header-img -->
                <div class="profile-header-img">
                    <img src="{$profile_url}" alt="">
                </div>
                <!-- END profile-header-img -->
                <!-- BEGIN profile-header-info -->
                <div class="profile-header-info">
                    <h4 class="m-t-10 m-b-5">{$user.first_name} {$user.last_name}</h4>
                    <p class="m-b-10">{if $user.is_admin}Administrator{else}Agent{/if}</p>
                    <a href="/my_profile_edit.php" class="btn btn-xs btn-yellow"><i class="fa fa-pencil"></i> Edit Profile</a>
                    <a href="#modal-pic-url" class="btn btn-xs btn-yellow" data-toggle="modal"><i class="fa fa-camera"></i> Picture URL</a>
                    <a href="#modal-upload" class="btn btn-xs btn-yellow" data-toggle="modal"><i class="fa fa-camera"></i> Upload Profile Photo</a>
                </div>
                <!-- END profile-header-info -->
            </div>
            <!-- END profile-header-content -->
            <!-- BEGIN profile-header-tab -->
            <ul class="profile-header-tab nav nav-tabs">
                <li class="nav-item"><a href="#profile-post" class="nav-link active" data-toggle="tab">PROFILE PAGE</a></li>
                <!-- <li class="nav-item"><a href="#profile-about" class="nav-link" data-toggle="tab">ABOUT</a></li> -->
            </ul>
            <!-- END profile-header-tab -->
        </div>
    </div>



    
    <!-- begin breadcrumb -->
    <!-- <ol class="breadcrumb pull-right">
        <li><a href="javascript:;">Home</a></li>
        <li><a href="javascript:;">Extra</a></li>
        <li class="active">Profile Page</li>
    </ol> -->
    <!-- end breadcrumb -->

{if $social_error == true}
    {if $error_facebook == true}
    <div id="alert_error" class="alert alert-danger fade in m-b-15">
        <strong>Facebook Error!</strong>
        Oops. Something went wrong. Our technical staff has been notified.
        <span class="close" data-dismiss="alert">×</span>
    </div>
    {/if}
    {if $error_linkedin == true}
    <div id="alert_error" class="alert alert-danger fade in m-b-15">
        <strong>LinkedIn Error!</strong>
        Oops. Something went wrong. Our technical staff has been notified.
        <span class="close" data-dismiss="alert">×</span>
    </div>
    {/if}
    {if $error_twitter == true}
    <div id="alert_error" class="alert alert-danger fade in m-b-15">
        <strong>Twitter Error!</strong>
        Oops. Something went wrong. Our technical staff has been notified.
        <span class="close" data-dismiss="alert">×</span>
    </div>
    {/if}
{/if}

<!-- begin profile-container -->
<div class="profile-container" style="margin-top: 2px;">
    <!-- begin profile-section -->
    <div class="profile-section">
        <!-- begin profile-left -->
        <div class="profile-left">
            <!-- begin profile-image -->
            <!-- <div class="profile-image">
                <img src="{$profile_url}" />
                <i class="fa fa-user hide"></i>
            </div> -->
            <!-- end profile-image -->
            <!-- <div class="m-b-10">
                <a href="#modal-upload" class="btn btn-warning btn-block btn-sm" data-toggle="modal">Upload Profile Photo</a>
            </div>
            <div class="m-b-10">
                <a href="#modal-pic-url" class="btn btn-warning btn-block btn-sm" data-toggle="modal">Picture Url</a>
            </div>
            <div class="m-b-10">
                <a href="/my_profile_edit.php" class="btn btn-warning btn-block btn-sm">Edit Profile</a>
            </div> -->

            {if $user.is_superadmin eq 1 or $user.is_admin eq 1 or $user.is_transaction_coordinator eq 1}
            <div class="profile-highlight">
                <h4><i class="fa fa-cog"></i> Account Roles</h4>
                {if $user.is_admin eq 1}
                <div class="checkbox checkbox-css checkbox-success">
                    <input id="checkbox_admin" type="checkbox" checked="true" data-id="{$user.user_id}" class="btn-unset-admin" {if $user.is_superadmin eq 1}disabled{/if}>
                    <label for="checkbox_admin" {if $user.is_superadmin eq 1}disabled{/if}>{if $user.is_superadmin ne 1}Unset{/if} Administrator</label>
                </div>
                {/if}
            </div>
            {/if}
      </div>
      <!-- end profile-left -->
      <!-- begin profile-right -->
      <div class="profile-right">
        <!-- begin profile-info -->
        <div class="profile-info">
            <!-- begin table -->
            <div class="row">
                <div class="col-md-6">
                    <div class="table-responsive">
                        <table class="table table-profile" style="width:50%">
                            <!-- <thead>
                                <tr>
                                    <th></th>
                                    <th>
                                        <h4>{$user.first_name} {$user.last_name}</h4>
                                    </th>
                                </tr>
                            </thead> -->
                            <tbody>
                                <tr class="divider">
                                    <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td class="field">Timezone</td>
                                    <td><a href="#" id="timezone" class="" data-title="Select timezone" data-type="select2" data-pk="timezone" data-value="{$user.timezone}">{$user.timezone}</a></td>
                                </tr>
                                <tr class="divider">
                                    <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td class="field">Facebook</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="url_facebook" data-value="{$user.url_facebook}">{$user.url_facebook}</a></td>
                                </tr>
                                <tr>
                                    <td class="field">Twitter</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="url_twitter" data-value="{$user.url_twitter}">{$user.url_twitter}</a></td>
                                </tr>
                                <tr class="divider">
                                    <td colspan="2"></td>
                                </tr>
                                <tr class="highlight">
                                    <td class="field">About Me</td>
                                    <td>{$user.bio}</td>
                                </tr>
                                <tr class="divider">
                                    <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td class="field">Phone mobile</td>
                                    <td><a href="#" class="editable-phone-mobile" data-type="text" data-pk="phone_mobile" data-value="{$user.phone_mobile}">{$user.phone_mobile}</a></td>
                                </tr>
                                <tr>
                                    <td class="field">Phone office</td>
                                    <td><a href="#" class="editable-phone" data-type="text" data-pk="phone_office" data-value="{$user.phone_office}">{$user.phone_office}</a></td>
                                </tr>
                                <tr>
                                    <td class="field">Phone fax</td>
                                    <td><a href="#" class="editable-phone" data-type="text" data-pk="phone_fax" data-value="{$user.phone_fax}">{$user.phone_fax}</a></td>
                                </tr>
                                <tr class="divider">
                                    <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td class="field">Street Address</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="street_address" data-value="{$user.street_address}">{$user.street_address}</a></td>
                                </tr>
                                <tr>
                                    <td class="field">City</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="city" data-value="{$user.city}">{$user.city}</a></td>
                                </tr>
                                <tr>
                                    <td class="field">State</td>
                                    <td><a href="#" id="state" class="" data-title="Select State" data-type="select2" data-pk="state" data-value="{$user.state}">{$user.state}</a></td>
                                </tr>
                                <tr>
                                    <td class="field">Zip</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="zip" data-value="{$user.zip}">{$user.zip}</a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            <!-- end table -->
            <!-- begin table -->
                <div class="col-md-6">
                    <div class="table-responsive">
                        <table class="table table-profile" style="width:50%">
                            <!-- <thead>
                                <tr>
                                    <th></th>
                                    <th>
                                        <h4>{$user.first_name} {$user.last_name}</h4>
                                    </th>
                                </tr>
                            </thead> -->
                            <tbody>
                                <tr class="divider">
                                    <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td class="field">Realtor License #</td>
                                    <td><a href="#" id="timezone" class="" data-title="Select timezone" data-type="select2" data-pk="timezone" data-value="{$user.timezone}">{$user.timezone}</a></td>
                                </tr>
                                <tr class="divider">
                                    <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td class="field">Make</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="car_make" data-value="{$user.car_make}">{$user.car_make}</a></td>
                                </tr>
                                <tr>
                                    <td class="field">Model</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="car_model" data-value="{$user.car_model}">{$user.car_model}</a></td>
                                </tr>
                                <tr>
                                    <td class="field">Year</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="car_year" data-value="{$user.car_year}">{$user.car_year}</a></td>
                                </tr>
                                <tr>
                                    <td class="field">License Plate No.</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="car_license_num" data-value="{$user.car_license_num}">{$user.car_license_num}</a></td>
                                </tr>
                                <tr class="divider">
                                    <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td class="field">Agent Website</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="url_website" data-value="{$user.url_website}">{$user.url_website}</a></td>
                                </tr>
                                <tr>
                                    <td class="field">Profile Photo URL</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="url_profile_photo" data-value="{$user.url_profile_photo}">{$user.url_profile_photo}</a></td>
                                </tr>
                                <tr>
                                    <td class="field">Twitter</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="url_twitter" data-value="{$user.url_twitter}">{$user.url_twitter}</a></td>
                                </tr>
                                <tr>
                                    <td class="field">Facebook</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="url_facebook" data-value="{$user.url_facebook}">{$user.url_facebook}</a></td>
                                </tr>
                                <tr class="divider">
                                    <td colspan="2"></td>
                                </tr>
                                <!-- <tr>
                                    <td class="field">Accepts Refferal</td>
                                    <td><a href="#" class="editable" data-type="text" data-pk="street_address" data-value="{$user.street_address}">{$user.street_address}</a></td>
                                </tr> -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- end table -->
        </div>
        <!-- end profile-info -->

        {if $company.has_social eq 1}
        <hr>


        <div class="row">
            <div class="col-md-4">
                <div class="panel-inverse">
                    <div class="panel-heading">
                        <div class="panel-title" style="line-height:34px;">
                            <div class="panel-heading-btn">
         
                                {if $error_facebook == false}
                                    {if $user_facebook_account eq ''}
                                    <div class="m-b-10">
                                       <a href="{$facebookUrl}" class="btn btn-block btn-social btn-facebook">
                                          <span class="fa fa-facebook"></span> Link with Facebook
                                      </a>
                                    </div>
                                    {else}
                                    <a href="/ws/facebook/unlink" class="btn btn-danger m-b-5"><i class="fa fa-unlink"></i> Unlink</a>
                                    {/if}
                                {else}
                                <div class="m-b-10">
                                   <a href="#" class="btn btn-block btn-social btn-facebook" disabled>
                                      <span class="fa fa-facebook"></span> Link with Facebook
                                  </a>
                                </div>
                                {/if}

                            </div>

                            <label class="text-white" style="margin-bottom: 0px;">

                                {if $user_facebook_account eq ''}
                                <i class="fa fa-times" style="color:red;font-size: 14px;"></i> Your Facebook is not linked
                                {else}
                                <i class="fa fa-check" style="color:green;font-size: 14px;"></i> Your Facebook is linked
                                {/if}

                            </label>
                        </div>
                    </div>
                    <!-- Remove if done (For Testing Only) - START-->
                    {if $user_facebook_account ne ''}
                    <div class="panel-body" style="background:#242a30;">
                        <img src="{$user.facebook_profilepic_url}" height="150" width="150" style="margin-bottom:20px;">
                        <form class="form-inline" action="/ws/facebook/post" method="POST">
                            <div class="form-group m-r-10">
                                <input type="text" class="form-control" name="message" placeholder="Enter Message" style="min-width:240px;" required>
                            </div>
                            <button type="submit" class="btn btn-sm btn-info"><i class="fa fa-paper-plane"></i> Test Facebook Post</button>
                        </form>
                    </div>
                    {/if}
                    <!-- Remove if done (For Testing Only) - END -->
                </div>
            </div>
            <div class="col-md-4">
                <div class="panel-inverse">
                    <div class="panel-heading">
                        <div class="panel-title" style="line-height:34px;">
                            <div class="panel-heading-btn">

                                {if $error_linkedin == false}
                                    {if $user_linkedin_account eq ''}
                                    <div class="m-b-10">
                                       <a href="{$linkedinUrl}" class="btn btn-block btn-social btn-linkedin">
                                          <span class="fa fa-linkedin"></span> Link with LinkedIn
                                      </a>
                                    </div>
                                    {else}
                                    <a href="/ws/linkedin/unlink_account" class="btn btn-danger m-b-5"><i class="fa fa-unlink"></i> Unlink</a>
                                    {/if}
                                {else}
                                <div class="m-b-10">
                                   <a href="#" class="btn btn-block btn-social btn-linkedin" disabled>
                                      <span class="fa fa-linkedin"></span> Link with LinkedIn
                                  </a>
                                </div>
                                {/if}

                            </div>

                            <label class="text-white" style="margin-bottom: 0px;">

                                {if $user_linkedin_account eq ''}
                                <i class="fa fa-times" style="color:red;font-size: 14px;"></i> Your LinkedIn is not linked
                                {else}
                                <i class="fa fa-check" style="color:green;font-size: 14px;"></i> Your LinkedIn is linked
                                {/if}

                            </label>
                        </div>
                    </div>
                    <!-- Remove if done (For Testing Only) - START-->
                    {if $user_linkedin_account ne ''}
                    <div class="panel-body" style="background:#242a30;">
                        <img src="{$user.linkedin_profilepic_url}" height="150" width="150" style="margin-bottom:20px;">
                        <form class="form-inline" action="/ws/linkedin/post" method="POST">
                            <div class="form-group m-r-10">
                                <input type="text" class="form-control" name="message" placeholder="Enter Message" style="min-width:240px;" required>
                            </div>
                            <button type="submit" class="btn btn-sm btn-info"><i class="fa fa-paper-plane"></i> Test LinkedIn Post</button>
                        </form>
                    </div>
                    {/if}
                    <!-- Remove if done (For Testing Only) - END -->
                </div>
            </div>
            <div class="col-md-4">
                <div class="panel-inverse">
                    <div class="panel-heading">
                        <div class="panel-title" style="line-height:34px;">
                            <div class="panel-heading-btn">

                                {if $error_twitter == false}
                                    {if $user_twitter_account eq ''}
                                    <div class="m-b-10">
                                       <a href="{$twitterUrl}" class="btn btn-block btn-social btn-twitter">
                                          <span class="fa fa-twitter"></span> Link with Twitter
                                      </a>
                                    </div>
                                    {else}
                                    <a href="/ws/twitter/unlink_account" class="btn btn-danger m-b-5"><i class="fa fa-unlink"></i> Unlink</a>
                                    {/if}
                                {else}
                                <div class="m-b-10">
                                   <a href="#" class="btn btn-block btn-social btn-twitter" disabled>
                                      <span class="fa fa-twitter"></span> Link with Twitter
                                  </a>
                                </div>
                                {/if}

                            </div>

                            <label class="text-white" style="margin-bottom: 0px;">

                                {if $user_twitter_account eq ''}
                                <i class="fa fa-times" style="color:red;font-size: 14px;"></i> Your Twitter is not linked
                                {else}
                                <i class="fa fa-check" style="color:green;font-size: 14px;"></i> Your Twitter is linked
                                {/if}

                            </label>
                        </div>
                    </div>
                    <!-- Remove if done (For Testing Only) - START-->
                    {if $user_twitter_account ne ''}
                    <div class="panel-body" style="background:#242a30;">
                        <form class="form-inline" action="/ws/twitter/post" method="POST">
                            <div class="form-group m-r-10">
                                <input type="text" class="form-control" name="message" placeholder="Enter Message" style="min-width:240px;" required>
                            </div>
                            <button type="submit" class="btn btn-sm btn-info"><i class="fa fa-paper-plane"></i> Test Twitter Post</button>
                        </form>
                    </div>
                    {/if}
                    <!-- Remove if done (For Testing Only) - END -->
                </div>
            </div>
        </div>
        {/if}

    </div>
    <!-- end profile-right -->
</div>
<!-- end profile-section -->
</div>
<!-- end profile-container -->
</div>
<!-- end #content -->

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
                            Drop files here or click to upload.<br>

                            <div class="fallback">
                                <input name="file" type="file" />
                            </div>
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

<div class="modal fade" id="modal-pic-url" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Insert Profile Picture Url</h4>
            </div>
            <div class="modal-body p-20">
                <form id="url-profile-picture" action="/my_profile_edit.php/?source=my_profile" class="form-horizontal" method="post">
                    <label for="event_subject">Url of Profile Picture</label>
                    <input type="text" class="form-control" name="url_profile_photo" placeholder="https://cool.com/reallycoolimage.jpg"/>
                </form>
            </div>
            <div class="modal-footer">
                <a href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="#" class="btn btn-sm btn-success">Save</a>
            </div>
        </div>
    </div>
</div>


{include file="includes/footer.tpl"}