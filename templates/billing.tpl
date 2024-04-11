<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<head>
    <meta charset="utf-8" />
    <title>Zug Marketing | Billing</title>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
    <meta content="" name="description" />
    <meta content="" name="author" />
    
    <!-- ================== BEGIN BASE CSS STYLE ================== -->
    <link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet">
    <link href="assets/plugins/jquery-ui/themes/base/minified/jquery-ui.min.css" rel="stylesheet" />
    <link href="assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
    <link href="assets/css/animate.min.css" rel="stylesheet" />
    <link href="assets/css/style.min.css" rel="stylesheet" />
    <link href="assets/css/style-responsive.min.css" rel="stylesheet" />
    <link href="assets/css/invoice-print.min.css" rel="stylesheet" />
    <link href="assets/css/theme/default.css" rel="stylesheet" id="theme" />
    <!-- ================== END BASE CSS STYLE ================== -->

    <style type="text/css">
        .login { top: 30%; }
        @media print {
            body, 
            .login {
                top: 0 !important;
                margin: 0 !important;
            }
        }
    </style>
</head>
<body>

    <div id="page-container" class="fade in">
        <!-- begin login -->
        <div class="login bg-black animated fadeInDown">
            <!-- begin brand -->
            <div class="login-header hidden-print">
                <div class="brand text-center">
                    {if !$is_paid}
                    Contract Expired
                    <small>This is to notify you that, You have an unpaid balance.</small>
                    {else}
                    Welcome to Zugent!
                    <small>Your account is up to date.</small>
                    {/if}
                </div>
            </div>
            <!-- end brand -->

            <!-- begin table-panel -->
            <div class="container">
                <p></p>
                <div class="text-center hidden-print">
                    {if !$is_paid}
                    <a href="/services/logout.php" class="btn btn-success">Go Back to Home Page</a>
                    {else}
                    <a href="/dashboard.php" class="btn btn-success">Continue to Dashboard</a>
                    {/if}
                </div>
                <p></p>
                <div class="panel panel-inverse hidden-print" data-sortable-id="new-contacts">
                    <div class="panel-heading">
                        <div class="panel-heading-btn">Date Created: {$company_created|date_format:'%B %d, %Y'}</div>
                        <h4 class="panel-title">Billing History</h4>
                    </div>
                    <div class="panel-body">
                        <table id="file-types" class="table table-condensed">
                            {if $payment_history}
                            <thead>
                                <tr>
                                    <th>Stripe Charge</th>
                                    <th>Amount</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$payment_history item=row }
                                <tr>
                                    <td>{$row.stripe_charge}</td> 
                                    <td>${$row.amount}</td>
                                    <td>{$row.date_charge|date_format}</a></td>
                                </tr>
                                {/foreach}
                            </tbody>
                            {else}
                                <p class="text-center">No Payment History Found.</p>
                            {/if}
                        </table>
                    </div>
                </div>

                {if !$is_paid}
                <div class="invoice">
                    <div class="invoice-company">
                        <span class="pull-right hidden-print">
                            <a href="javascript:;" onclick="window.print()" class="btn btn-sm btn-success"><i class="fa fa-print m-r-5"></i> Print</a>
                            <form action="/billing_purchase.php" method="POST" class="margin-bottom-0 hidden-print text-center" style="display: inline-block;">
                                <script src="https://checkout.stripe.com/checkout.js" class="stripe-button" 
                                    data-key="{$publishable_key}" 
                                    data-name="crm.ruopen.com" 
                                    data-description="Monthly Fee" 
                                    data-amount="{$total_amount}" 
                                    data-locale="auto">
                                </script>
                            </form>
                        </span>
                        {$company_name}
                    </div>
                    <div class="invoice-header">
                        <div class="invoice-from">
                            <small>from</small>
                            <address class="m-t-5 m-b-5">
                                <strong>{$company_last_charge|date_format:'%B %d, %Y'}</strong>
                            </address>
                        </div>
                        <div class="invoice-to">
                            <small>to</small>
                            <address class="m-t-5 m-b-5">
                                <strong>{$company_due_date|date_format:'%B %d, %Y'}</strong>
                            </address>
                        </div>
                        <div class="invoice-date">
                            <small>Billing Information / {$company_last_charge|date_format:'%B'} period</small>
                            <div class="date m-t-5">{$smarty.now|date_format:'%B %d, %Y'}</div>
                            <div class="invoice-detail">
                                Date Today
                            </div>
                        </div>
                    </div>
                    <div class="invoice-content">
                        <div class="table-responsive">
                            <table class="table table-invoice">
                                <thead>
                                    <tr>
                                        <th>USER ACCOUNTS</th>
                                        <th class="text-center">DATE CREATED</th>
                                        <th class="text-center">DATE DEACTIVATED</th>
                                        <th class="text-right">AMOUNT</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {if $company_new_users}
                                        {foreach from=$company_new_users item=$row}
                                        <tr>
                                            <td>
                                                {$row.first_name} {$row.last_name}<br>
                                                <small>{$row.email}</small>
                                            </td>
                                            <td class="text-center">{$row.date_created|date_format:'%B %d, %Y'}</td>
                                            <td class="text-center">
                                                {if $row.date_deactivated != "0000-00-00 00:00:00"}
                                                    {$row.date_deactivated|date_format:'%B %d, %Y'}
                                                {else}
                                                   N/A
                                                {/if}
                                            </td>
                                            <td class="text-right">${$per_user|string_format:"%.2f"}</td>
                                        </tr>
                                        {/foreach}
                                    {else}
                                        <td colspan="4" class="text-center">No Additional Users</td>
                                    {/if}
                                </tbody>
                            </table>
                        </div>
                        <div class="invoice-price">
                            <div class="invoice-price-left">
                                <div class="invoice-price-row">
                                    <div class="sub-price">
                                        <small>USER ACCOUNTS</small>
                                        ${$new_user_total * $per_user}
                                    </div>
                                    <div class="sub-price">
                                        <i class="fa fa-plus"></i>
                                    </div>
                                    <div class="sub-price">
                                        <small>MONTHLY FEE</small>
                                        ${$monthly_fee|string_format:"%.2f"}
                                    </div>
                                </div>
                            </div>
                            <div class="invoice-price-right">
                                <small>TOTAL AMOUNT DUE</small> ${($total_amount / 100)|string_format:"%.2f"}
                            </div>
                        </div>
                    </div>
                    <div class="invoice-note">
                        * If you have any questions concerning this invoice, contact  [Name, Phone Number, Email]
                    </div>
                    <div class="invoice-footer text-muted">
                        <p class="text-center m-b-5">
                            Thank you for keeping your account current. We value your continued patronage.
                        </p>
                        <p class="text-center">
                            <span class="m-r-10"><i class="fa fa-globe"></i> crm.ruopen.com</span>
                            <span class="m-r-10"><i class="fa fa-phone"></i> T: (425) 333-8984</span>
                            <span class="m-r-10"><i class="fa fa-envelope"></i> billing@ruopen.com</span>
                        </p>
                    </div>
                </div>
                {/if}
                <p></p>
            </div>
            <!-- end table-panel -->

        </div>
        <!-- end login -->
    </div>

    <!-- ================== BEGIN BASE JS ================== -->
    <script src="assets/plugins/jquery/jquery-1.9.1.min.js"></script>
    <script src="assets/plugins/jquery-ui/ui/minified/jquery-ui.min.js"></script>
    <script src="assets/plugins/bootstrap/js/bootstrap.min.js"></script>
    <!--[if lt IE 9]>
        <script src="assets/crossbrowserjs/html5shiv.js"></script>
        <script src="assets/crossbrowserjs/respond.min.js"></script>
        <script src="assets/crossbrowserjs/excanvas.min.js"></script>
    <![endif]-->
    <script src="assets/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <script src="assets/plugins/jquery-cookie/jquery.cookie.js"></script>
    <!-- ================== END BASE JS ================== -->
    
    <!-- ================== BEGIN PAGE LEVEL JS ================== -->
    <script src="assets/js/apps.js"></script>
    <!-- ================== END PAGE LEVEL JS ================== -->
    
    <script>
        $(document).ready(function() {
            App.init();
        });
    </script>
</body>
</html>