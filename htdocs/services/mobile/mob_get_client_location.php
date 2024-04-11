<?php 

require_once('connection.php');
require_once('mob_get_json.php');


if(isset($_POST['request_info']) && $_POST['request_info'] != "") {

	$temp = explode('-', $_POST['request_info']);

	// Get Recent Agent Location
	$req_info = SQL_QUERY("select * from agent_requests where agent_request_id=".SQL_CLEAN($temp[1])." and request='".SQL_CLEAN($temp[0])."' limit 1");

	$user_location = array();

	while ($data = SQL_ASSOC_ARRAY($req_info)) {
		$user_location[] = $data;
	}

	if (SQL_NUM_ROWS($req_info) == 0) {
		echo json_encode(array("error" => true));
	}
	else {
		echo json_encode(array("error" => false, "user_latitude" => $user_location[0]['latitude'], "user_longitude" => $user_location[0]['longitude']));
	}

} else {
	echo json_encode(array("error" => true));
}

?>
