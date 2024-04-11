{include file="includes/header.tpl"}
	<link href="assets/plugins/summernote/summernote.css" rel="stylesheet" />
	<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
		
		<!-- begin #content -->
		<div id="content" class="content">
			<!-- begin breadcrumb -->
			<!-- <ol class="breadcrumb pull-right">
				<li>Home</li>
				<li><a href="/dashboard.php">Dashboard</a></li>
				<li><a href="/contact_pool.php">Contact Pool List</a></li>
				<li class="active">New Pool</li>
			</ol> -->
			<!-- end breadcrumb -->

		    <div class="pull-right">
		        <a href="/import_pool_leads.php?id={$id}" class="btn btn-success btn-sm"><i class="fa fa-upload"></i> Import Leads</a>
		    </div>

		    <!-- start breadcrumb -->
		    <h1 class="page-header">
		        <ol class="breadcrumb" style="display:inline-block;font-size:14px;">
		            <li><a href="/contact_pool.php">Contact Pools</a></li>
		            <li class="active">Edit Pool</li>
		        </ol>
		    </h1>
		    <!-- end breadcrumb -->

	        <!-- begin panel -->
			<form id="form-pool" action="services/pool_manager.php" method="POST" data-parsley-validate="true">
			<input type="hidden" name="pool_id" value="{$pool.pool_id}"/>
			<input type="hidden" name="action" value="update_pool"/>

            <div class="panel panel-inverse">
                <div class="panel-heading">
                    <h4 class="panel-title">Pool Details</h4>
                </div>
                <div class="panel-body">
					<fieldset>
						<div class="row">
							<div class="col-md-6">
                                <div class="form-group">
                                    <label for="name">Pool Name</label>
                                    <input type="text" class="form-control" value="{$pool.name}" name="pool_name" id="pool-name" placeholder="Pool Name" data-parsley-required="true"/>
                                </div>
							</div>
							<div class="col-md-3">
                                <div class="form-group">
                                    <label for="share_level">Share Level</label> {*
                                    <input type="text" class="form-control" value="{$pool.share_level}" name="share_level" id="share-level" placeholder="John" />
                                    *}
                                    <select class="form-control" name="share_level" id="share-level" data-parsley-required="true" data-parsley-errors-container="#share-level-errors">
                                    	<option value="1">Personal</option>
                                    	<option value="2">Company Wide</option>
                                    	<option value="3">Everyone</option>
                                    </select>
                                </div>
                                <div id="share-level-errors"></div>
							</div>
							<div class="col-md-3">
                                <div class="form-group">
                                    <label for="is_active">Is Active</label>
                                    <input type="checkbox" class="form-control" id="chk-is-active" placeholder="John" />
                                    <input type="hidden" id="is-active" name="is_active" value="{$pool.is_active}">
                                </div>
							</div>
						</div>
						<div class="row m-t-20">
							<div class="col-md-12">
                                <div class="form-group">
                                    <label for="event_subject">Description</label>
                                    <div id="summernote">{$pool.description}</div>
                                    <textarea class="form-control" id="description" style="display:none" placeholder="about yourself" name="description">{$pool.description}</textarea>
                                </div>
							</div>
						</div>
					</fieldset>
					
					<button id="save-pool" type="submit" class="btn btn-sm btn-primary m-r-5"><i class="fa fa-save"></i> Save Pool Details</button>

                </div>
            </div>
			</form>
            <!-- end panel -->

        <!-- begin panel -->
        <div class="panel panel-inverse">
            <div class="panel-heading">
                <h4 class="panel-title">Imports</h4>
            </div>
            <div class="panel-body">
                
                <table id="tbl-pool-imports" class="table table-striped table-responsive"> 
                    <thead>
                        <tr>
                            <th>File Name</th>
                            <th>Imported By</th>
                            <th>Date Uploaded</th>
                            <!-- <th>City</th>
                            <th>County</th> -->
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>

                        {foreach item=row from=$pool_imports}
                            <tr id="pool-lead-{$row.pool_lead_id}">
                                <td>{$row.original_filename}</td> 
                                <td>{$row.imported_by}</td>
                                <td>{$row.date_uploaded|date_format}</td>
                                <td>
                                    <a href="ws/pools/download_pool_file/{$row.pool_import_id}" class="btn btn-xs btn-success m-r-5 m-b-5" target="_blank"><i class="glyphicon glyphicon-eye-open"></i>Download</a>
                                </td>
                            </tr>
                        {foreachelse}
                            <tr><td class="text-center" colspan="5">No Files Imported</td></tr>
                        {/foreach}

                    </tbody>
                </table>
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
		        </div>7p
		    </div>
		</div>
		
	<script src="assets/plugins/summernote/summernote.min.js" defer></script>
	<script src="assets/plugins/select2/dist/js/select2.min.js" defer></script>

	<script type="text/javascript">
		defer(deferred_method);

        function defer(method){
            if (window.jQuery)
                method();
            else
                setTimeout(function() { defer(method) }, 500);
        }

        function deferred_method() {
        	$("#share-level").select2();
        	$("#share-level").val({$pool.share_level}).trigger('change.select2');

        	$(document).ready(function() {
        		if($("#is-active").val() == 1) {
        				$("#chk-is-active").prop("checked", true);
        		}
        		else {
        				$("#chk-is-active").prop("checked", false);
        		}
        	});

        	$('#summernote').summernote({
        		placeholder: 'Give this pool a description',
        		height: "300px"
        	});

        	$('#summernote').on('summernote.change', function(we, contents, $editable) {
				$("#description").html(contents);
			});

			$('#save-pool').click(function(){
				console.log("help");
				$("#form-pool").submit();
			});

			$('#state').val('{$user.state}');

			$(document).on("click", "#chk-is-active", function(){
				if($(this).is(":checked") == true) {
					$("#is-active").val("1");
				}
				else {
					$("#is-active").val("0");
				}
			});

			if($("#chk-is-active").is(":checked") == true) {
					$("#is-active").val("1");
			}
			else {
					$("#is-active").val("0");
			}

        }

	</script>

{include file="includes/footer.tpl"}