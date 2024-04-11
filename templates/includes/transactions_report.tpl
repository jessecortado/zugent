{include file="includes/header.tpl" active_page="reports"}

<link rel="stylesheet" type="text/css" href="assets/plugins/DataTables/datatables.min.css"/>
<!-- <link href="assets/plugins/DataTables/extensions/Responsive/css/responsive.bootstrap.min.css" rel="stylesheet" /> -->
<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />
<link href="assets/plugins/dropzone/min/dropzone.min.css" rel="stylesheet" />

<style>
    tfoot {
        display: table-header-group;
    }
</style>
<!-- begin #content -->
<div id="content" class="content">
    <div class="pull-right btn-group" role="group" aria-label="...">
        <!-- <a href="/settings.php" class="btn btn-sm btn-danger m-b-5">Back to Settings</a> -->
    </div>
	<!-- begin breadcrumb -->
	<!-- <ol class="breadcrumb pull-right">
		<li>Settings</li>
		<li class="active">Company</li>
	</ol> -->

	<!-- begin page-header -->
	<h1 class="page-header">Transactions Report<a href="/settings.php"><small></small></a></h1>
	<!-- end page-header -->
    
    <!-- begin row -->
    <div class="row">
        <div class="col-md-3 col-sm-6">
            <div class="widget widget-stats bg-green">
                <div class="stats-icon stats-icon-lg"><i class="fa fa-globe fa-fw"></i></div>
                <div class="stats-title">RERFERRALS GENERATED (30 days)</div>
                <div class="stats-number">{$referrals_generated}</div>
            </div>
        </div>
        <div class="col-md-3 col-sm-6">
            <div class="widget widget-stats bg-blue">
                <div class="stats-icon stats-icon-lg"><i class="fa fa-tags fa-fw"></i></div>
                <div class="stats-title">REFERRALS COMPLETED (30 days)</div>
                <div class="stats-number">{$referrals_completed}</div>
            </div>
        </div>
        <div class="col-md-3 col-sm-6">
            <div class="widget widget-stats bg-black">
                <div class="stats-icon stats-icon-lg"><i class="fa fa-comments fa-fw"></i></div>
                <div class="stats-title">REFERRALS DEACTIVE (30 days)</div>
                <div class="stats-number">{$referrals_deactive}</div>
            </div>
        </div>
        <div class="col-md-3 col-sm-6">
            <div class="widget widget-stats bg-black">
                <div class="stats-icon stats-icon-lg"><i class="fa fa-comments fa-fw"></i></div>
                <div class="stats-title">TOTAL REFERRALS</div>
                <div class="stats-number">{$total_referrals}</div>
            </div>
        </div>

        <!-- <div class="col-md-12 text-center">*Stats from the last 30 days</div> -->

    </div>
    <!-- end row -->
    {* 
    <div class="well">
        <div class="text-left">
            You can sort according to each column by clicking on the arrows beside each table header.<br>
            You can filter by using the search on the upper right of the table or by selecting one of the options on the table's footer.
        </div>
    </div>
    *}

        <div id="panel-transactions" class="panel panel-inverse" data-sortable-id="new-contacts">
    <div class="panel-heading">
        <h4 class="panel-title">Referrals</h4>
    </div>
    <div class="panel-body">
        <fieldset>

            <div class="row">
                <div class="col-md-12">
                    <table class="table datatable" id="transactionsTbl" name="transactionsTbl">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Contact</th>
                                <th>User</th>
                                <th>Referral Source</th>
                                <th>Referral Date</th>
                                <th>Status</th>
                                <th>Date Completed</th>
                                <th>Is Counted</th>
                                {*
                                {if $user.is_admin eq '1'}
                                <th>Actions</th>
                                {/if}
                                *}
                            </tr>
                        </thead><tbody>
                        {foreach from=$contact_referrals item='row'}
                        <tr> 
                            <td>
                                {$row.contact_id}
                            </td>
                            <td>
                                <a href="/contacts_edit.php?id={$row.contact_id}">
                                    {$row.contact_name}
                                </a>
                            </td>
                            <td>
                                {$row.user_full_name}
                            </td>
                            <td>
                                {$row.referral_source}
                            </td>
                            <td>
                                {$row.date_referral|date_format:"%A, %B %e, %Y"}
                            </td>
                            <td>
                                {$row.status}
                            </td>
                            <td>
                                {$row.date_complete|date_format:"%A, %B %e, %Y %I:%M:%S %p"}
                            </td>
                            <td>
                                {if $row.is_counted eq '1'}
                                Counted
                                {else}
                                Not Counted
                                {/if}
                            </td>
                            {*
                            {if $user.is_admin eq '1'}
                            <td>
                                <!-- <a href="javascript:;" class="btn btn-xs btn-info m-r-5 m-b-5 edit-appointment" data-appointment-id="{$row.contact_appointment_id}" data-appointment-type="{$row.appointment_type_id}" data-appointment-date="{$row.date_appointment}" data-description="{$row.description}"><i class="glyphicon glyphicon-edit"></i>Edit</a> -->
                                {if $row.is_active eq '1'}
                                <a href="javascript:;" class="btn btn-xs btn-info m-r-5 m-b-5 mark-transaction-complete" data-transaction-id="{$row.contact_referral_id}"><i class="glyphicon glyphicon-check"></i>Mark as Complete</a>

                                <a href="javascript:;" class="btn btn-xs btn-info m-r-5 m-b-5 mark-transaction-dead" data-transaction-id="{$row.contact_referral_id}"><i class="glyphicon glyphicon-remove"></i>Mark as Dead</a>

                                <a href="#modal-edit-transaction" class="btn btn-xs btn-info m-r-5 m-b-5 btn-edit-transaction" data-transaction-id="{$row.contact_referral_id}" data-user-id="{$row.user_id}" data-source="{$row.referral_source}" data-bob="{$row.referral_bob}" data-toggle="modal"><i class="glyphicon glyphicon-edit"></i>Edit</a>
                                {/if}

                                <!-- <a href="javascript:;" class="btn btn-xs btn-danger m-r-5 m-b-5 btn-cancel-appointment" data-appointment-id="{$row.contact_appointment_id}"><i class="glyphicon glyphicon-remove"></i>Cancel</a> -->
                            </td>
                            {/if}
                            *}
                        </tr>
                        {foreachelse}
                        {/foreach}
                    </tbody>
                    <tfoot style="display: table-header-group;">
                        <tr>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                        </tr>
                    </tfoot>
                </table>
            </div>

        </div>

    </fieldset>

</div>
</div>
<!-- end panel -->

</div>


<!-- <script src="assets/plugins/DataTables/media/js/jquery.dataTables.js" defer></script> -->
<!-- <script src="assets/plugins/DataTables/media/js/dataTables.bootstrap.min.js" defer></script> -->
<!-- <script src="https://cdn.datatables.net/buttons/1.4.0/js/dataTables.buttons.min.js" async defer></script>
<script src="https://cdn.datatables.net/buttons/1.4.0/js/buttons.print.min.js" async defer></script> -->


{include file="includes/footer.tpl" footer_js="includes/footers/transaction_report.tpl" company_settings_keyval="1"}


