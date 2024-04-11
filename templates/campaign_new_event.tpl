{include file="includes/header.tpl"}

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
				<li class="active">Campaigns</li>
			</ol>
			<!-- end breadcrumb -->
			<!-- begin page-header -->
			<h1 class="page-header">Campaigns <small><a href="/campaign_edit.php?id={$campaign.campaign_id}">{$campaign.campaign_name}</a></small></h1>
			<!-- end page-header -->


			<!-- begin row -->
			<div class="row">

			    <div class="col-md-12 col-sm-12">

			        <!-- begin panel -->
	                <div class="panel panel-inverse" data-sortable-id="new-contacts">
	                    <div class="panel-heading">
	                        <h4 class="panel-title">New Event</h4>
	                    </div>
	                    <div class="panel-body">
							<form action="/campaign_new_event.php" method="post" data-parsley-validate="true">
								<input type="hidden" name="id" value="{$campaign.campaign_id}"> 
								<input type="hidden" name="action" value="n">
								<fieldset>

                                    <div class="form-group">
                                        <label for="event_subject">Event Name</label>
                                        <input type="text" class="form-control" name="event_name" id="event_name" placeholder="Enter a campaign name" data-parsley-required="true" />
                                    </div>

                                    <div class="form-group">
                                        <label for="event_subject">Event Subject</label>
                                        <input type="text" class="form-control" name="event_subject" id="event_subject" placeholder="Enter a campaign subject" data-parsley-required="true" />
                                    </div>

                                    <div class="form-group">
                                        <label for="event_subject">Days to Delay</label>
                                        <input type="text" class="form-control" name="send_after_days" id="send_after_days" placeholder="0" data-parsley-required="true" />
                                    </div>

                                    <div class="form-group">
                                        <label for="event_subject">Event Body</label>
										<textarea name="event_body" id="event_body" class="form-control" placeholder="Body" rows="5" data-parsley-required="true"></textarea>
                                    </div>


									<div class="form-group">
										<label class="control-label">Send Message to</label>
										<div>
											<!-- <label class="checkbox-inline">
											<input id="is_event_to_user" name="is_event_to_user" type="checkbox" value="1"/>
											RUOPEN User
											</label> -->
											<!-- <label class="checkbox-inline">
											<input id="is_event_to_client" name="is_event_to_client" type="checkbox" value="1"/>
											Client
											</label> -->
											
											<div class="checkbox checkbox-css checkbox-success checkbox-inline">
												<input id="is_event_to_user" type="checkbox" name="is_event_to_user">
												<label for="is_event_to_user" style="padding-left:0;"> RUOPEN User</label>
											</div>
											<div class="checkbox checkbox-css checkbox-success checkbox-inline">
												<input id="is_event_to_client" type="checkbox" name="is_event_to_client">
												<label for="is_event_to_client" style="padding-left:0;"> Client</label>
											</div>
										</div>
									</div>


                                    <div class="checkbox">
                                        <!-- <label><input name="is_event_appointment_triggered" type="checkbox" value="1"/> Follow-Up / Contact Triggered</label> -->
										
										<div class="checkbox checkbox-css checkbox-success">
											<input id="is_event_appointment_triggered" type="checkbox" name="is_event_appointment_triggered">
											<label for="is_event_appointment_triggered" > Follow-Up / Contact Triggered</label>
										</div>
                                    </div>

                                    {*
                                    <div class="form-group">
                                        <label for="event_subject">Follow-Up / Contact Trigger Column</label>
                                        <input type="text" class="form-control" name="appointment_trigger_column" id="appointment_trigger_column" placeholder="Eneter a column we can trigger" />
                                    </div>

                                    <div class="form-group">
                                        <label for="event_subject">Follow-Up / Contact Trigger Type</label>
										<select name="appointment_trigger_type" class="form-control">
                                            <option value="">Select a trigger type</option>
                                            <option value="=">Equals</option>
                                            <option value=">=">Greater or Equal</option>
                                            <option value="<=">Less or Equal</option>
                                            <option value="<">Less</option>
                                            <option value=">">Greater</option>
                                            <option value="!=">Not Equals</option>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="event_subject">Follow-Up / Contact Trigger Value</label>
                                        <input type="text" class="form-control" name="appointment_trigger_value" id="appointment_trigger_value" placeholder="Eneter a column value" />
                                    </div>
									*}
					
                                    <button type="submit" class="btn btn-sm btn-primary m-r-5"><i class="fa fa-save"></i> Save</button>
                                </fieldset>

							</form>

	                    </div>
	                </div>
	                <!-- end panel -->



			    </div>
			</div>
		<!-- end #row -->



		</div>
		<!-- end #content -->
		
{include file="includes/footer.tpl"}