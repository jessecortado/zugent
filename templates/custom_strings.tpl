{include file="includes/header.tpl"}

<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">

<!-- begin #content -->
<div id="content" class="content">
    <div class="pull-right btn-group" role="group" aria-label="...">
        <a href="/settings.php" class="btn btn-sm btn-danger m-b-5"><i class="fa fa-arrow-left"></i> Back to Settings</a>
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$company.company_name} 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="/settings.php">Settings</a></li>
            <li class="active">Custom Strings</li>
        </ol>
    </h1>
    <!-- end breadcrumb -->

    <div id="alert_error" class="alert alert-danger fade in m-b-15 hide">
        <strong>Permission Denied!</strong>
        You don't have permission to access the requested process.
        <span class="close" data-dismiss="alert">×</span>
    </div>

    <!-- begin file type form -->
    <div class="panel panel-inverse">
        <div class="panel-heading">
            <h4 class="panel-title">Add Custom String</h4>
        </div>
        <div class="panel-body">
            <form id="add-custom-string" data-parsley-validate="true">
                <div class="form-group col-sm-12 col-md-5">
                    <input id="var-key" data-parsley-pattern="^[a-zA-Z]+$" data-parsley-pattern-message="Please only use letters" data-parsley-required="true" type="text" class="form-control" placeholder="Enter Key">
                </div>
                <div class="form-group col-sm-12 col-md-5">
                    <input id="var-val" type="text" data-parsley-required="true" class="form-control" placeholder="Enter Value">
                </div>
                <div class="form-group-btn col-sm-12 col-md-2">
                    <button type="submit" class="btn btn-success ellips"><i class="glyphicon glyphicon-plus"></i> Add Custom String</button>
                </div>
            </form>
        </div>
    </div>
    <!-- end file type form -->

    <div class="panel panel-inverse" data-sortable-id="new-contacts">
        <div class="panel-heading">
            <h4 class="panel-title">Custom Strings</h4>
        </div>
        <div id="alert_success" class="alert alert-success fade in hide flash">
            <strong>Success!</strong>
            <span id="msg"></span>
            <span class="close" data-dismiss="alert">×</span>
        </div>
        <div class="panel-body">
            <div class="table-responsive">
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
                            <td><a href="#custom-strings" class="editable-company-var-key" data-type="text" data-var-id="{$row.company_variable_id}" data-pk="var_key" data-value="{$row.var_key}" data-name="{$row.var_key}">{$row.var_key}</a></td>
                            <td><a href="#custom-strings" class="editable-company-var-val" data-type="text" data-var-id="{$row.company_variable_id}" data-pk="var_val" data-value="{$row.var_val}">{$row.var_val}</a></td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- end panel -->
</div>
<!-- end #content -->

{include file="includes/footer.tpl" company_settings_keyval="1"}