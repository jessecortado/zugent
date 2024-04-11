<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR'].'/vendor/autoload.php');


if ($_SESSION['company']['is_stripe_test']) {
	$stripe_ini = parse_ini_file($_SERVER['SITE_DIR']."/etc/stripe_test.ini",true);	
} else {
	$stripe_ini = parse_ini_file($_SERVER['SITE_DIR']."/etc/stripe.ini",true);	
	
}
\Stripe\Stripe::setApiKey($stripe_ini['seckey']);
$token = $_POST['stripeToken'];


if ($_SESSION['company']['date_last_charge'] == '' && $token != '') { //prevent saving if toekn is empty & resubmitting form on page reload check if account if renewed
	//print "<pre>";
	//print_r($_SESSION);

	SQL_QUERY("update companies set date_last_charge=NOW(), stripe_token='".SQL_CLEAN($token)."', is_billing_current = 1 where company_id='".SQL_CLEAN($_SESSION['company']['company_id'])."' limit 1");

	if ($_SESSION['company']['stripe_customer'] == '') {
		$customer = \Stripe\Customer::create(array('email' => $_SESSION['user']['email'],'source' => $token));
	//	print "CUS: ".$customer->id."\n";
		SQL_QUERY("update companies set stripe_customer='".SQL_CLEAN($customer->id)."' where company_id='".SQL_CLEAN($_SESSION['company']['company_id'])."' limit 1");
		$_SESSION['company']['stripe_customer'] = $customer->id;
	}

	$charge = \Stripe\Charge::create(array('customer' => $_SESSION['company']['stripe_customer'], 'amount' => 14900, 'currency' => 'usd'));

	//print_r($charge);

	SQL_QUERY("insert into company_charge_history (company_id, stripe_charge, date_charge, amount) values ('".SQL_CLEAN($_SESSION['company']['company_id'])."','".SQL_CLEAN($charge->id)."', NOW(), '".SQL_CLEAN($charge->amount / 100)."')");
	//print "TOK: ".$token."\n";

	$_SESSION['company']['date_last_charge'] = date("Y-m-d H:i:s"); // for authentication and prevent resubmitting form on page reload
	$_SESSION['contract_expired'] = 0; // for authentication and prevent resubmitting form on page reload
	$_SESSION['company']['is_billing_current'] = 1; //update session of is_billing_current

	$smarty->display("register_purchase.tpl");

}
elseif ($_SESSION['company']['date_last_charge'] == '' && $token == '') {
	//if account is not paid & token is empty redirect to register_plan page
	header("location: /register_plan.php");
}
else {
	//if account is already paid redirect to dashboard page
	header("location: /dashboard.php");
}

?>