<?php 

require_once('connection.php');
require_once('mob_get_json.php');

header('Access-Control-Allow-Origin: *');


if (isset($_REQUEST['asBroker'])) {

	$table = "";
	$agent = array();

	if ($_REQUEST['asBroker'] == 'false') {
		$table = "site_users";
		$getPhone = "phone";
	}
	else {
		$table = "users";
		$getPhone = "phone_mobile";
	}

	$sth = SQL_QUERY("select * from ".$table." as u 
			where u.email='".SQL_CLEAN($_POST['email'])."' limit 1");

	if (SQL_NUM_ROWS($sth) == 0) {
		echo json_encode(array("error" => true, "code" => "zEmail or Password did not match"));
	}
	else {
		$userData = SQL_ASSOC_ARRAY($sth);

		if (password_verify($_POST['password'], $userData['password'])) {
			
			$clean_phone_mobile = preg_replace("/[^0-9]/", "", $userData[$getPhone]);
			$userData['clean_phone_mobile'] = $clean_phone_mobile;

			echo json_encode(array("error" => false, "agent" => $userData));
		}
		else {
			echo json_encode(array("error" => true, "code" => "Email or Password did not match"));
		}
	}

	exit;
}
else {
	echo json_encode(array("error" => true, "code" => "Something went wrong"));
}

?>