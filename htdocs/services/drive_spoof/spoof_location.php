<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/includes/degree_location.php");

auth();

function getRandomInRange() {
	$min = -99999;
	$max = 99999;
	$number = mt_rand($min,$max)/10000000;
	return $number;
}

if (isset($_POST['spoof_agents']) && $_POST['spoof_agents'] == 'true') {
	// Get Company Agents
	$list_agent = $_POST['agent_ids'];

	foreach ($list_agent as $key => $value) {
		// Get current last_latitude and last_longitude
		$sth = SQL_QUERY("select * from users where user_id = '".SQL_CLEAN($value)."'");
		$agent = array();
		while ($data = SQL_ASSOC_ARRAY($sth)) {
			$agent = $data;
		}

		$new_latitude = (float)$agent['last_latitude'] + getRandomInRange();
		$new_longitude = (float)$agent['last_longitude'] + getRandomInRange();

		// Get Degree Direction
		$direction = convertToDirection(getDegreeLocation(($new_latitude - $agent['last_latitude']),($new_longitude - $agent['last_longitude'])));

		// Change last_drive and location of user
		// SQL_QUERY("update users set last_drive = NOW(), last_latitude = '".SQL_CLEAN($new_latitude)."', last_longitude = '".SQL_CLEAN($new_longitude)."' where user_id=".SQL_CLEAN($value));
		SQL_QUERY("update users set 
			last_drive=NOW(), 
			last_latitude='".SQL_CLEAN($new_latitude)."', 
			last_longitude='".SQL_CLEAN($new_longitude)."', 
			recent_latitude='".SQL_CLEAN($agent['last_latitude'])."', 
			recent_longitude='".SQL_CLEAN($agent['last_longitude'])."', 
			direction='".SQL_CLEAN($direction)."' 
			where user_id='".SQL_CLEAN($value)."'");
	}

	// Get latest last_latitude and last_longitude
	$list_agent = SQL_QUERY("select u.* from users as u ".
		"where u.last_drive != '' and ".
		"u.company_id = '".$_SESSION['user']['company_id']."' and ".
		"u.user_id != '".$_SESSION['user']['user_id']."' ".
		"order by u.last_drive desc");

	$agents = array();

	while ($data = SQL_ASSOC_ARRAY($list_agent)) {
		$agents[] = $data;
	}

	echo json_encode(array("errro" => false, "agents" => $agents));

}
else {
	echo json_encode(array("errro" => true, "message" => "Something went wrong"));
}

?>