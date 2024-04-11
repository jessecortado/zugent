<?php 
/**
* @name mob_request_agent.php
* @desc mobile version of "request_agent"
* @author [name] <[<email address>]>
* @author [Joy Victoria] <[<jvictoria@zugent.com>]> 
* @date May 2018
*/
include_once('mob_get_json.php');

// Var for checking the maximum distance for users from request location
$distance_from_request = 30;
// Number of agents to be notified in case of a request
$agent_num = 500;
// If sending emails should be enabled
$send_emails = false;
// If sending sms should be enabled
$send_sms = true;
// Time from last check-in in hours to be contacted during a request
$hour_interval = 1;


if (isset($_POST['latitude']) && isset($_POST['longitude'])) {

	$lat = SQL_CLEAN($_POST['latitude']);
	$lon = SQL_CLEAN($_POST['longitude']);

	$agents = array();
	$perma_agents = array();
	$least_distance = array();
	$temp = array();

	$first_name = SQL_CLEAN($_POST['first_name']);
	$last_name = SQL_CLEAN($_POST['last_name']);
	$email_address = SQL_CLEAN($_POST['email_address']);
	$phone = SQL_CLEAN($_POST['phone']);
	$mls_num = SQL_CLEAN($_POST['mls_number']);
	$address = SQL_CLEAN($_POST['property_address']);
	$has_broker = SQL_CLEAN($_POST['has_broker']);

	/** GOOGLE GEOCODE */
	$api_key_dev = 'AIzaSyCeMoBXmKsXuo3FLqtahYmyNUoc58X-lR0'; //KEY FOR TESTING == LIMITED QUOTA/DISABLED
	$api_key_prod = 'AIzaSyAq8WuTeXonjSzYw_vVLiN7PCRQNqf_v_Q'; //SIR JSON
	$url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=".$_POST['latitude'].",".$_POST['longitude']."&sensor=true&key=".$api_key_dev;

	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	$json_data = json_decode(curl_exec($ch), true);

	$data = array("street_number" => "", "route" => "", "locality political" => "");


// GET DATA FROM GEOCODE URL - START
	foreach($json_data['results']['0']['address_components'] as $element){
		$data[ implode(' ',$element['types']) ] = $element['long_name'];
	}

// echo "<pre>";
// print_r($data);
// echo "</pre>";
// die("TESTING");
if($address === ""){
	$prop_showing = "Property Address: Not applicable.";
}else{
	$prop_showing = "Property Address: ".$address;
}


// GET DATA FROM GEOCODE URL - END

	if($mls_num != ''){
		$note = "Formatted Address: ".$json_data['results']['0']['formatted_address']."\r\nContact request details: \nStreet Number: ".$data['street_number']."\r\Street: ".$data['route']."\nLocality: ".$data['locality political']."\nlatitude: ". $_POST['latitude'] ."\nlongitude: " . $_POST['longitude']. "\nMLS # or Address: " .$mls_num. "\n" . $prop_showing;
		$sth = SQL_QUERY("insert into contacts 
			(first_name,
			last_name,
			street_address,
			city,
			state,
			county,
			summary,
			latitude,
			longitude,
			has_broker,
			company_id,
			contact_source,
			date_created,
			is_referral,
			is_drive,
			mls_number) 
			values (
			'".$first_name."',
			'".$last_name."',
			'".$data['route']."',
			'".$data['locality political']."',
			'".$data['administrative_area_level_2 political']."',
			'".$data['country political']."',
			'".$note."',
			'".$_POST['latitude']."',
			'".$_POST['longitude']."',
			'".$_POST['has_broker']."',
			0,
			'ZugDrive',
			NOW(),
			1,
			1, '".$mls_num."')");
	}else{
		$note = "Formatted Address: ".$json_data['results']['0']['formatted_address']."\r\nContact request details: \nStreet Number: ".$data['street_number']."\r\Street: ".$data['route']."\nLocality: ".$data['locality political']."\nlatitude: ". $_POST['latitude'] ."\nlongitude: " . $_POST['longitude'] . "\n" . $prop_showing;
// CREATE NEW CONTACT FOR CLIENT - START
		$sth = SQL_QUERY("insert into contacts 
			(first_name,
			last_name,
			street_address,
			city,
			state,
			county,
			summary,
			latitude,
			longitude,
			has_broker,
			company_id,
			contact_source,
			date_created,
			is_referral,
			is_drive) 
			values (
			'".$first_name."',
			'".$last_name."',
			'".$data['route']."',
			'".$data['locality political']."',
			'".$data['administrative_area_level_2 political']."',
			'".$data['country political']."',
			'".$note."',
			'".$_POST['latitude']."',
			'".$_POST['longitude']."',
			'".$_POST['has_broker']."',
			0,
			'ZugDrive',
			NOW(),
			1,
			1)");
	}
	$contact_id = SQL_INSERT_ID();

	SQL_QUERY("insert into contact_phones set is_primary=1, contact_id=".$contact_id." ,phone_number='".$phone."'");
	SQL_QUERY("insert into contact_emails set is_primary=1, contact_id=".$contact_id." ,email='".$email_address."'");
	SQL_QUERY("insert into contact_referral set 
		contact_id=".SQL_CLEAN($contact_id).
		", date_referral=NOW()".
		", referral_source='ZugDrive'");
// CREATE NEW CONTACT FOR CLIENT - END


// FILTER AGENTS BY DISTANCE - START
	$sql = "select user_id, last_latitude, last_longitude, phone_mobile, email, first_name, last_name, is_perm_drive, is_drive_accepted_alert from users 
		where (last_drive > DATE_SUB(NOW(), INTERVAL 6 HOUR) or is_perm_drive = 1) and is_active = 1";
	if ($_POST['phone'] == '4254786732' || $_POST['property_address'] == 'test' || $_POST['mls_number'] == 'test') $sql .= " and company_id=1";


	$sth = SQL_QUERY($sql);

	while($data = SQL_ASSOC_ARRAY($sth)) {
		if ($data['is_perm_drive'] == 1) {
			$perma_agents[] = $data;
		}
		else if ($temp = distance($lat, $lon, $data['last_latitude'], $data['last_longitude'], 'M') <= $distance_from_request) {
			$least_distance[] = $data;
		}
		else {
			$agents[] = $data;
		}
	}
// FILTER AGENTS BY DISTANCE - END


// IF NO AGENT IS CHECKED-IN EXIT
	if (SQL_NUM_ROWS($sth) == 0) {
		echo json_encode(array("count" => SQL_NUM_ROWS($sth), "agents" => array_slice($agents, 0, $agent_num-1, true)));
		exit;
	}
	else {
	// CHECKS if THERE ARE NEARBY AGENTS by 30MILES
		if (count($least_distance) == 0)
			$temp = array_merge($agents,$perma_agents);
		else
			$temp = array_merge($least_distance,$perma_agents);

		asort($temp, SORT_NUMERIC);

		$temp = array_slice($temp, 0, $agent_num-1, true);

		$matched = array();

		/**
		 * @var string
		 * @description Possible list of host sites
		 */
		$prod1 = 'www.ruopen.com';
		$prod2 = 'ruopen.com';
		$prod3 = 'crm.ruopen.com';
		$prod4 = 'crm.zugent.com';
		$prod5 = 'zugent.com';
		$prod6 = 'www.zugent.com';

		$dev1 = 'dev.ruopen.com';
		$dev2 = 'dev.zugent.com';
		$dev3 = 'dev-crm.ruopen.com';
		$dev4 = 'dev-crm.zugent.com';

		$prodURL = array($prod1, $prod2, $prod3, $prod4, $prod5, $prod6);
		$inArrayURL = in_array($_SERVER['HTTP_HOST'], $prodURL); 

		// SET HOST ADDRESS OF MESSAGE
		if ($inArrayURL) {
			$host_address = 'https://crm.ruopen.com';
		} else {
			$host_address = 'https://dev-crm.ruopen.com';
		}


		// FOR EACH NEARBY or AVAILABLE AGENTS
		foreach ($temp as $agent => $value) {
			$request_str = random_str(8);

		// SEND SMS TO AGENT
			try {

			// ADDS TO AGENT_REQUEST TABLE
				SQL_QUERY("insert into agent_requests (contact_id, user_id, accepted, note, request, latitude, longitude, date_requested, to_sms, to_email) 
					values (
					".$contact_id.",
					".$value["user_id"].",
					0,
					'Requested from ".$lat.",".$lon."',
					'".$request_str."',
					'".$lat."',
					'".$lon."',
					NOW(),
					'".$value["phone_mobile"]."',
					'".$value["email"]."')");

				$agent_request_id = SQL_INSERT_ID();

				$matched[] = $value;

			// SMS MESSAGE
				$sms_message = 'A potential contact has requested for an agent. Go to '.$host_address.'/accept_request/'.$request_str."-".$agent_request_id." to claim the contact.";

			// EMAIL MESSAGE
				$message = 'A potential contact has requested for an agent. Click <a href="'.$host_address.'/accept_request/'.$request_str."-".$agent_request_id."'>here</a> to claim the contact.";

			// SEND SMS TO AGENT
				if ($send_sms)
					if ($value['phone_mobile'] !== "(000) 000-0000" && $value['phone_mobile'] !== "") {
						$sms_log_id = send_to_one($value['phone_mobile'], '+12062029550', $sms_message, $value['user_id']);

					// SET AGENT REQUEST SENT_VIA_SMS
						SQL_QUERY("update agent_requests set sent_via_sms = 1, sms_log_id = '".SQL_CLEAN($sms_log_id)."' where agent_request_id=".SQL_CLEAN($agent_request_id));
					}

			// SEND EMAIL TO AGENT
					if ($send_emails) {
						send_message("support@zugent.com", 
							array($value['email'], "support@zugent.com"), 
							"A potential client has requested for an agent (For testing)", 
							$message);

				// SET AGENT REQUEST SENT_VIA_EMAIL
						SQL_QUERY("update agent_requests set sent_via_email = 1 where agent_request_id=".SQL_CLEAN($agent_request_id));
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
	else {
		echo json_encode(array("error" => true, "message" => "postdatanotfound"));
		exit;
	}
	?>
