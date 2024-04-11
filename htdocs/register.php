<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

header("location: /"); // REDIRECT THIS PAGE TO DASHBOARD TEMPORARILY

if (isset($_POST) && !empty($_POST)) {

	$company_id = "";

	// removed 8-7-2017 2:55 pm
	// $sth = SQL_QUERY("select * from companies where company_name ='".SQL_CLEAN($_POST['company_name'])."'");

	// if (SQL_NUM_ROWS($sth) != 0) {
	// 	$temp = SQL_ASSOC_ARRAY($sth);
	// 	$company_id = $temp['company_id'];
	// 	$_SESSION['company'] = $temp;
	// }
	// else {

	$sth = SQL_QUERY("select * from users where email='".SQL_CLEAN($_POST['email'])."'");
	if (SQL_NUM_ROWS($sth) != 0) {
		$smarty->assign("email_exists", "true");
		$smarty->display("register.tpl");
		exit;
	}

	SQL_QUERY("insert into companies (date_created,timezone,company_name,is_active,email_footer_line_1,email_footer_line_2) values (NOW(),'America/Los_Angeles','".SQL_CLEAN($_POST['company_name'])."',1,'2017',' ')");
	$company_id = SQL_INSERT_ID();

	// }

	$sth = SQL_QUERY("insert into users (date_created,is_superadmin,is_admin,first_name,last_name,email,password,is_active,company_id) values (NOW(),1,1,'".SQL_CLEAN($_POST['first_name'])."','".SQL_CLEAN($_POST['last_name'])."','".SQL_CLEAN($_POST['email'])."','".password_hash(SQL_CLEAN($_POST['password']),PASSWORD_DEFAULT)."',1,".$company_id.")");

	$id = SQL_INSERT_ID();

	$sth = SQL_QUERY("insert into appointment_types (company_id, is_active, appointment_type, appointment_icon) VALUES (".$company_id.",1, 'Face to Face', 'fa-user')");
	$sth = SQL_QUERY("insert into appointment_types (company_id, is_active, appointment_type, appointment_icon) VALUES (".$company_id.",1, 'Phone', 'fa-phone')");

	// Add default contact referral statuses for a company
	$contact_referral_status = array('Active','Pending','Listed','Closed','Dead');

	foreach ($contact_referral_status as $key => $value) {
		$sth = SQL_QUERY("insert into contact_referral_status (company_id, name) VALUES (".$company_id.",'".$value."')");
	}

	// Load user & company data for arrays
	$sth = SQL_QUERY("select * from users where user_id='".$id."' limit 1");
	$user_data = SQL_ASSOC_ARRAY($sth);

	$sth = SQL_QUERY("select * from companies where company_id='".$company_id."' limit 1");
	$company_data = SQL_ASSOC_ARRAY($sth);
	
	// Registration Done
	// die(var_dump($company_data));
	$_SESSION['user_id'] = $id;
	$_SESSION['company'] = $company_data;
	$_SESSION['user'] = $user_data;

	$smarty->assign('user', $user_data);
	$smarty->assign('company', $company_data);

	header("location: /register_plan.php");
}

$smarty->display("register.tpl");
	
?>