<?php 

require_once($_SERVER['SITE_DIR']."/htdocs/services/send_sms.php");

header('Access-Control-Allow-Origin: *');

try {
	$inputJSON = file_get_contents('php://input');

	if (!isset($_POST['agent_id'])) {
		$_POST = json_decode($inputJSON, TRUE);
	}
	else {
		echo json_encode("404");
	}
} catch (EXCEPTION $e) {
	echo json_encode($e);
}

if (isset($_POST['agent_id'])) {
	$sth = SQL_QUERY("select u.user_id, u.last_latitude, u.last_longitude, u.phone_mobile, u.first_name, u.last_name, u.phone_mobile, u.email from users as u where u.user_id=".SQL_CLEAN($_POST['agent_id']));
	$data = SQL_ASSOC_ARRAY($sth);
	echo json_encode(array("lat" => $data['last_latitude'], "lon" => $data['last_longitude']));
}
else {
	header("location: /request_agent.php?code=1x007");
}

?>