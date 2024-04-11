{include file="includes/header.tpl" active_page="social_calendar"}


<link href="assets/plugins/fullcalendar/fullcalendar.print.css" rel="stylesheet" media='print' />
<link href="assets/plugins/fullcalendar/fullcalendar.min.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap-eonasdan-datetimepicker/build/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />
<link href="assets/css/pages/social_calendar.css" rel="stylesheet" />

<!-- begin #content -->
<div id="content" class="content">

    <!-- begin panel -->
    <div class="panel panel-inverse" data-sortable-id="new-contacts">
        <div class="panel-heading">
			<div class="panel-heading-btn">
				<a id="schedule-post" href="#modal-schedule-post" data-toggle="modal" class="btn btn-xs btn-success ellips" style="margin-top: -1px;"><i class="fa fa-plus"></i>Schedule Post</a>				
            </div>
            <h4 class="panel-title">Social Calendar</h4>
        </div>
        <div id="alert-success-post" class="alert alert-success fade in hide flash">
            <strong>Success!</strong>
            <span id="msg"></span>
            <span class="close" data-dismiss="alert">×</span>
        </div>
        <div class="panel-body">
            <div id="calendar" class="vertical-box-column p-15 calendar"></div>
        </div>
    </div>
    <!-- end panel -->

</div>

<div class="modal fade" id="modal-view" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Post Details</h4>
            </div>
            <div class="modal-body p-20">
                <p id="post-details"></p>
            </div>
            <div class="modal-footer">
                <a href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="#" id="modal-save" class="btn btn-sm btn-success">Save</a>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modal-schedule-post" data-backdrop="static" data-keyboard="false" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Post Details</h4>
			</div>
			<div class="panel" style="margin-bottom:0;">
				<div class="modal-body panel-body p-20">
					<form id="form-schedule-post" method="post" data-parsley-validate="true" data-form-action="add">
						
						<label class="control-label">Date</label>

						<div class="form-group">
							<div class="input-group">
								<input id="post-date" name="post-date" type="text" class="date form-control" data-parsley-required="true"/>
								<span class="input-group-addon">
									<span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
						</div>

                        <label class="control-label">Where to post</label>

						<div class="form-group">
							<div class="input-group" style="text-align: center !important; display: block;">

                                <div class="pretty p-icon p-smooth p-toggle p-bigger">
                                    <input type="checkbox" name="post_where[]" value="facebook" data-parsley-mincheck="1"/>
                                    <div class="state p-off p-danger">
                                        <i class="icon fa fa-facebook-square "></i>
                                        <label>Facebook</label>
                                    </div>
                                    <div class="state p-on p-success-o">
                                        <i class="icon fa fa-facebook-square"></i>
                                        <label>Facebook</label>
                                    </div>
                                </div>

                                <div class="pretty p-icon p-smooth p-toggle p-bigger">
                                    <input type="checkbox"  name="post_where[]" value="twitter"/>
                                    <div class="state p-off p-danger">
                                        <i class="icon fa fa-twitter"></i>
                                        <label>Twitter</label>
                                    </div>
                                    <div class="state p-on p-success-o">
                                        <i class="icon fa fa-twitter"></i>
                                        <label>Twitter</label>
                                    </div>
                                </div>

                                <div class="pretty p-icon p-smooth p-toggle p-bigger">
                                    <input type="checkbox"  name="post_where[]" data-parsley-required="true" value="linkedin"/>
                                    <div class="state p-off p-danger">
                                        <i class="icon fa fa-linkedin "></i>
                                        <label>LinkedIn</label>
                                    </div>
                                    <div class="state p-on p-success-o">
                                        <i class="icon fa fa-linkedin"></i>
                                        <label>LinkedIn</label>
                                    </div>
                                </div>
							</div>
						</div>

						<label class="control-label hide subject">Subject</label>
						<div class="form-group">
							<input id="subject" class="form-control hide subject" type="text" name="subject"><p class="text-right hide subject">*only used for LinkedIn</p>
						</div>

						<label class="control-label">Body</label>
						<div class="form-group">
							<div style="width:100%;" class="input-group">
								<textarea rows="7" id="body" name="body" class="form-control" data-parsley-required="true"></textarea>
							</div>
						</div>

					</form>
				</div>
			</div>
			<div class="modal-footer">
				<a id="close-add-modal" href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="modal-save" class="btn btn-sm btn-success"><i class="fa fa-save"></i>Schedule Post</a>
			</div>
		</div>
	</div>
</div>


{include file="includes/footer.tpl" footer_js="includes/footers/social_calendar.tpl" company_settings_keyval="1"}


