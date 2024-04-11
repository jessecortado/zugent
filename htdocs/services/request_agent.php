<?php

require_once($_SERVER['SITE_DIR']."/htdocs/services/send_sms.php");
header('Access-Control-Allow-Origin: *');

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
try {
	$inputJSON = file_get_contents('php://input');

	if (!isset($_POST['latitude']) && !isset($_GET['request'])) {
		$_POST = json_decode($inputJSON, TRUE);
	}
	else {
		echo json_encode("Not there");
	}
} catch (EXCEPTION $e) {
	echo json_encode($e);
}

if (isset($_POST['latitude']) && isset($_POST['longitude'])) {
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

	$sth = SQL_QUERY("select 
		u.user_id, u.last_latitude, u.last_longitude, u.phone_mobile, u.first_name, u.last_name 
		from users as u 
		left join user_locations as ul on u.user_id=ul.user_id 
		where ul.date_collected > DATE_SUB(NOW(), INTERVAL ".$hour_interval." HOUR)");

	$lat = SQL_CLEAN($_POST['latitude']);
	$lon = SQL_CLEAN($_POST['longitude']);
	$agents = array();
	$least_distance = array();

	while($data = SQL_ASSOC_ARRAY($sth)) {
		if ($temp = distance($lat, $lon, $data['last_latitude'], $data['last_longitude'], 'M') <= $distance_from_request){
			$least_distance[$data["user_id"]] = $temp;
		}
		else {
			$agents[$data["user_id"]] = $temp;
		}
	}

	$temp = array();

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

			$sth = SQL_QUERY("select 
				u.user_id, u.last_latitude, u.last_longitude, u.phone_mobile, u.first_name, u.last_name, u.phone_mobile, u.email 
				from users as u 
				left join user_locations as ul on u.user_id=ul.user_id 
				where ul.date_collected > DATE_SUB(NOW(), INTERVAL ".$hour_interval." HOUR) and u.user_id=".$key);
			$data = SQL_ASSOC_ARRAY($sth);
			$matched[] = $data;
			$message = 'A potential contact has requested for an agent. Click <a href="'.$_SERVER['HTTP_HOST'].'/ws/request_agent/accept_request/'.$request_str."-".$agent_request_id."'>here</a> to claim the contact.";
			$sms_message = 'A potential contact has requested for an agent. Go to '.$_SERVER['HTTP_HOST'].'/ws/request_agent/accept_request/'.$request_str."-".$agent_request_id." to claim the contact.";

			// change to send to user 
			// to from message 
			try {
				if ($send_sms)
					send_to_one($data['phone_mobile'], '+12062029550', $sms_message, $data['user_id']); 
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
		echo json_encode(array("error" => false, "count" => count($matched),  "agents" => $matched, "id" => $contact_id, "mls" => $mls_num));
	}

}
else if (isset($_POST['contact_id'])) {
	// Check for response by checking if a company id has been set to any id not 0.
	// Also get only the primary agent assigned - and if for some reason there isn't a primary then return
	// the first user (achieved via a order by limit 1)
	$sth = SQL_QUERY("
		select 
			c.*
			, cp.phone_number
			, u.user_id
			, ce.email
			, u.last_latitude
			, u.last_longitude
		from contacts as c 
		left join contact_phones as cp on cp.contact_id=c.contact_id and cp.is_primary=1 
		left join contact_emails as ce on ce.contact_id=c.contact_id and ce.is_primary=1 
		left join contacts_rel_users as cu on cu.contact_id=c.contact_id 
		left join users as u on u.user_id=cu.user_id 
		where c.contact_id='".SQL_CLEAN($_POST['contact_id'])."'
		order by cu.is_primary desc limit 1
	");

	$data = SQL_ASSOC_ARRAY($sth);

	if ($data['company_id'] == 0) {
		echo json_encode(array("accepted" => false));
	}
	else {
		// $message = "Success! An agent has accepted your request and is on the way.";
		$sth = SQL_QUERY("select u.*, c.company_name from users as u left join companies as c on c.company_id=u.company_id where u.user_id='".SQL_CLEAN($data['user_id'])."'");
		$agent = SQL_ASSOC_ARRAY($sth);

		// send_to_one($_POST['phone'], '+12062029550', $message); -- Don't send an SMS notice to the contact - just show them on the page.
		echo json_encode(array("accepted" => true, "agent_id" => $data['user_id'], "agent" => $agent, "lat" => $data['last_latitude'], "lon" => $data['last_longitude']));
	}

}
else if (isset($_GET['request'])) {

	if (empty($_GET['request'])) 
		header('location: /404');

	$temp = explode('-', $_GET['request']);
	$sth = SQL_QUERY("select * from agent_requests where agent_request_id=".SQL_CLEAN($temp[1])." and request='".SQL_CLEAN($temp[0])."'");

	if (SQL_NUM_ROWS($sth) == 0) {
		echo "Request not valid";
		exit; 
	}

	$request_data = SQL_ASSOC_ARRAY($sth);

	// Check if the contact has been taken or doesn't exist
	$sth = SQL_QUERY("select * from contacts where contact_id=".SQL_CLEAN($request_data['contact_id'])." and company_id=0");

	if (SQL_NUM_ROWS($sth) == 0) {
		echo "Contact has already been assigned";
		exit; 
	}

	$sth = SQL_QUERY("select * from users where user_id=".SQL_CLEAN($request_data['user_id']));
	$user_data = SQL_ASSOC_ARRAY($sth);

	SQL_QUERY("update contacts set company_id=".SQL_CLEAN($user_data['company_id'])." where contact_id=".SQL_CLEAN($request_data['contact_id']));
	SQL_QUERY("update contact_referral set user_id=".SQL_CLEAN($user_data['user_id'])." where contact_id=".SQL_CLEAN($request_data['contact_id']));

	$cond1 = SQL_QUERY("insert into contacts_rel_users set is_primary=1, user_id=".SQL_CLEAN($user_data['user_id']).", contact_id=".SQL_CLEAN($request_data['contact_id']));
	$cond2 = SQL_QUERY("update agent_requests set accepted=1 where agent_request_id=".SQL_CLEAN($temp[1]));

	if ($cond1 && $cond2) {
		// add notification
		// id, title, notification, url_action
		add_notification($user_data['user_id'], "New Contact", "You accepted a new contact", $_SERVER['HTTP_HOST']."/contacts_edit.php?id=".$request_data['contact_id']);

		// Will change to display in website 
		// header("location: https://www.google.com/maps/dir/?api=1&destination=".$request_data['latitude'].",".$request_data['longitude']."");
		header("location: /drive.php");
	}


}
else if (isset($_POST['agent_id'])) {
	$sth = SQL_QUERY("select u.user_id, u.last_latitude, u.last_longitude, u.phone_mobile, u.first_name, u.last_name, u.phone_mobile, u.email from users as u where u.user_id=".SQL_CLEAN($_POST['agent_id']));
	$data = SQL_ASSOC_ARRAY($sth);
	echo json_encode(array("lat" => $data['last_latitude'], "lon" => $data['last_longitude']));
}
else {
	echo json_encode("error in getting lat and long");
}
