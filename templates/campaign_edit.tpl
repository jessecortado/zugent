{include file="includes/header.tpl"}

<link href="assets/plugins/dropzone/min/dropzone.min.css" rel="stylesheet" />
<link href="/assets/plugins/bootstrap-social/bootstrap-social.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
<link href="assets/plugins/parsley/src/parsley.css" rel="stylesheet" />

<style type="text/css">
    .checkbox-css label:before,
    .checkbox-css label:after {
        left: 5px !important;
        top: 0 !important;
    }
</style>

<!-- begin #content -->
<div id="content" class="content">
	<!-- begin breadcrumb -->
	<ol class="breadcrumb pull-right">
		<li>Home</li>
		<li><a href="/dashboard.php">Dashboard</a></li>
		<li class="active"><a href="/campaign_list.php">Campaigns List</a></li>
	</ol>
	<!-- end breadcrumb -->
	<!-- begin page-header -->
	<h1 class="page-header">Campaigns <small>{$campaign.campaign_name}</small></h1>
	<!-- end page-header -->


	<!-- begin row -->
	<div class="row">

	    <div class="col-md-12 col-sm-12">

	        <!-- begin panel -->
            <div class="panel panel-inverse" data-sortable-id="new-contacts">
                <div class="panel-heading">
                    <h4 class="panel-title">Campaign Details</h4>
                </div>
                <div class="panel-body">
					<form action="/campaign_edit.php" method="post" data-parsley-validate="true">
						<input type="hidden" name="id" value="{$campaign.campaign_id}"> 
						<input type="hidden" name="action" value="s">
						<fieldset>
                            <div class="form-group">
                                <label for="campaign_name">Campaign Name</label>
                                <input type="text" name="campaign_name" class="form-control" id="campaign_name" value="{$campaign.campaign_name}" placeholder="Enter a campaign name" data-parsley-required="true" />
                            </div>

                            <div class="checkbox">
								<div class="checkbox checkbox-css checkbox-success">
									<input id="is_base" type="checkbox" name="is_base" {if $campaign.is_base}checked=checked{/if}>
									<label for="is_base" > Base (Top Level) campaign</label>
								</div>
                            </div>

                            <div class="checkbox">
								<div class="checkbox checkbox-css checkbox-success">
									<input id="is_copyable" type="checkbox" name="is_copyable" {if $campaign.is_copyable}checked=checked{/if}>
									<label for="is_copyable" > Others may copy</label>
								</div>
                            </div>

                            <div class="form-group">
                                <label for="shared_level">Sharing Level</label>
								<select id="shared_level" name="shared_level" class="form-control">
                                    <option value="1" {if $campaign.shared_level eq 1}SELECTED{/if}>Personal</option>
                                    <option value="2" {if $campaign.shared_level eq 2}SELECTED{/if}>Organization Wide</option>
                                    {* Disabled for now
                                    <option value="3" {if $campaign.shared_level eq 3}SELECTED{/if}>Global</option>
                                    *}
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="description">Description</label>
                                <textarea name="description" class="form-control" cols="30" rows="10">{$campaign.description}</textarea>
                            </div>

                            <button type="submit" class="btn btn-sm btn-primary m-r-5"><i class="fa fa-save"></i> Save</button>
                        </fieldset>

					</form>

                </div>
            </div>
            <!-- end panel -->

	        <!-- begin panel -->
            <div class="panel panel-inverse" data-sortable-id="new-contacts">
                <div class="panel-heading">
                    <div class="panel-heading-btn">
                        <a href="/campaign_new_event.php?id={$campaign.campaign_id}" class="btn btn-success btn-xs m-r-5"><i class="fa fa-plus"></i> Create New Event</a>
                    </div>
                    <h4 class="panel-title">Campaign Events</h4>
                </div>
                <div class="panel-body">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>On Day</th>
                                <th colspan=2>Message To?</th>
                                <th>Updated</th>
                            </tr>
                        </thead>
                        <tbody>
							{foreach from=$events item="data"}
                                <tr>
                                    <td><a href="/campaign_edit_event.php?id={$data.campaign_event_id}">{$data.campaign_event_id}</a></td>
                                    <td>{$data.event_name}</td>
									<td>{$data.send_after_days}</td>
									<td>{if $data.is_event_to_user}User{/if}</td><td>{if $data.is_event_to_client}Client{/if}</td>
									<td>{$data.date_modified|date_format}</td>
                                </tr>
							{foreachelse}
								<tr><td colspan="6" class="text-center">You don't have any events!</td></tr>
							{/foreach}
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- end panel -->

	        <!-- begin panel -->
            <div class="panel panel-inverse" data-sortable-id="new-contacts">
                <div class="panel-heading">
                    <h4 class="panel-title">Campaign Downloads</h4>
                </div>
                <div class="panel-body">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Uploader</th>
                                <th>Label</th>
                                <th>Filename</th>
                            </tr>
                        </thead>
                        <tbody>
							{foreach from=$campaign_downloads item="data"}
                                <tr>
                                    <td>{$data.campaign_download_id}</td>
                                    <td>{if $data.user_id gt 0}{$data.first_name} {$data.last_name}{else}System{/if}</td>
                                    <td>{$data.file_label}</td>
                                    <td>{$data.original_filename}</td>
                                </tr>
							{foreachelse}
								<tr><td colspan="4" class="text-center">You don't have any downloads added to this campaign!</td></tr>
							{/foreach}
                        </tbody>
                    </table>

					<a href="#modal-upload" class="btn btn-warning btn-block btn-sm" data-toggle="modal">Upload Campaign File</a>

                </div>
            </div>
            <!-- end panel -->



	    </div>
	</div>
<!-- end #row -->



<div class="panel panel-inverse" data-sortable-id="new-contacts">
    <div class="panel-heading">
        <h4 class="panel-title">Custom Strings</h4>
    </div>
    <div class="panel-body">
        <table id="custom-strings" class="table table-condensed"> 
            <thead>
                <tr>
                    <th>Key</th>
                    <th>Value</th>
                </tr>
            </thead>
            <tbody>
                {foreach item=row from=$custom_strings}
                <tr>
                    <td><a href="#custom-strings" class="editable-campaign-var-key" data-type="text" data-var-id="{$row.campaign_variable_id}" data-pk="var_key" data-value="{$row.var_key}" data-name="{$row.var_key}">{$row.var_key}</a></td>
                    <td><a href="#custom-strings" class="editable-campaign-var-val" data-type="text" data-var-id="{$row.campaign_variable_id}" data-pk="var_val" data-value="{$row.var_val}">{$row.var_val}</a></td>
                </tr>
                {/foreach}
            </tbody>
        </table>

        <form id="form-add-custom-string" class="input-group input-group-sm" data-parsley-validate="true">
            <div class="col-sm-5">
                <input id="var-key" data-parsley-pattern="^[a-zA-Z0-9_]+$" data-parsley-pattern-message="Please only use letters" data-parsley-required="true" type="text" class="form-control" placeholder="Enter Key">
            </div>
            <div class="col-sm-5">
                <input id="var-val" data-parsley-required="true" type="text" class="form-control" placeholder="Enter Value">
            </div>
            <div class="input-group-btn">
                <button type="button" id="add-custom-string" class="btn btn-success"><i class="glyphicon glyphicon-plus"></i> Add Custom String</button>
            </div>
        </form>
    </div>
</div>
<!-- end panel -->

</div>
<!-- end #content -->




<div class="modal fade" id="modal-upload" style="display: none;">
    <div class="modal-dialog" style="max-width: 300px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Upload Campaign File</h4>
            </div>
            <div class="modal-body">

	            <div class="form-group">
	                <label for="file_label">File Label</label>
	                <input type="text" name="file_label" class="form-control" id="file_label" placeholder="Enter a file label" />
	            </div>

                <div id="dropzone" class="text-center">
					<form id="my-dropzone" action="/services/upload_campaign_file.php" class="dropzone needsclick dz-clickable">
	                    <input type="hidden" name="campaign_id" value="{$campaign.campaign_id}"/>
	                    <input type="hidden" id="campaign_file_label" name="campaign_file_label" value=""/>
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
                <a href="#" id="upload-file" data-dz-remove class="btn btn-sm btn-success">Upload File</a>
            </div>
        </div>
    </div>
</div>


<script src="/assets/plugins/select2/dist/js/select2.min.js" defer></script>
<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js" defer></script>
<script src="assets/plugins/parsley/dist/parsley.js" defer></script>

<script type="text/javascript">
function add_more() {
  var html = $(".copy").html();
  $(".after-add-more").after(html);
}
function remove_more(contgroup) {
  alert('test');
  $(contgroup).parents(".control-group").remove();
}

defer(deferred_method);

function defer(method){
    if (window.jQuery)
        method();
    else
        setTimeout(function() { defer(method) }, 50);
}

function deferred_method(){

    

}

</script>
		
{include file="includes/footer.tpl" footer_js="includes/footers/campaign_edit_footer.tpl"}