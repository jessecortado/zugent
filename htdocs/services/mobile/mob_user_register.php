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

	$sth = SQL_QUERY("select * from ".$table." where email='".SQL_CLEAN($_POST['email'])."'");
	if (SQL_NUM_ROWS($sth) != 0) {
		echo json_encode(array("error" => true, "code" => "Email exists"));
		exit;
	}

	$sth = SQL_QUERY("insert into ".$table." (
		date_created,
		first_name,
		last_name,
		email,
		".$getPhone.",
		password) 
		values (NOW(),
		'".SQL_CLEAN($_POST['first_name'])."',
		'".SQL_CLEAN($_POST['last_name'])."',
		'".SQL_CLEAN($_POST['email'])."',
		'".SQL_CLEAN($_POST[$getPhone])."',
		'".password_hash(SQL_CLEAN($_POST['password']),PASSWORD_DEFAULT)."')
	");

	$user_id = SQL_INSERT_ID();

	if ($user_id != 0) {
		echo json_encode(array("error" => false, "code" => "You can now login as a user"));
	}
	else {
		echo json_encode(array("error" => true, "code" => "Something went wrong"));
	}

	exit;
}
else {
	echo json_encode(array("error" => true, "code" => "Something went wrong"));
}

?>