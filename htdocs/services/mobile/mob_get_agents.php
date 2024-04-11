<?php 
/**
 * @desc Copy of get_agents.php. Removed some lines for mobile fetching.  
 * @date May 2018
 * @author [Joy Victoria] <[<jvictoria@zugent.com>]>
 */
include_once('mob_get_json.php');


// if (isset($_POST['agents_only'])) {
	$agents = array();

	$sth = SQL_QUERY("select user_id, last_latitude, last_longitude, phone_mobile, first_name, last_name from users 
		where (last_drive > DATE_SUB(NOW(), INTERVAL 6 HOUR) or is_perm_drive = 1) and is_active = 1");

	while($data = SQL_ASSOC_ARRAY($sth)) {
		$clean_phone_mobile = preg_replace("/[^0-9]/", "", $data['phone_mobile']);
		$data['clean_phone_mobile'] = $clean_phone_mobile;
		$agents[] = $data;
	}

	if (count($agents) == 0) {
		echo json_encode(array("count" => SQL_NUM_ROWS($sth), "agents" => "No Available"));
		exit;
	}
	else {
		echo json_encode(array("error" => false, "count" => count($agents),  "agents" => $agents));
	}

	exit;

// }

?>
