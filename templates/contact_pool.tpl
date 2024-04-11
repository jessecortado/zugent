{include file="includes/header.tpl"}

<link href="assets/plugins/DataTables/dataTables.min.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />

<style type="text/css">
    .result-buttons, .result-info {
        display: block !important;
    }
    .result-info {
        padding-bottom: 0 !important;
        position: relative;
    }
    .result-info .desc {
        margin-bottom: : 0 !important;
    }
    .result-info .title,
    .result-info .title a {
        color: #fff;
    }
    .result-buttons {
        padding-top: 0 !important;
        text-align: center;
    }
    .result-buttons a {
        width: 49%;
        display: inline-block;
        margin-top: 0px !important;
    }
    .no-pool {
        padding: 15px;
        margin: 20px 0;
        background: rgba(0, 0, 0, 0.85);
        color: #fff;
        -webkit-box-shadow: 0px 0px 15px 1px rgba(0,0,0,0.7);
        -moz-box-shadow: 0px 0px 15px 1px rgba(0,0,0,0.7);
        box-shadow: 0px 0px 15px 1px rgba(0,0,0,0.7);
        -webkit-border-radius: 3px;
        -moz-border-radius: 3px;
        border-radius: 3px;
    }
    .client-card {
        overflow: hidden;
        border-radius: 4px;
        position: relative;
        display: inline-block;
        background: rgba(0, 0, 0, 0.85);
        padding: 1.5em;
        margin: 0 0 1.5em;
        width: 100%;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        -webkit-box-sizing: border-box;
        -webkit-box-shadow: 0px 0px 15px 1px rgba(0,0,0,0.7);
        -moz-box-shadow: 0px 0px 15px 1px rgba(0,0,0,0.7);
        box-shadow: 0px 0px 15px 1px rgba(0,0,0,0.7);
    }
    .ribbon {
        background-color: #009aab;
        background-color: #ffa500;
        font-weight: bold;
        color: #fff;
        display: block;
        font-size: 12px;
        height: 30px;
        margin: 1px 0;
        padding: 7px 0 10px 0;
        position: absolute;
        right: -36px;
        top: 30px;
        overflow: hidden;
        white-space: nowrap;
        text-align: center;
        text-transform: uppercase;
        width: 160px;
        -webkit-transform: rotate(45deg);
        -moz-transform: rotate(45deg);
        -ms-transform: rotate(45deg);
        -o-transform: rotate(45deg);
        transform: rotate(45deg);
        -webkit-box-shadow: 0 2px 0 rgba(0,0,0,0.15), inset 0 -1px 0 rgba(0,0,0,0.1);
        -moz-box-shadow: 0 2px 0 rgba(0,0,0,0.15),inset 0 -1px 0 rgba(0,0,0,0.1);
        box-shadow: 0 2px 0 rgba(0,0,0,0.15), inset 0 -1px 0 rgba(0,0,0,0.1);
    }
    @media only screen and (max-width: 414px) {
        .result-info .title a {
            display: block;
        }
    }
    @media only screen and (min-width: 900px) {
        .masonry {
            -moz-column-count: 2;
            -webkit-column-count: 2;
            column-count: 2;
        }
    }
    @media only screen and (min-width: 1200px) {
        .masonry {
            -moz-column-count: 3;
            -webkit-column-count: 3;
            column-count: 3;
        }
    }
    @media only screen and (min-width: 1600px) {
        .masonry {
            -moz-column-count: 4;
            -webkit-column-count: 4;
            column-count: 4;
        }
    }
    .masonry {
        margin: 1.5em 0;
        padding: 0;
        -moz-column-gap: 1.5em;
        -webkit-column-gap: 1.5em;
        column-gap: 1.5em;
    }
</style>

<!-- begin #content -->
<div id="content" class="content">

    <div class="pull-right">
        <a href="#modal-add-pool" data-toggle="modal" class="btn btn-success btn-sm" id="add-transaction"><i class="fa fa-plus"></i> Add Pool</a>
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$company.company_name} 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="/settings.php">Settings</a></li>
            <li class="active">Contact Pool</li>
        </ol>
    </h1>
    <!-- end breadcrumb -->

    <!-- <hr> -->

    <ul class="nav nav-pills">
        <li class="active"><a href="#nav-pills-tab-1" data-toggle="tab">My Pools</a></li>
        <li class=""><a href="#nav-pills-tab-2" data-toggle="tab">Shared Pools</a></li>
    </ul>

    <div class="tab-content" style="padding:0;background:transparent;">
        <div class="tab-pane fade active in" id="nav-pills-tab-1">
            {if $my_pools|count ne 0}
            <div class="masonry">
                {foreach item=row from=$my_pools}
                <div class="client-card">
                    <div class="ribbon">
                        {if $row.share_level == '1'}
                        Personal
                        {elseif $row.share_level == '2'}
                        Company Wide
                        {elseif $row.share_level == '3'}
                        Everyone
                        {else}
                        None
                        {/if}
                    </div>
                    <div class="result-info">
                        <h4 class="title">Pool Name: <a href="/pool_edit.php?id={$row.pool_id}"><b>{$row.name}</b></a></h4>
                        <p class="location">Date Created: {$row.date_created|date_format:'%b'}{$row.date_created|date_format:" jS, "}{$row.date_created|date_format:'%Y'}</p>
                        <p class="location">Date Uploaded: {$row.date_updated|date_format:'%b'}{$row.date_updated|date_format:" jS, "}{$row.date_updated|date_format:'%Y'}</p>
                        <p class="location">Uploaded By: {$row.first_name} {$row.last_name}</p>
                        <p class="location"># of Leads: {$row.leads_count}</p>
                        <div class="desc">Description: {$row.description|default:"<p>n/a</p>"}</div>
                        <hr>
                    </div>
                    <div class="result-buttons">
                        <a href="/pool_leads_list.php?id={$row.pool_id}" class="btn btn-success btn-block"><i class="fa fa-list"></i> View Leads</a>
                        <a href="/pool_edit.php?id={$row.pool_id}" class="btn btn-success btn-block"><i class="fa fa-edit"></i> Edit Pool</a>
                    </div>
                </div>
                {/foreach}
            </div>
            {else}
            <h5 class="text-center no-pool">No Created Pools</h5>
            {/if}
        </div>
        <div class="tab-pane fade" id="nav-pills-tab-2">
            {if $contact_pool|count ne 0}
            <div class="masonry">
                {foreach item=row from=$contact_pool}
                <div class="client-card">
                    <div class="ribbon">
                        {if $row.share_level == '1'}
                        Personal
                        {elseif $row.share_level == '2'}
                        Company Wide
                        {elseif $row.share_level == '3'}
                        Everyone
                        {else}
                        None
                        {/if}
                    </div>
                    <div class="result-info">
                        <h4 class="title">Pool Name: <a href="/pool_edit.php?id={$row.pool_id}"><b>{$row.name}</b></a></h4>
                        <p class="location">Date Created: {$row.date_created|date_format:'%b'}{$row.date_created|date_format:" jS, "}{$row.date_created|date_format:'%Y'}</p>
                        <p class="location">Date Uploaded: {$row.date_updated|date_format:'%b'}{$row.date_updated|date_format:" jS, "}{$row.date_updated|date_format:'%Y'}</p>
                        <p class="location">Uploaded By: {$row.first_name} {$row.last_name}</p>
                        <p class="location"># of Leads: {$row.leads_count}</p>
                        <div class="desc">Description: {$row.description|default:"n/a"}</div>
                    </div>
                    <div class="result-buttons">
                        <a href="/pool_leads_list.php?id={$row.pool_id}" class="btn btn-success btn-block" style="width:100%;"><i class="fa fa-list"></i> View Leads</a>
                    </div>
                </div>
                {/foreach}
            </div>
            {else}
            <h5 class="text-center no-pool">No Shared Pools</h5>
            {/if}
        </div>
    </div>



    {*
    <h4>Shared Pools</h4>
    
    {foreach item=row from=$contact_pool}
    <!-- begin panel -->
    <div class="panel panel-inverse">
        <div class="panel-heading">
            <h4 class="panel-title">Pool Name: <b>{$row.name}</b></h4>
        </div>
        <div class="panel-body">
            <table id="tbl-pool" class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Share Level</th>
                        <th>Date Created</th>
                        <th>Date Updated</th>
                        <th>Uploaded by</th>
                        <th># of Leads</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>{$row.pool_id}</td> 
                        <td>{$row.share_level}</td>
                        <td>{$row.date_created}</td>
                        <td>{$row.date_updated}</td>
                        <td>{$row.first_name} {$row.last_name}</td>
                        <td>{$row.leads_count}</td>
                    </tr>
                    <tr>
                        <td colspan="6" class="text-center">{$row.description}</td>
                    </tr>
                </tbody>
            </table>
            <div class="text-center">
                <a href="/pool_leads_list.php?id={$row.pool_id}" class="btn btn-success">View Leads</a>
            </div>
        </div>
    </div>
    <!-- end panel -->
    {foreachelse}
        <h5 class="text-center">No Shared Pools</h5>
    {/foreach}
    
    <hr>
    <h4>My Pools</h4>

    {foreach item=row from=$my_pools}
    <!-- begin panel -->
    <div class="panel panel-inverse">
        <div class="panel-heading">
            <h4 class="panel-title">Pool Name: <b>{$row.name}</b></h4>
        </div>
        <div class="panel-body">
            <table id="tbl-pool" class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Share Level</th>
                        <th>Date Created</th>
                        <th>Date Updated</th>
                        <th>Uploaded by</th>
                        <th># of Leads</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>{$row.pool_id}</td> 
                        <td>{$row.share_level}</td>
                        <td>{$row.date_created}</td>
                        <td>{$row.date_updated}</td>
                        <td>{$row.first_name} {$row.last_name}</td>
                        <td>{$row.leads_count}</td>
                    </tr>
                    <tr>
                        <td colspan="6" class="text-center">{$row.description}</td>
                    </tr>
                </tbody>
            </table>
            <div class="text-center">
                <a href="/pool_leads_list.php?id={$row.pool_id}" class="btn btn-success">View Leads</a>
                <a href="/pool_edit.php?id={$row.pool_id}" class="btn btn-success">Edit Pool</a>
            </div>
        </div>
    </div>
    <!-- end panel -->
    {foreachelse}
        <h5 class="text-center">No Created Pools</h5>
    {/foreach}
    *}
</div>

<!-- end #content -->
<div class="modal fade" id="modal-add-pool" style="display: none;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Add Pool</h4>
            </div>
            <div class="modal-body p-20">
                <form id="form-add-pool" action="services/pool_manager.php" class="form-horizontal" method="post" data-parsley-validate="ture">
                    <label class="control-label">Name</label>

                    <div style="width:100%;" fclass="input-group">
                        <input type="text" id="pool-name" name="pool_name" class="form-control" data-parsley-required="true">
                    </div>

                  <!--   <label class="control-label">Description</label>

                    <div style="width:100%;" fclass="input-group">
                        <textarea rows="7" id="description" name="description" class="form-control"></textarea>
                    </div>

                    <label class="control-label">Share Level</label> -->

                    <!-- <div style="width:100%;" fclass="input-group">
                        <select style="width:100%;" id="share-level" name="share_level" class="form-control">
                            <option value="1">1</option>
                            <option value="2">2</option>
                        </select>
                    </div> -->

                    <input type="hidden" id="action" name="action" value="add_pool"/>
                    <input type="hidden" id="pool-id" value=""/>
                </form>
            </div>
            <div class="modal-footer">
                <a id="close-add-modal" href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="#" id="btn-add-pool" class="btn btn-sm btn-success">Save</a>
            </div>
        </div>
    </div>
</div>

{include file="includes/footer.tpl" company_settings_keyval="1"}