{include file="includes/header.tpl"}

<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />

<style type="text/css">
  .timeline-buttons a {
    -webkit-box-shadow: 0 2px 5px 0 rgba(0,0,0,.16), 0 2px 10px 0 rgba(0,0,0,.12);
    box-shadow: 0 2px 5px 0 rgba(0,0,0,.16), 0 2px 10px 0 rgba(0,0,0,.12);
  }
  .agent-profile img {
    border-radius: 50%;
    border: 3px solid #00acac;
    padding: 3px;
    margin: 0 auto;
    width: 120px;
    height:120px;
    object-fit: cover;
    display: block;
  }
  .location-not-set {
    display: block;
    padding: 15px;
    margin: 20px 0;
    background: rgba(0, 0, 0, 0.85);
    -webkit-box-shadow: 0px 0px 15px 1px rgba(0,0,0,0.7);
    -moz-box-shadow: 0px 0px 15px 1px rgba(0,0,0,0.7);
    box-shadow: 0px 0px 15px 1px rgba(0,0,0,0.7);
    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    border-radius: 3px;
  }
  .location-not-set h5{
    color: #fff;
  }
  .w3et {
    width: 32.5%;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .btn-info.no-marg i {
    margin-right: 0 !important;
  }
</style>

<!-- begin #content -->
<div id="content" class="content">

  <!-- start breadcrumb -->
  <h1 class="page-header">{$company.company_name} 
      <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
          <li class="active">Drive</li>
      </ol>
  </h1>
  <!-- end breadcrumb -->

  <div id="check-in-notice" class="alert alert-success fade in m-b-15 hide">
    <strong>Check-In!</strong>
      You have successfully check-in.
    <span class="close" data-dismiss="alert">×</span>
  </div>

  <div id="browser-error" class="alert alert-danger fade in m-b-15 hide">
    <strong>Permission Denied!</strong>
      Your browser does not allow to get your location.
    <span class="close" data-dismiss="alert">×</span>
  </div>
    
  <div id="location-not-set" class="location-not-set text-center">
    <h5>Location is not set</h5>
    <a href="javascript:;" id="set-location" class="btn btn-sm btn-success">Set My Location</a>
  </div>
  
  <div id="location-set">

  <!-- <button id="btn-drive" onclick="getLocation(true)" class="btn btn-sm btn-info m-b-20">Start Driving</button> -->

  <div id="map-error" class="alert alert-danger fade in m-b-15 hide">
    <strong>Geolocation Error!</strong>
      <span id="message"></span>
    <span class="close" data-dismiss="alert">×</span>
  </div>

  <div class="panel panel-inverse">
    <div class="panel-heading">
      <h4 class="panel-title">Map Location</h4>
    </div>
    <div class="panel-body" style="padding: 3px">

      {foreach item=row key=key from=$user_locations}
        {if $key == 0}
          <a href="#" data-lat="{$row.latitude}" data-lon="{$row.longitude}" class="btn btn-sm btn-info m-b-5 btn-view-in-map w3et">
            <i class="glyphicon glyphicon-eye-open"></i> View in Map
          </a>
          <button id="check-in" class="btn btn-sm btn-success m-b-5 w3et">
            <i class="fa fa-map-marker"></i> Check In Location
          </button>
          <button id="btn-drive" onclick="getLocation(true)" class="btn btn-sm btn-primary m-b-5 w3et">
            <i class="fa fa-car"></i> Start Driving
          </button>
        {/if}
      {/foreach}

      <div id="browser-info" class="alert alert-info fade in m-b-3 hide">
        <strong>Drive mode has been enabled. Please leave this page open while driving to continuously update your location. When you're drive has completed please leave this page or click "Stop Driving". Your location will be refreshed in 60 seconds.</strong>
      </div>

      <div style="width:100%;" id="map-container"></div>
    </div>
  </div>

  <div class="col-lg-3 col-md-12 col-sm-12">
    <div class="row">
      <div class="panel panel-inverse">
        <div class="panel-heading">
          <h4 class="panel-title">Agent Profile</h4>
        </div>
        <div class="panel-body">
          {foreach item=row key=key from=$user_locations}
            {if $key == 0}
            <div class="agent-profile text-center">
              {if $user.is_profile_photo}
              <img src="https://s3-us-west-2.amazonaws.com/zugent/profilephotos/{$row.user_id}/original.jpg" />
              {else}
              <img src="assets/img/user-13.jpg" />
              {/if}
              <i class="fa fa-user hide"></i>
              <h4>{$row.first_name} {$row.last_name}</h4>
              <!-- <p>Last Check-In: {$row.unixtime_collected|time_ago|ucfirst}</p> -->
              <p>Last Check-In: {$row.unixtime_collected|date_format:"%b %e, %Y %I:%M %p"}</p>
              <!-- <a href="#" data-lat="{$row.latitude}" data-lon="{$row.longitude}" class="btn btn-sm btn-info m-r-5 m-b-5 btn-view-in-map" style="min-width: 133px;">
                <i class="glyphicon glyphicon-eye-open"></i> View in Map
              </a>
              <button id="check-in" class="btn btn-sm btn-success m-r-5 m-b-5" style="min-width: 133px;">
                <i class="fa fa-map-marker"></i> Check In Location
              </button>
              <button id="btn-drive" onclick="getLocation(true)" class="btn btn-sm btn-primary m-r-5 m-b-5" style="min-width: 133px;">
                <i class="fa fa-car"></i> Start Driving
              </button> -->
            </div>
            {/if}
          {/foreach}
        </div>
      </div>

      <div class="panel panel-inverse" data-sortable-id="new-contacts">
        <div class="panel-heading">
          <h4 class="panel-title">Locations</h4>
        </div>
        <div class="panel-body">
          <div class="table-responsive">
            <table id="buckets" class="table table-striped"> 
              <thead>
                <tr>
                  <th>Checkin</th>
                  <th class="text-center">Location</th>
                </tr>
              </thead>
              <tbody>
              {foreach item=row from=$user_locations}
                <tr>
                  <!-- <td>{$row.unixtime_collected|time_ago|ucfirst}</td> -->
                  <td>{$row.unixtime_collected|date_format:"%b %e, %Y %I:%M %p"}</td>
                  <td class="text-center">
                      <a href="javascript:;" data-lat="{$row.latitude}" data-lon="{$row.longitude}" class="btn btn-xs btn-info m-b-5 btn-view-in-map"><i class="glyphicon glyphicon-eye-open"></i>View in Map</a>
                  </td>
                  <!-- <td class="text-center">
                      <a href="javascript:;" class="btn btn-xs btn-danger m-b-5 btn-delete" data-bucket-id="{$row.user_location_id}"><i class="glyphicon glyphicon-remove"></i>Delete</a>
                  </td> -->
                </tr>
              {/foreach}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="col-lg-9 col-md-12 col-sm-12">
    <div class="row">
      <!-- begin panel -->
      <div class="info-notice panel-inverse">
        <div class="panel-heading">
          <h4 class="panel-title">Accepted Clients</h4>
        </div>
        <div class="panel-body p-0">
          <div class="table-responsive">
            <table class="table" name="transactionAlerts" id="transactionAlerts">
              <thead>
                <tr>
                  <th>Client</th>
                  <th class="text-center">Status</th>
                  <th class="text-center">Phone Number</th>
                  <th class="text-center">Email Address</th>
                  <th class="text-center">Actions</th>
                </tr>
              </thead>
              <tbody>
                {foreach item=row from=$contacts}
                <tr>
                  <td>{$row.first_name} {$row.last_name}</td>
                  <td class="text-center">{$row.contact_status}</td>
                  <td class="text-center">{$row.phone_number}</td>
                  <td class="text-center">{$row.email}</td>
                  <td class="text-center">
                    <a href="/contacts_edit.php?id={$row.contact_id}" rel="tooltip" title="Contact Page" class="btn btn-info btn-xs no-marg"><i class="fa fa-address-card"></i></a>
                    <a href="tel:{$row.phone_number}" rel="tooltip" title="Call Client" class="btn btn-info btn-xs no-marg"><i class="fa fa-phone"></i></a>
                    {if $row.is_unsubscribed eq 0}
                      <a href="#xmodal-send-message" data-toggle="modal" rel="tooltip" title="Send Email" class="btn btn-info btn-xs no-marg" data-cid="{$row.contact_id}"><i class="fa fa-envelope"></i></a>
                    {else}
                      <a href="javascript:;" data-toggle="modal" rel="tooltip" title="This contact has unsubscribed from emails from Zugent" class="btn btn-info btn-xs no-marg"><i class="fa fa-envelope"></i></a>
                    {/if}
                    <a href="javascript:;" rel="tooltip" title="View in Map" class="btn btn-info btn-xs no-marg" data-lat="{$row.latitude}" data-lon="{$row.longitude}"><i class="fa fa-eye"></i></a>
                    <a href="https://www.google.com/maps/dir/?api=1&destination={$row.latitude},{$row.longitude}" rel="tooltip" title="Directions" class="btn btn-info btn-xs no-marg" target="_blank"><i class="fa fa-map-marker"></i></a>
                  </td>
                </tr>
                {foreachelse}
                <tr class="no-data"><td class="text-center" colspan="9">No Recent Clients</td></tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        </div>
      </div>
      <!-- end panel -->
    </div>
  </div>

</div>
<!-- end #content -->

<div class="modal fade" id="modal-get-location-address" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 id="location-error" class="modal-title">Location<span></span></h4>
      </div>
      <div class="modal-body p-20">
        <p>We're unable to locate you. Please enter your current address/landmark.</p>
        <form id="form-get-location-address" method="post" data-parsley-validate="true">
          <label class="control-label">Address</label>
          <div class="form-group">
            <textarea class="form-control" rows=2 name="location-address" id="location-address" data-parsley-required="true"></textarea>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
        <a href="javascript:void(0)" id="modal-save-location-address" class="btn btn-sm btn-success"><i class="fa fa-map-marker"></i> Get Location</a>
      </div>
    </div>
  </div>
</div>

{include file="includes/footer.tpl" company_settings_keyval="1"}