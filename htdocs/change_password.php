<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

if (isset($_POST['password'])) {
	if ($_POST['password'] == $_POST['password_verify']) 
	{
		$host = $_SERVER['HTTP_HOST'];
		// $host = "fcc.local";
		$sth = SQL_QUERY("select * from users where user_id ='".SQL_CLEAN($_SESSION['user_id'])."'");
		$result = SQL_ASSOC_ARRAY($sth);
		$email = $result['email'];

		$sth = SQL_QUERY("update users set temporary_password='', password='".password_hash(SQL_CLEAN($_POST['password']),PASSWORD_DEFAULT)."' where user_id='".SQL_CLEAN($_SESSION['user_id'])."'");

		// die($sth);
		$result = send_message("support@ruopen.com", 
				array($email, "support@ruopen.com"), 
				"Important message from support@ruopen.com", 
				'Your password has successfully been changed.');

		if($result && $sth)
			header("location: /dashboard.php");

		$smarty->display("change_password.tpl");
		
	}
}
else {

	$smarty->display("change_password.tpl");
	
}

// die("Please wait")	
?>