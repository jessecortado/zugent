<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");

if(isset($_GET['code'])) {
	if($_GET['code'] == '1x092' || $_GET['code'] == '1x093') {
		$smarty->assign("display_message", TRUE);
	}
}

// Check if cookie is set
if (isset($_COOKIE['RS5B8XNrwmgHy4VR'])) {
	// Decrypt cookie variable value
	$userid = decryptCookie($_COOKIE['RS5B8XNrwmgHy4VR']);

	// Check $user_id from cookie if exists in database
	$sth1 = SQL_QUERY("select * from users where user_id=".$userid." and is_active=1 limit 1");
	if (SQL_NUM_ROWS($sth1) == 0) {
		header("location: /login.php?code=1x092");
		exit;
	}
	$data = SQL_ASSOC_ARRAY($sth1);

	$sth2 = SQL_QUERY("
		SELECT
		        *
		        ,CASE
		                WHEN is_free=1 AND date_free_ends < now() THEN 1
		                ELSE 0
		        END AS is_free_expired
		FROM companies
		WHERE company_id='".SQL_CLEAN($data['company_id'])."' AND is_active=1
		LIMIT 1
	");
	if (SQL_NUM_ROWS($sth2) == 0) {
		header("location: /login.php?code=1x091");
		exit;
	}
	$company_data = SQL_ASSOC_ARRAY($sth2);

	if( SQL_NUM_ROWS($sth1) > 0 ){
		$_SESSION['user_id'] = $data['user_id'];
		$_SESSION['user'] = $data;
		$_SESSION['company'] = $company_data;

		// The user is NOT labeled as free and their last charge isn't set - so bounce them to 
		// the register_plan page.
		if (!$company_data['is_free'] && $company_data['date_last_charge'] == '') {
			header("location: /register_plan.php");
			exit;
		}

		// redirect to expired.php is_billing_current == 0 or if account is_free and date_now is > date_free_ends 
		if (($company_data['is_free'] && $company_data['is_free_expired']) || !$company_data['is_billing_current']) {
			$_SESSION['contract_expired'] = 1;
			if ($_SESSION['user']['is_superadmin'] || $_SESSION['user']['is_admin']) {
				header("location: /billing.php");
			} else {
				header("location: /expired.php");
			}
			exit;
		}
		
		//redirect to expired.php if free has ended
		if ($company_data['is_billing_current'] || ($company_data['is_free'] && !$company_data['is_free_expired'])) {
			$_SESSION['contract_expired'] = 0;
			if (isset($_GET['from']))
				if (isset($_GET['accept'])) {
					header("location: ".$_GET['from']."&accept=1");
				}
				else {
					header("location: ".$_GET['from']);
				}
			else
				header("location: /dashboard.php");
			exit;
		}
	}
}
else if(!isset($_SESSION['user'])) { 

	// $fb = new Facebook\Facebook([
	//   'app_id' => '215683345613958',
	//   'app_secret' => 'fc3a9c0967861472278470eaeeca1093',
	//   'default_graph_version' => 'v2.2',
	// ]);
	// $helper = $fb->getRedirectLoginHelper();
	// $permissions = ['public_profile','email']; // Optional information that your app can access, such as 'email'
	// $loginUrl = $helper->getLoginUrl('https://www.zugent.com/services/authenticate_fb.php', $permissions);
	// $logoutUrl = $helper->getLogoutUrl();

	// $smarty->assign('loginUrl', $loginUrl);
	// $smarty->assign('logoutUrl', $logoutUrl);

	$smarty->assign('loginUrl', '');
	$smarty->assign('logoutUrl', '');

	if (isset($_GET['from'])) {
		if (isset($_GET['accept'])) {
			$url = $_GET['from']."&accept=1";
		}
		else {
			$url = $_GET['from'];
		}
	}
	
	//$smarty->assign('from', $_GET['from']);
	$smarty->assign('from', $url);

	$smarty->display("login.tpl");

}
else if (isset($_SESSION['user']) && ($_SESSION['date_last_charge'] == '') && $_SESSION['company']['is_free'] == 0) {
	if ($_SESSION['user']['is_superadmin'] || $_SESSION['user']['is_admin']) {
		header("location: /register_plan.php");
	}
	else {
		header("location: /expired.php");
	}
}
else if (isset($_SESSION['user']) && ($_SESSION['contract_expired'] == 1) && $_SESSION['company']['is_free'] == 0) {
	if ($_SESSION['user']['is_superadmin'] || $_SESSION['user']['is_admin']) {
		header("location: /billing.php");
	}
	else {
		header("location: /expired.php");
	}
}
else if (isset($_SESSION['user']) && (($_SESSION['contract_expired'] == 0) && ($_SESSION['company']['date_last_charge'] != '') || $_SESSION['company']['is_free'] == 1)) {
	header("location: /dashboard.php");
}

?>
