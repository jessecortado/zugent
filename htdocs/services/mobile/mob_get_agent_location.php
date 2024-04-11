<?php 

require_once('connection.php');
require_once('mob_get_json.php');


if(isset($_POST['user_id']) && $_POST['user_id'] != "") {

	// Get Recent Agent Location
	$user_info = SQL_QUERY("select last_latitude, last_longitude from users where user_id='".SQL_CLEAN($_POST['user_id'])."' and is_active=1 limit 1");

	$user_location = array();

	while ($data = SQL_ASSOC_ARRAY($user_info)) {
		$user_location[] = $data;
	}

	echo json_encode(array("error" => false, "user_latitude" => $user_location[0]['last_latitude'], "user_longitude" => $user_location[0]['last_longitude']));

} else {
	echo json_encode(array("error" => true));
}

?>
