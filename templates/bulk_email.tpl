{include file="includes/header.tpl"}

<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
<link href="assets/plugins/jquery-tag-it/css/jquery.tagit.css" rel="stylesheet" />
<link href="assets/plugins/summernote/summernote.css" rel="stylesheet" />

<style type="text/css">
    .checkbox-css label:before,
    .checkbox-css label:after {
    	margin-left: -5px !important;
        left: 5px !important;
        top: 0 !important;
    }
    .checkbox.checkbox-css:not(:last-child) {
	    margin-bottom: 10px !important;
	}
	.checkbox-with-input {
		margin: 0 -10px;
		padding: 0 10px;
	}
	.checkbox-with-input .checkbox-css,
	.checkbox-with-input input {
		display: inline-block;
	}
	.checkbox-with-input input {
		width: 80%;
    	margin-left: 10px;
	}
    label[for=check_personal_contacts][disabled]  {
        cursor: not-allowed;
    }
    #contact_tags {
    	display: inline-flex;
	    margin-left: 21px;
	    width: 80%;
	    max-width: 600px;
    }
    .tagit.ui-widget {
    	background: none; 
    }
    .checkbox-with-input ul.parsley-errors-list {
    	margin: -2px 0 2px 9.2% !important;
    }
    /*#form-send-bulk-email input {
		max-width: 250px;
    }*/
</style>

<div id="content" class="content">
    <div class="pull-right">
        <a href="/bulk_email_templates.php" class="btn btn-sm btn-success m-b-5" data-toggle="modal"><i class="fa fa-envelope"></i> Email Template List</a>
        <a href="/bulk_email_history.php" class="btn btn-sm btn-success m-b-5" data-toggle="modal"><i class="fa fa-inbox"></i> Sent Email History</a>
    </div>

	<h1 class="page-header">Bulk Email 
		<ol class="breadcrumb" style="display:inline-block;font-size:12px;">
			<li class="active">Send Email</li>
		</ol>
	</h1>

    <div id="alert_error" class="alert alert-danger fade in m-b-15 hide">
        <strong>Permission Denied!</strong>
        You don't have permission to access the requested process.
        <span class="close" data-dismiss="alert">×</span>
    </div>
    
    <div id="alert_success" class="alert alert-success fade in hide flash">
        <strong>Success!</strong>
        <span id="msg"></span>
        <span class="close" data-dismiss="alert">×</span>
    </div>

	<div class="row">

		<div class="col-md-12 col-sm-12">

			<!-- begin panel -->
			<div class="panel panel-inverse" data-sortable-id="new-contacts">
				<div class="panel-heading">
					<h4 class="panel-title">Send Bulk Email</h4>
				</div>
				<div class="panel-body">
					<form id="form-send-bulk-email" method="post" data-parsley-validate="true" data-parsley-excluded="[disabled=disabled]">
						<input type="hidden" name="action_id" value="be7">
						<fieldset>
							<div class="form-group">
								<div class="row">
									<div class="col-md-12 col-sm-12">
										<label class="control-label">Send To:</label>
									</div>
									<div class="col-md-6 col-sm-12">
										<div class="col-md-6 p-0">
		                                	<div class="checkbox checkbox-css checkbox-success m-t-10">
							                    <input id="check_personal_contacts" name="personal_contacts" type="checkbox" checked="true" disabled>
							                    <label for="check_personal_contacts" disabled> All Personal Contacts</label>
							                </div>
							            </div>

										{if $user.is_admin eq 1}
										<div class="col-md-6 p-0">
			                                <div class="checkbox checkbox-css checkbox-success m-t-10">
							                    <input id="check_company_contacts" name="company_contacts" type="checkbox">
							                    <label for="check_company_contacts"> All Company Contacts</label>
							                </div>
							            </div>
						                {/if}

										<div class="checkbox-with-input">
			                                <div class="checkbox checkbox-css checkbox-success" style="margin-top: 18px;">
							                    <input id="check_bucket" type="checkbox">
							                    <label for="check_bucket"> Bucket:</label>
							                </div>
											<input type="text" class="form-control" name="contact_bucket" id="contact_bucket" placeholder="Enter Bucket" data-parsley-required="true" disabled>
										</div>

										<div class="checkbox-with-input">
			                                <div class="checkbox checkbox-css checkbox-success">
							                    <input id="check_tag" type="checkbox">
							                    <label for="check_tag"> Tags:</label>
							                </div>
                        					<ul id="contact_tags" class="primary" data-parsley-required="true"></ul>
										</div>
					                </div>
									<div class="col-md-6 col-sm-12">
										<div class="checkbox-with-input">
			                                <div class="checkbox checkbox-css checkbox-success">
							                    <input id="check_city" type="checkbox">
							                    <label for="check_city"> City:</label>
							                </div>
											<input type="text" class="form-control" style="margin-left: 27px;" name="contact_city" id="contact_city" placeholder="Enter City" data-parsley-required="true" disabled>
										</div>
										<div class="checkbox-with-input">
			                                <div class="checkbox checkbox-css checkbox-success">
							                    <input id="check_county" type="checkbox">
							                    <label for="check_county"> County:</label>
							                </div>
											<input type="text" class="form-control" name="contact_county" id="contact_county" placeholder="Enter County" data-parsley-required="true" disabled>
										</div>
										<div class="checkbox-with-input">
			                                <div class="checkbox checkbox-css checkbox-success">
							                    <input id="check_zip" type="checkbox">
							                    <label for="check_zip"> Zip:</label>
							                </div>
											<input type="text" class="form-control" style="margin-left: 31px;" name="contact_zip" id="contact_zip" placeholder="Enter Zip" data-parsley-required="true" disabled>
										</div>
									</div>
								</div>
							</div>

							<div class="form-group">
								<label for="bucket">Choose a Template: (Required)</label>
								{if $email_templates|count ne 0}
								<select class="form-control" name="email_template" id="email_template" data-parsley-required="true" data-parsley-errors-container="#email_template_error">
									<option value="">Select a Template</option>
									{foreach from=$email_templates item=row}
									<option value="{$row.bulk_template_id}">{$row.name}</option>
									{/foreach}
								</select>
								<div id="email_template_error"></div>
								{else}
									<a href="#modal-new-template" class="btn btn-sm btn-success m-b-5" style="display: block;width: 220px;" data-toggle="modal">
										<i class="fa fa-plus"></i> Add New Template
									</a>
								{/if}
							</div>

							<div class="form-group">
								<label for="mail_subject">Subject:</label>
								<input type="text" class="form-control" name="mail_subject" id="mail_subject" placeholder="Email Subject" data-parsley-required="true" style="opacity: 1;" disabled>
							</div>

							<div class="form-group">
								<label for="mail_body">Message:</label>
                                <div id="summernote_body"></div>
								<textarea name="mail_body" id="mail_body" class="form-control" rows="5" style="display:none;"></textarea>
							</div>

							<div class="form-group">
								<label id="contacts_selected" style="text-align: center;font-size: 14px;">{$total_count|default:'0'} contact/s will receive this email.</label>
							</div>

							<button type="button" class="btn btn-sm btn-primary" id="btn-send-bulk-mail"><i class="fa fa-send"></i> Send Mail</button>
						</fieldset>
					</form>
				</div>
			</div>
			<!-- end panel -->

		</div>

	</div>

</div>


<div class="modal fade" id="modal-new-template" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">New Email Template</h4>
            </div>
            <div class="modal-body p-20">
                <form id="form-new-template" method="post" data-parsley-validate="true">
                    <label class="control-label">Template Name</label>
                    <div class="form-group">
                        <div style="width:100%;" class="input-group">
                            <input type="text" class="form-control" id="template-name" name="template_name" placeholder="Enter template name here" data-parsley-required="true"/>
                        </div>
                    </div>
                    <input type="hidden" id="action" name="action" value="new_email_template"/>
                </form>
            </div>
            <div class="modal-footer">
                <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
                <a href="javascript:void(0)" id="btn-add-new-template" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Save</a>
            </div>
        </div>
    </div>
</div>

{include file="includes/footer.tpl"}