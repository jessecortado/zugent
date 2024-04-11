<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

$sth = SQL_QUERY("select * from users where email='".SQL_CLEAN($_REQUEST['email'])."' and is_active=1 limit 1");
if (SQL_NUM_ROWS($sth) == 0) {
	if (isset($_POST['from'])) {
		if (isset($_POST['accept'])) {
			header("location: /login.php?code=1x092&from=".$_POST['from']."&accept=1");
		}
		else {
			header("location: /login.php?code=1x092&from=".$_POST['from']);
		}
	}
	else {
		header("location: /login.php?code=1x092");
	}
	exit;
}
$data = SQL_ASSOC_ARRAY($sth);

$sth = SQL_QUERY("
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
if (SQL_NUM_ROWS($sth) == 0) {
	header("location: /login.php?code=1x091");
	exit;
}
$company_data = SQL_ASSOC_ARRAY($sth);

if (password_verify($_REQUEST['password'], $data['password'])) {
	$_SESSION['user_id'] = $data['user_id'];
	$_SESSION['user'] = $data;
	$_SESSION['company'] = $company_data;

	// Set default timezone
	set_timezone();
                 
    // Add successful login user log
    add_user_log($_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." (".$_SESSION['user_id'].") "." successfully logged in.", "login" );

	//set date user logged in
	user_logged_in($_SESSION['user_id'], $_SESSION['user']['company_id']);

	//if remember me is checked Set cookie
	if(isset($_REQUEST['RS5B8XNrwmgHy4VR']) && $_REQUEST['RS5B8XNrwmgHy4VR'] !== "") {
		$days = 30;
		$cookie_value = encryptCookie($data['user_id']);
		setcookie("RS5B8XNrwmgHy4VR", $cookie_value, time() + (86400 * $days), "/");
	}

	//insert login location
	if(isset($_REQUEST['lat']) && isset($_REQUEST['lon']) && $_REQUEST['lat'] !== "" && $_REQUEST['lon'] !== "") {
		$date = gmdate("Y-m-d H:i:s");

		$sth = SQL_QUERY("
			insert into user_locations set ".
				"latitude='".SQL_CLEAN($_REQUEST['lat']).
				"', longitude='".SQL_CLEAN($_REQUEST['lon']).
				"', date_collected='".$date.
				"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
		"'");
	}

	// The user is NOT labeled as free and their last charge isn't set - so bounce them to 
	// the register_plan page.
	if (!$company_data['is_free'] && $company_data['date_last_charge'] == '') {

		// Add login user log
		add_user_log($_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." (".$_SESSION['user_id'].") "." sent to register plan page.", "login" );

		header("location: /register_plan.php");
		exit;
	}

	// redirect to expired.php is_billing_current == 0 or if account is_free and date_now is > date_free_ends 
	if (($company_data['is_free'] && $company_data['is_free_expired']) || !$company_data['is_billing_current']) {
		$_SESSION['contract_expired'] = 1;
		if ($_SESSION['user']['is_superadmin'] || $_SESSION['user']['is_admin']) {
			
            // Add login user log
			add_user_log($_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." (".$_SESSION['user_id'].") "." sent to billing page.", "login" );
			header("location: /billing.php");

		} else {

			// Add login user log
			add_user_log($_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." (".$_SESSION['user_id'].") "." sent to expired page.", "login" );
		
			header("location: /expired.php");

		}
		exit;
	}

	//redirect to expired.php if free has ended
	if ($company_data['is_billing_current'] || ($company_data['is_free'] && !$company_data['is_free_expired'])) {
		$_SESSION['contract_expired'] = 0;
		if (isset($_POST['from']))
			header("location: ".$_POST['from']);
		else
			header("location: /dashboard.php");
		exit;
	}
} elseif (password_verify($_REQUEST['password'], $data['temporary_password'])) {
	$_SESSION['user_id'] = $data['user_id'];
	$_SESSION['user'] = $data;
	$_SESSION['company'] = $company_data;

	//set date user logged in
	user_logged_in($_SESSION['user_id'], $_SESSION['user']['company_id']);
                 
    // Add login user log
    add_user_log($_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." (".$_SESSION['user_id'].") "." sent to change password page.", "login" );
                 
	header("location: /change_password.php");
}
else {
	// die($_REQUEST['password'] . " and ". password_hash($data['password'], PASSWORD_DEFAULT));
	if (isset($_POST['from'])) {
		if (isset($_POST['accept'])) {
			header("location: /login.php?code=1x093&from=".$_POST['from']."&accept=1");
		}
		else {
			header("location: /login.php?code=1x093&from=".$_POST['from']);
		}
	}
	else {
		header("location: /login.php?code=1x093");
	}
	exit;
}

	
?>