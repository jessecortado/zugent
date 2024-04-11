{include file="includes/header.tpl" active_page="drive_monitor"}

<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">

<style type="text/css">
  .info-notice {
    border: none;
      -webkit-box-shadow: none;
      box-shadow: none;
      -webkit-border-radius: 3px;
      -moz-border-radius: 3px;
      border-radius: 3px;
    margin-bottom: 20px;
      background-color: #fff;
  }
  .dtimeline-notify {
      background-color: #f3f6fb;
      border-bottom: none;
      border-color: #e7eaec;
      border-image: none;
      border-width: 1px 0;
      font-size: 15px;
      clear: both;
      text-align: center;
  }
  .dtimeline-notify.no-data {
      border-bottom-right-radius: 3px;
      border-bottom-left-radius: 3px;
  }
  .dtimeline-notify,
  .dtimeline-notify h3 {
      color: #fff;
  }
  a.dash-view-all {
    padding: 10px;
    display: block;
    color: #fff;
      border-bottom-right-radius: 3px;
      border-bottom-left-radius: 3px;
    -webkit-transition: all .1s linear;
      -moz-transition: all .1s linear;
      transition: all .1s linear;
      text-decoration: none;
  }
  tr.text-bold td {
    font-weight: 500;
    padding: 10px !important;
    background-color: #b2b6b7 !important;
  }
  /*a.dash-view-all:hover {
    background-color: #348fe2;
    text-decoration: none;
    color: #fff;
  }*/
  @media (min-width: 767px) {
    .visible-lg, .visible-md, .visible-sm, .visible-xs {
         display: block!important;
    }
  }
</style>

<!-- begin #content -->
<div id="content" class="content">
  {if isset($display_error_message)}
  <div class="alert alert-danger fade in m-b-15">
    <strong>Access Forbidden!</strong>
    You don't have permission to access the requested {$error_content|default:'directory'}.
    <span class="close" data-dismiss="alert">×</span>
  </div>
  {/if}

  <div id="alert_process" class="alert alert-danger fade in m-b-15 hide">
    <strong>Permission Denied!</strong>
    You don't have permission to access the requested process.
    <span class="close" data-dismiss="alert">×</span>
  </div>

  <!-- begin breadcrumb -->
  <ol class="breadcrumb pull-right">
    <li>Home</li>
    <li class="active">Drive Monitor</li>
  </ol>
  <!-- end breadcrumb -->
  <!-- begin page-header -->
  <!-- <h1 class="page-header">Contacts <small>Active</small></h1> -->
  <h1 class="page-header">Drive Monitor</h1>
  <!-- end page-header -->
  <!-- begin row -->
  <div class="row">
    <!-- begin col-4 -->
    <div class="col-md-4 col-sm-6">
      <div class="widget widget-stats bg-green">
        <div class="stats-icon stats-icon-lg"><i class="fa fa-globe fa-fw"></i></div>
        <div class="stats-title">AGENT REQUESTS</div>
        <div class="stats-number" id="total-agents-div">{$total_agent_requests|default:'0'}</div>
      </div>
    </div>
    <!-- end col-4 -->
    <!-- begin col-4 -->
    <div class="col-md-4 col-sm-6">
      <div class="widget widget-stats bg-blue">
        <div class="stats-icon stats-icon-lg"><i class="fa fa-tags fa-fw"></i></div>
        <div class="stats-title">AGENTS DRIVING</div>
        <div class="stats-number" id="total-drivers-div">{$total_agents_driving|default:'0'}</div>
      </div>
    </div>
    <!-- end col-4 -->
    <!-- begin col-4 -->
    <div class="col-md-4 col-sm-6">
      <div class="widget widget-stats bg-black">
        <div class="stats-icon stats-icon-lg"><i class="fa fa-comments fa-fw"></i></div>
        <div class="stats-title">ACCEPTED REQUESTS</div>
        <div class="stats-number" id="total-contacts-div">{$total_contacts|default:'0'}</div>
      </div>
    </div>
    <!-- end col-3 -->
  </div>
  <!-- end row -->

  <div class="row">
    <div class="col-md-12">
      <!-- begin overdue follow-ups panel -->
      <div class="info-notice panel-inverse">
        <div class="panel-heading">
          <h4 class="panel-title">Agent Requests</h4>
        </div>
        <div class="panel-body p-0" id="agent-requests-div">
          {if $contacts|count gt 0}
            <div class="table-responsive">
              <table class="table">
                <thead>
                  <tr>
                    <th></th>
                    <th>Name</th>
                    <th class="text-center">Company</th>
                    <th class="text-center">Phone No.</th>
                    <th class="text-center">Date</th>
                    <th class="text-right">Accepted</th>
                  </tr>
                </thead>
                <tbody>
                  {foreach from=$contacts item="contact"}
                      {if $contact.agent_requests|count gt 0}
                        <tr class="text-bold">

                        <td class="text-left">Contact: {$contact.cfname} {$contact.clname}</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td class="text-center">{$contact.date_created|date_format:$config.date}</td>
                        <td></td>
                                             
                        </tr>
                    
                        {foreach from=$contact.agent_requests item="agent_request"}
                          <tr >
                            <td></td>
                            <td class="text-left">{$agent_request.first_name} {$agent_request.last_name}</td>
                            <td class="text-center">{$agent_request.company_name}</td>
                            <td class="text-center">{$agent_request.phone_mobile}</td>
                            <td class="text-center">{$agent_request.date_requested|date_format:$config.date}</td>
                            <td class="text-right">
                              {if $agent_request.accepted neq 0}
                                {$agent_request.date_assigned|date_format:$config.date}
                              {/if}
                            </td>
                          </tr>
                        {/foreach}
                      {/if}
                  {/foreach}
                </tbody>
              </table>
            </div>
          {else}
            <div class="dtimeline-notify p-4 no-data bg-blue">
              <h3 class="m-t-3 m-b-3 text-center">No Agent Requests</h3>
            </div>
          {/if}
        </div>
      </div>
      <!-- end panel -->
    </div>
  </div>
  <!-- end #row -->

  <div class="row">
    <div class="col-md-12">
      <!-- begin overdue follow-ups panel -->
      <div class="info-notice panel-inverse">
        <div class="panel-heading">
          <h4 class="panel-title">Agents Driving</h4>
        </div>
        <div class="panel-body p-0" id="agents-driving-div">
          {if $agents_driving|count gt 0}
            <div class="table-responsive">
              <table class="table">
                <thead>
                  <tr>
                    <th>Name</th>
                    <th class="text-center">Company</th>
                    <th class="text-center">Latitude</th>
                    <th class="text-right">Longitude</th>
                    <th class="text-right">Last Check-in</th>
                  </tr>
                </thead>
                <tbody>
                  {foreach from=$agents_driving item="drivingAgent"}
                  <tr >
                    <td class="text-left">{$drivingAgent.first_name} {$drivingAgent.last_name}</td>
                    <td class="text-center">{$drivingAgent.company_name}</td>
                    <td class="text-center">{$drivingAgent.last_latitude}</td>
                    <td class="text-right">{$drivingAgent.last_longitude}</td>
                    <td class="text-right">{$drivingAgent.last_drive|date_format:$config.date}</td>
                  </tr>
                  {/foreach}
                </tbody>
              </table>
            </div>
          {else}
            <div class="dtimeline-notify p-4 no-data bg-blue">
              <h3 class="m-t-3 m-b-3 text-center">No Driving Agents</h3>
            </div>
          {/if}
        </div>
      </div>
      <!-- end panel -->
    </div>
  </div>
  <!-- end #row -->

  <div class="row">
    <div class="col-md-12">
      <!-- begin overdue follow-ups panel -->
      <div class="info-notice panel-inverse">
        <div class="panel-heading">
          <h4 class="panel-title">Agents Driving</h4>
        </div>
        <div class="panel-body p-0">
          <div style="width:100%;" id="map-container"></div>
        </div>
      </div>
      <!-- end panel -->
    </div>
  </div>
  <!-- end #row -->
</div>
<!-- end #content -->


{include file="includes/footer.tpl"}
