<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

require_once($_SERVER['SITE_DIR'].'/vendor/autoload.php');

if ($_SESSION['company']['date_last_charge'] == '') {
	if ($_SESSION['company']['is_stripe_test']) {
		$stripe_ini = parse_ini_file($_SERVER['SITE_DIR']."/etc/stripe_test.ini",true);
	} else {
		$stripe_ini = parse_ini_file($_SERVER['SITE_DIR']."/etc/stripe.ini",true);
		
	}
	\Stripe\Stripe::setApiKey($stripe_ini['pubkey']);

	$smarty->assign('publishable_key', $stripe_ini['pubkey']);
	$smarty->display("register_plan.tpl");
}
else {
	//if account is already paid redirect to dashboard page
	header("location: /dashboard.php");
}
	
?>