{include file="includes/header.tpl"}

<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />

<!-- begin #content -->
<div id="content" class="content">

    <div class="pull-right">
        <a href="#modal-new-transaction" class="btn btn-sm btn-info m-b-5" data-toggle="modal"><i class="fa fa-plus"></i> New Transactions</a>
    </div>

    <!-- start breadcrumb -->
    <h1 class="page-header">{$company.company_name} 
        <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
            <li><a href="/transactions.php">Transactions</a></li>
            <li class="active">View All</li>
        </ol>
    </h1>
    <!-- end breadcrumb -->

    <!-- begin panel -->
    <div class="panel panel-inverse" data-sortable-id="new-contacts">
        <div class="panel-heading">
            <h4 class="panel-title">Transactions</h4>
        </div>
        <div class="panel-body">
            <table id="transactionTbl" class="table table-striped">
                <thead>
                    <tr>
                        <th width="70%">Name</th>
                        <!-- <th>Status</th>
                        <th>Type</th> -->
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                {foreach item=row from=$transactions}
                    <tr>
                        <td width="65%">
                            {$row.first_name} {$row.last_name}
                        </td>
                        <td>
                            <a href="transactions.php?id={$row.user_id}" class="btn btn-xs btn-info m-r-5 m-b-5 btn-edit"><i class="glyphicon glyphicon-eye-open"></i>View</a>
                        </td>
                    </tr>
                    {foreachelse}
                    <tr class="no-data"><td class="text-center" colspan="2">No Transactions Available</td></tr>
                {/foreach}
                </tbody>
            </table>
        </div>
    </div>
    <!-- end panel -->
</div>
<!-- end #content -->


{include file="includes/footer.tpl" company_settings_keyval="1"}