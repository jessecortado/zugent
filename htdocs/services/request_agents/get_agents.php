<?php 

require_once($_SERVER['SITE_DIR']."/htdocs/services/send_sms.php");

header('Access-Control-Allow-Origin: *');

try {
	$inputJSON = file_get_contents('php://input');

	if (!isset($_POST['latitude']) && !isset($_GET['request'])) {
		$_POST = json_decode($inputJSON, TRUE);
	}
} catch (EXCEPTION $e) {
	echo json_encode($e);
}

// Var for checking the maximum distance for users from request location 
$distance_from_request = 30;
// Number of agents to be notified in case of a request
$agent_num = 5;
// If sending emails should be enabled
$send_emails = false;
// If sending sms should be enabled
$send_sms = true;
// Time from last check-in in hours to be contacted during a request
$hour_interval = 6;

if (isset($_POST['latitude']) && isset($_POST['longitude'])) {

	$lat = SQL_CLEAN($_POST['latitude']);
	$lon = SQL_CLEAN($_POST['longitude']);
	
	$agents = array();
	$least_distance = array();
	$temp = array();

	if (isset($_POST['agents_only'])) {

		$sth = SQL_QUERY("select 
			u.user_id, ul.latitude as last_latitude, ul.longitude as last_longitude, u.phone_mobile, u.first_name, u.last_name, u.direction
			from users as u 
			left join user_locations as ul on u.user_id=ul.user_id 
			where ul.date_collected > DATE_SUB(NOW(), INTERVAL ".$hour_interval." HOUR) and u.is_active = 1 
			and u.user_id != ".SQL_CLEAN($_SESSION['user']['user_id'])." 
			order by ul.date_collected DESC");

		// $sth = SQL_QUERY("select 
		// 	u.user_id, ul.latitude as last_latitude, ul.longitude as last_longitude, u.phone_mobile, u.first_name, u.last_name, u.direction
		// 	from users as u 
		// 	left join user_locations as ul on u.user_id=ul.user_id 
		// 	where u.is_active = 1 and (u.last_latitude != '' and u.last_longitude != '') 
		// 	and (u.last_drive > DATE_SUB(NOW(), INTERVAL ".$hour_interval." HOUR) or u.is_perm_drive = 1) 
		// 	and u.user_id != ".$_SESSION['user']['user_id']."");

		while($data = SQL_ASSOC_ARRAY($sth)) {
			$agents[] = $data;
		}

		if (SQL_NUM_ROWS($sth) == 0) {
			echo json_encode(array("count" => SQL_NUM_ROWS($sth), "agents" => array_slice($agents, 0, $agent_num-1, true)));
			exit;
		}
		else {
			echo json_encode(array("error" => false, "count" => count($agents),  "agents" => $agents));
		}

		exit;

		// $sth = SQL_QUERY("select 
		// 	u.user_id, ul.latitude as last_latitude, ul.longitude as last_longitude, u.phone_mobile, u.first_name, u.last_name 
		// 	from users as u 
		// 	left join user_locations as ul on u.user_id=ul.user_id 
		// 	order by ul.date_collected DESC");

		// while($data = SQL_ASSOC_ARRAY($sth)) {
		// 	if ($temp = distance($lat, $lon, $data['last_latitude'], $data['last_longitude'], 'M') <= $distance_from_request) {
		// 		$least_distance[$data["user_id"]] = $temp;
		// 	}
		// 	else {
		// 		$agents[$data["user_id"]] = $temp;
		// 	}
		// }

		

		// if (SQL_NUM_ROWS($sth) == 0) {
		// 	echo json_encode(array("count" => SQL_NUM_ROWS($sth), "agents" => array_slice($agents, 0, $agent_num-1, true)));
		// 	exit;
		// }
		// else {
		// 	if (count($least_distance) == 0)
		// 		$temp = $agents;
		// 	else
		// 		$temp = $least_distance;

		// 	asort($temp, SORT_NUMERIC);

		// 	$temp = array_slice($temp, 0, $agent_num-1, true);

		// 	$matched = array();
		// 	foreach ($temp as $key => $value) {

				// $sth = SQL_QUERY("select 
				// 	u.user_id, ul.latitude as last_latitude, ul.longitude as last_longitude, u.phone_mobile, u.first_name, u.last_name, u.phone_mobile, u.email 
				// 	from users as u 
				// 	left join user_locations as ul on u.user_id=ul.user_id 
				// 	where ul.date_collected > DATE_SUB(NOW(), INTERVAL ".$hour_interval." HOUR) and u.user_id=".$key."  
				// 	order by ul.date_collected DESC limit 1");
		// 		$sth = SQL_QUERY("select 
		// 			u.user_id, ul.latitude as last_latitude, ul.longitude as last_longitude, u.phone_mobile, u.first_name, u.last_name, u.phone_mobile, u.email 
		// 			from users as u 
		// 			left join user_locations as ul on u.user_id=ul.user_id 
		// 			where u.user_id=".$key."  
		// 			order by ul.date_collected DESC limit 1");
		// 		$data = SQL_ASSOC_ARRAY($sth);
		// 		$matched[] = $data;

		// 	}

		// 	echo json_encode(array("error" => false, "count" => count($matched),  "agents" => $matched));
		// }

		// exit;

	}

	$first_name = SQL_CLEAN($_POST['first_name']);
	$last_name = SQL_CLEAN($_POST['last_name']);
	$email_address = SQL_CLEAN($_POST['email_address']);
	$phone = SQL_CLEAN($_POST['phone']);

	$url = "http://maps.googleapis.com/maps/api/geocode/json?latlng=".$_POST['latitude'].",".$_POST['longitude']."&sensor=true";
	$raw_data = @file_get_contents($url);
    $json_data = json_decode($raw_data,true);

	$data = array("street_number" => "", "route" => "", "locality political" => "");

	foreach($json_data['results']['0']['address_components'] as $element){
		$data[ implode(' ',$element['types']) ] = $element['long_name'];
	}

	$note = "Formatted Address: ".$json_data['results']['0']['formatted_address']."\r\nContact request details: \nStreet Number: ".$data['street_number']."\r\Street: ".$data['route']."\nLocality: ".$data['locality political']."\nlatitude: ". $_POST['latitude'] ."\nlongitude: " . $_POST['longitude'];

	$sth = SQL_QUERY("insert into contacts (first_name, last_name, summary, company_id, contact_source, date_created, is_referral, is_drive) values ('".$first_name."','".$last_name."','".$note."', 0, 'ZugDrive', NOW(), 1, 1)");

	$contact_id = SQL_INSERT_ID();

	SQL_QUERY("insert into contact_phones set is_primary=1, contact_id=".$contact_id." ,phone_number='".$phone."'");
	SQL_QUERY("insert into contact_emails set is_primary=1, contact_id=".$contact_id." ,email='".$email_address."'");
	SQL_QUERY("insert into contact_referral set 
				contact_id=".SQL_CLEAN($contact_id).
				", date_referral=NOW()".
				", referral_source='ZugDrive'");

	// $sth = SQL_QUERY("select 
	// 	u.user_id, u.last_latitude, u.last_longitude, u.phone_mobile, u.first_name, u.last_name 
	// 	from users as u 
	// 	left join user_locations as ul on u.user_id=ul.user_id 
	// 	where ul.date_collected > DATE_SUB(NOW(), INTERVAL ".$hour_interval." HOUR)");
	$sth = SQL_QUERY("select 
		u.user_id, u.last_latitude, u.last_longitude, u.phone_mobile, u.first_name, u.last_name 
		from users as u 
		left join user_locations as ul on u.user_id=ul.user_id order by ul.date_collected DESC");

	while($data = SQL_ASSOC_ARRAY($sth)) {
		if ($temp = distance($lat, $lon, $data['last_latitude'], $data['last_longitude'], 'M') <= $distance_from_request){
			$least_distance[$data["user_id"]] = $temp;
		}
		else {
			$agents[$data["user_id"]] = $temp;
		}
	}

	if (SQL_NUM_ROWS($sth) == 0) {
		echo json_encode(array("count" => SQL_NUM_ROWS($sth), "agents" => array_slice($agents, 0, $agent_num-1, true)));
		exit;
	}
	else {
		if (count($least_distance) == 0)
			$temp = $agents;
		else
			$temp = $least_distance;

		asort($temp, SORT_NUMERIC);

		$temp = array_slice($temp, 0, $agent_num-1, true);

		$matched = array();
		foreach ($temp as $key => $value) {

			$request_str = random_str(20);
			SQL_QUERY("insert into agent_requests (contact_id, user_id, accepted, note, request, latitude, longitude) values (".$contact_id.",".$key.",0,'Requested from ".$lat.",".$lon."','".$request_str."','".$lat."','".$lon."')");
			$agent_request_id = SQL_INSERT_ID();

			// $sth = SQL_QUERY("select 
			// 	u.user_id, u.last_latitude, u.last_longitude, u.phone_mobile, u.first_name, u.last_name, u.phone_mobile, u.email 
			// 	from users as u 
			// 	left join user_locations as ul on u.user_id=ul.user_id 
			// 	where ul.date_collected > DATE_SUB(NOW(), INTERVAL ".$hour_interval." HOUR) and u.user_id=".$key);
			$sth = SQL_QUERY("select 
				u.user_id, u.last_latitude, u.last_longitude, u.phone_mobile, u.first_name, u.last_name, u.phone_mobile, u.email 
				from users as u 
				left join user_locations as ul on u.user_id=ul.user_id 
				where u.user_id=".$key." order by ul.date_collected DESC");

			$data = SQL_ASSOC_ARRAY($sth);
			$matched[] = $data;
			$message = 'A potential contact has requested for an agent. Click <a href="'.$_SERVER['HTTP_HOST'].'/ws/request_agent/accept_request/'.$request_str."-".$agent_request_id."'>here</a> to claim the contact.";
			$sms_message = 'A potential contact has requested for an agent. Go to '.$_SERVER['HTTP_HOST'].'/ws/request_agent/accept_request/'.$request_str."-".$agent_request_id." to claim the contact.";

			// change to send to user 
			// to from message 
			try {
				if ($send_sms)
					if ($data['phone_mobile'] != "(000) 000-0000") {
						send_to_one($data['phone_mobile'], '+12062029550', $sms_message, $data['user_id']);
					}
				if ($send_emails) {
					send_message("support@ruopen.com", 
						array($data['email'], "support@ruopen.com"), 
						"A potential client has requested for an agent (For testing)", 
					$message);
				}
			} catch (exception $e) {
				// echo $e;
				// die(var_dump($temp));
				echo json_encode(array("error" => true, "message" => $e->getMessage()));
				exit;
			}

		}
		echo json_encode(array("error" => false, "count" => count($matched),  "agents" => $matched, "id" => $contact_id));
	}

}
else {
	header("location: /request_agent.php?code=1x007");
}

?>