{include file="includes/header.tpl" active_page="drive_spoof"}

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
  .checkbox.checkbox-css input:checked+label:after,
  .checkbox.checkbox-css label:before {
    left: 6px;
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
    <li class="active">Drive Spoof</li>
  </ol>
  <!-- end breadcrumb -->
  <!-- begin page-header -->
  <!-- <h1 class="page-header">Contacts <small>Active</small></h1> -->
  <h1 class="page-header">Drive Spoof</h1>
  <!-- end page-header -->

  <div class="row">

    <div class="col-md-12">
      <!-- begin overdue follow-ups panel -->
      <div class="info-notice panel-inverse">
        <div class="panel-heading">
          <h4 class="panel-title">Agent Lists</h4>
        </div>
        <div class="panel-body p-0">
          {if $agents|count gt 0}
            <div class="table-responsive">
              <table class="table" style="border-bottom: 1px solid #ddd;">
                <thead>
                  <tr>
                    <th class="text-left">
                      <!-- <input type="checkbox" onClick="toggle_boxes(this)"> -->
                      <div class="checkbox checkbox-css checkbox-success">
                        <input id="checkbox_all" type="checkbox" onClick="toggle_boxes(this)">
                        <label for="checkbox_all"></label>
                      </div>
                    </th>
                    <th>Name</th>
                    <th class="text-center">Last Drive</th>
                    <th class="text-center">Latitude</th>
                    <th class="text-center">Longitude</th>
                    <th class="text-center">Distance (Miles)</th>
                  </tr>
                </thead>
                <tbody>
                  {foreach from=$agents item="agent"}
                  <tr>
                    <td>
                      <!-- <input type="checkbox" name="agent-id" value="{$agent.user_id}"> -->
                      <div class="checkbox checkbox-css checkbox-success">
                        <input id="checkbox_agent-{$agent.user_id}" type="checkbox" name="agent-id" value="{$agent.user_id}">
                        <label for="checkbox_agent-{$agent.user_id}"></label>
                      </div>
                    </td>
                    <td class="text-left">{$agent.first_name} {$agent.last_name}</td>
                    <td class="text-center">{$agent.last_drive|date_format}</td>
                    <td class="text-center">{$agent.last_latitude}</td>
                    <td class="text-center">{$agent.last_longitude}</td>
                    <td class="text-center">{$agent.distance|string_format:"%.2f"}</td>
                  </tr>
                  {/foreach}
                </tbody>
              </table>
            </div>
          {else}
            <div class="dtimeline-notify p-4 no-data bg-blue">
              <h3 class="m-t-3 m-b-3 text-center">No Agent Requests</h3>
            </div>
          {/if}

          <div class="col-md-12" style="text-align: center;padding: 10px 0;">
            <button id="spoof-agents" href="javascript:;" class="btn btn-success" style="margin-top: -1px;"><i class="fa fa-car"></i>Spoof</button>
          </div>
        </div>
      </div>
      <!-- end panel -->
    </div>


    <div class="col-md-12">
      <!-- begin overdue follow-ups panel -->
      <div class="info-notice panel-inverse">
        <div class="panel-heading">
          <h4 class="panel-title">Agent Locations</h4>
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
