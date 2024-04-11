<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/includes/payment.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

require_once($_SERVER['SITE_DIR'].'/vendor/autoload.php');


if ($_SESSION['company']['is_stripe_test']) {
	$stripe_ini = parse_ini_file($_SERVER['SITE_DIR']."/etc/stripe_test.ini",true);	
} else {
	$stripe_ini = parse_ini_file($_SERVER['SITE_DIR']."/etc/stripe.ini",true);	
	
}
\Stripe\Stripe::setApiKey($stripe_ini['pubkey']);

$smarty->assign('publishable_key', $stripe_ini['pubkey']);
$smarty->assign('company_name', $_SESSION['company']['company_name']);
$smarty->assign('company_created', $_SESSION['company']['date_created']);
$smarty->assign('company_last_charge', $due_date);
$smarty->assign('company_due_date', $next_due_date);
$smarty->assign('is_paid', $_SESSION['company']['is_billing_current']);
$smarty->assign('monthly_fee', $monthly_fee);
$smarty->assign('per_user', $per_user);
$smarty->assign('company_new_users', array_slice($company_new_users, 3));
$smarty->assign('new_user_total', $new_users_total);
$smarty->assign('total_amount', calculate_total_amount($monthly_fee, $per_user, $new_users_total));
$smarty->assign('payment_history', get_company_charge_history());

$smarty->display("billing.tpl");

?>