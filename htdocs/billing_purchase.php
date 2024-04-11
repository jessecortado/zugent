<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/includes/payment.php");
require_once($_SERVER['SITE_DIR'].'/vendor/autoload.php');

if ($_SESSION['contract_expired']) { //prevent resubmitting form on page reload check if account if renewed

	if ($_SESSION['company']['is_stripe_test']) {
		$stripe_ini = parse_ini_file($_SERVER['SITE_DIR']."/etc/stripe_test.ini",true);	
	} else {
		$stripe_ini = parse_ini_file($_SERVER['SITE_DIR']."/etc/stripe.ini",true);	
		
	}
	\Stripe\Stripe::setApiKey($stripe_ini['seckey']);
	$token = $_POST['stripeToken'];


	if ($_SESSION['company']['stripe_customer'] == '') {
		$customer = \Stripe\Customer::create(array('email' => $_SESSION['user']['email'],'source' => $token));
		SQL_QUERY("update companies set stripe_customer='".SQL_CLEAN($customer->id)."' where company_id='".SQL_CLEAN($_SESSION['company']['company_id'])."' limit 1");
		$_SESSION['company']['stripe_customer'] = $customer->id;
	}

	$charge = \Stripe\Charge::create(array('customer' => $_SESSION['company']['stripe_customer'], 'amount' => calculate_total_amount($monthly_fee, $per_user, $new_users_total), 'currency' => 'usd'));

	SQL_QUERY("insert into company_charge_history (company_id, stripe_charge, date_charge, amount) values ('".SQL_CLEAN($_SESSION['company']['company_id'])."','".SQL_CLEAN($charge->id)."', NOW(), '".SQL_CLEAN($charge->amount / 100)."')");

	SQL_QUERY("update companies set date_last_charge=NOW(), stripe_token='".SQL_CLEAN($token)."', is_billing_current = 1 where company_id='".SQL_CLEAN($_SESSION['company']['company_id'])."' limit 1");

	$_SESSION['company']['date_last_charge'] = date("Y-m-d H:i:s");
	$_SESSION['contract_expired'] = 0; // for authentication and prevent resubmitting form on page reload
	$_SESSION['company']['is_billing_current'] = 1; //update session of is_billing_current

	$smarty->assign('company_created', $_SESSION['company']['date_created']);
	$smarty->assign('payment_history', get_company_charge_history());
	$smarty->display("billing_purchase.tpl");

}
else {
	//if account is already paid redirect to billing page
	header("location: /billing.php");
}

?>