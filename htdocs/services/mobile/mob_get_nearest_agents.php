<?php 

require_once('connection.php');
require_once('mob_get_json.php');

header('Access-Control-Allow-Origin: *');

// Var for checking the maximum distance for users from request location 
$distance_from_request = 30;
// Time from last check-in in hours to be contacted during a request
$hour_interval = 6;


if (isset($_POST['latitude']) && isset($_POST['longitude'])) {

	$lat = SQL_CLEAN($_POST['latitude']);
	$lon = SQL_CLEAN($_POST['longitude']);
	
	$agents = array();
	$least_distance = array();
	$available_agents = array();


	$sth = SQL_QUERY("select 
		u.user_id, u.last_latitude, u.last_longitude, u.phone_mobile, u.first_name, u.last_name, u.direction, 
		u.phone_mobile, u.email, c.company_name
		from users as u 
        left join companies as c on u.company_id=c.company_id 
		where u.is_active = 1 and (u.last_latitude != '' and u.last_longitude != '') 
		and (u.last_drive > DATE_SUB(NOW(), INTERVAL ".$hour_interval." HOUR) or u.is_perm_drive = 1) 
		order by u.last_drive DESC");

	while($data = SQL_ASSOC_ARRAY($sth)) {
		$temp = distance($lat, $lon, $data['last_latitude'], $data['last_longitude'], 'M');

		$clean_phone_mobile = preg_replace("/[^0-9]/", "", $data['phone_mobile']);
		$data['clean_phone_mobile'] = $clean_phone_mobile;

		if ($temp <= $distance_from_request) {
			$data["distance"] = $temp;
			$least_distance[] = $data;
		}
		else {
			$data["distance"] = $temp;
			$agents[] = $data;
		}
	}

	if (SQL_NUM_ROWS($sth) == 0) {
		echo json_encode(array("error" => false, "count" => SQL_NUM_ROWS($sth)));
		exit;
	}
	else {
		if (count($least_distance) == 0) {
			$available_agents = $agents;
		}
			else {
			$available_agents = $least_distance;
		}

		echo json_encode(array("error" => false, "count" => count($available_agents), "agents" => $available_agents));
	}

	exit;
}
else {
	echo json_encode(array("error" => true));
}

?>