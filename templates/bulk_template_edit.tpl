{include file="includes/header.tpl"}

<link href="assets/plugins/summernote/summernote.css" rel="stylesheet" />

<style type="text/css">
    .checkbox-css label:before,
    .checkbox-css label:after {
        left: 5px !important;
        top: 0 !important;
    }
</style>

<!-- begin #content -->
<div id="content" class="content">
	<div class="pull-right">
    	<a href="/bulk_email_templates.php" class="btn btn-sm btn-info m-b-5"><i class="fa fa-arrow-left"></i> Back to Template List</a>
    </div>

	<!-- start breadcrumb -->
	<h1 class="page-header">Email Templates 
		<ol class="breadcrumb" style="display:inline-block;font-size:12px;">
			<li class="active">Edit Email Template</li>
		</ol>
	</h1>
	<!-- end breadcrumb -->

	<div id="alert_error" class="alert alert-danger fade in m-b-15 hide">
		<strong>Permission Denied!</strong>
		You don't have permission to access the requested process.
		<span class="close" data-dismiss="alert">×</span>
	</div>

	<div class="row">

		<div class="col-md-12 col-sm-12">

			<!-- begin panel -->
			<div class="panel panel-inverse" data-sortable-id="new-contacts">
				<div class="panel-heading">
					<h4 class="panel-title">Edit Email Template</h4>
				</div>
				<div class="panel-body">
					<form id="form-email-template" action="/ws/email/update_template" method="post" data-parsley-validate="true">
        				{foreach from=$bulk_template item="row"}
						<input type="hidden" name="bulk_template_id" value="{$row.bulk_template_id}">
						<fieldset>
							<div class="form-group">
								<label for="template_name">Template Name</label>
								<input type="text" class="form-control" name="template_name" id="template_name" value="{$row.name}" placeholder="Enter template name" data-parsley-required="true">
							</div>

							<div class="form-group">
								<label for="template_subject">Template Subject</label>
								<input type="text" class="form-control" name="template_subject" id="template_subject" value="{$row.subject}" placeholder="Enter template subject" data-parsley-required="true">
							</div>

							<div class="form-group">
								<label class="m-r-10">Email Parameters:</label>
								<a href="javascript:;" class="btn btn-primary btn-xs m-r-5 template-parameters">contact.name</a>
								<a href="javascript:;" class="btn btn-primary btn-xs m-r-5 template-parameters">contact.first_name</a>
								<a href="javascript:;" class="btn btn-primary btn-xs m-r-5 template-parameters">contact.last_name</a>
								<a href="javascript:;" class="btn btn-primary btn-xs m-r-5 template-parameters">from.name</a>
								<a href="javascript:;" class="btn btn-primary btn-xs m-r-5 template-parameters">from.first_name</a>
								<a href="javascript:;" class="btn btn-primary btn-xs m-r-5 template-parameters">from.last_name</a>
								<a href="javascript:;" class="btn btn-primary btn-xs m-r-5 template-parameters">from.email</a>
								<a href="javascript:;" class="btn btn-primary btn-xs m-r-5 template-parameters">company.company_name</a>
								<a href="javascript:;" class="btn btn-primary btn-xs m-r-5 template-parameters">company.website</a>
								<a href="javascript:;" class="btn btn-primary btn-xs m-r-5 template-parameters">company.email_footer_line_1</a>
								<a href="javascript:;" class="btn btn-primary btn-xs m-r-5 template-parameters">company.email_footer_line_2</a>
							</div>

							<div class="form-group">
								<label for="template_body">Template Body</label>
                                <div id="summernote_body">{$row.body|replace:'Â':''}</div>
								<textarea name="template_body" id="template_body" class="form-control" rows="5" style="display:none;">{$row.body|replace:'Â':''}</textarea>
							</div>

							<div class="form-group">
								<label class="control-label">Template Options</label>

                                <div class="checkbox checkbox-css checkbox-success">
				                    <input id="check_shared" type="checkbox" {if $row.is_company_shared eq 1}checked="true"{/if}>
				                    <label for="check_shared"> Company Shared</label>
				                </div>

                                <div class="checkbox checkbox-css checkbox-success">
				                    <input id="check_active" type="checkbox" {if $row.is_active eq 1}checked="true"{/if}>
				                    <label for="check_active"> Active</label>
				                </div>
							</div>

							<input type="hidden" name="template_shared" id="template_shared" value="{$row.is_company_shared}">
							<input type="hidden" name="template_active" id="template_active" value="{$row.is_active}">

							<button type="submit" class="btn btn-sm btn-primary"><i class="fa fa-save"></i> Save</button>
						</fieldset>
						{/foreach}
					</form>
				</div>
			</div>
			<!-- end panel -->

		</div>

	</div>

</div>
<!-- end #content -->

{include file="includes/footer.tpl"}