{include file="includes/header.tpl" active_page="calendar"}


<link href="assets/plugins/fullcalendar/fullcalendar.print.css" rel="stylesheet" media='print' />
<link href="assets/plugins/fullcalendar/fullcalendar.min.css" rel="stylesheet" />
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
<link href="assets/plugins/bootstrap-eonasdan-datetimepicker/build/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />

<style type="text/css">
	.calendar a {
	    color: #fff;
	}
	small.fc-title {
		display: block;
	}
	td.fc-more-cell div {
		background-color: #2a72b5;
		margin: 1px 2px;
    	padding: 3px;
	}
	td.fc-more-cell div a {
		display: block;
	}
</style>

<!-- begin #content -->
<div id="content" class="content">

    <!-- begin panel -->
    <div class="panel panel-inverse" data-sortable-id="new-contacts">
        <div class="panel-heading">
			<div class="panel-heading-btn">
				<a id="add-appointment" href="#modal-add-appointment" data-toggle="modal" class="btn btn-xs btn-success ellips" style="margin-top: -1px;"><i class="fa fa-plus"></i>Schedule Follow-Up / Contact</a>				
            </div>
            <h4 class="panel-title">Calendar</h4>
        </div>
        <div id="alert_success_appointment" class="alert alert-success fade in hide flash">
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
                <h4 class="modal-title">Follow-Up / Contacts Details</h4>
            </div>
            <div class="modal-body p-20">
                <p id="appointment-details"></p>
            </div>
            <div class="modal-footer">
                <a href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="#" id="modal-save" class="btn btn-sm btn-success">Save</a>
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="modal-add-appointment" data-backdrop="static" data-keyboard="false" style="display: none;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Schedule Follow-Up / Contact</h4>
			</div>
			<div class="panel" style="margin-bottom:0;">
				<div class="modal-body panel-body p-20">
					<form id="form-add-appointment" method="post" data-parsley-validate="true" data-form-action="add">
						<label class="control-label">Date</label>

						<div class="form-group">
							<div class="input-group">
								<input id="appointment-date" type="text" class="date form-control" data-parsley-required="true"/>
								<span class="input-group-addon">
									<span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
						</div>

						<label class="control-label">Contact</label>
						<div class="form-group">
							<div style="width:100%;" class="input-group">
								<select id="contact-select" name="contact_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#contact-select-errors">
                            		<option value="">Select Appointment Icon</option>
									{foreach from=$contacts item='row'}
									<option value="{$row.contact_id}">{$row.first_name} {$row.last_name}</option>
									{/foreach}
								</select>
							</div>
							<div id="contact-select-errors"></div>
						</div>

						<label class="control-label">Follow-Up / Contact Type</label>
						<div class="form-group">
							<div style="width:100%;" class="input-group">
								<select id="appointment-type" name="appointment_type_id" class="form-control" data-parsley-required="true" data-parsley-errors-container="#appointment-type-errors">
									{foreach from=$appointment_types item='row'}
									<option value="{$row.appointment_type_id}">{$row.appointment_type}</option>
									{/foreach}
								</select>
							</div>
							<div id="appointment-type-errors"></div>
						</div>

						<label class="control-label">Description</label>
						<div class="form-group">
							<div style="width:100%;" class="input-group">
								<textarea id="description" name="description" class="form-control" data-parsley-required="true"></textarea>
							</div>
						</div>

						<input type="hidden" id="appointment-type-name" name="appointment_type" value=""/>
						<input type="hidden" name="date_appointment" id="selected-appointment-date" />
						<input type="hidden" id="contact-appointment-id" name="contact_appointment_id" value=""/>
					</form>
				</div>
			</div>
			<div class="modal-footer">
				<a id="close-add-modal" href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="modal-save" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
			</div>
		</div>
	</div>
</div>


{include file="includes/footer.tpl" footer_js="includes/footers/calendar.tpl" company_settings_keyval="1"}


