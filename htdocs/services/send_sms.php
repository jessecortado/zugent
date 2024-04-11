<?php
// Required if your environment does not handle autoloading
require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");

// Use the REST API Client to make requests to the Twilio REST API
use Twilio\Rest\Client;

function distance($lat1, $lon1, $lat2, $lon2, $unit) {

	$theta = $lon1 - $lon2;
	$dist = sin(deg2rad($lat1)) * sin(deg2rad($lat2)) +  cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * cos(deg2rad($theta));
	$dist = acos($dist);
	$dist = rad2deg($dist);
	$miles = $dist * 60 * 1.1515;
	$unit = strtoupper($unit);

	if ($unit == "K") {
		return ($miles * 1.609344);
	} 
	else if ($unit == "N") {
		return ($miles * 0.8684);
	} 
	else {
		return $miles;
	}
}

function send_to_one($to, $from = '+12062029550', $message, $user_id) {

	// Your Account SID and Auth Token from twilio.com/console
	try{
		$sid = "AC40abe64877e7567878f1773133cf622c";
		$token = "57114e307ae4185578ee447c73220dbf";
		
		$to = preg_replace("/[^0-9]/", "", $to);

		if (strlen($to) == 10) {
			$to = "+1".$to;
		} else {
			$to = "+".$to;
		}

		$client = new Client($sid, $token);
		$client->messages->create(
			$to,
			array(
				'from' => "$from",
				'body' => $message
				)
			);

		SQL_QUERY("insert into zugent.sms_log set date_sent=NOW(), message='".SQL_CLEAN($message)."', to_number='".SQL_CLEAN($to)."', user_id='".SQL_CLEAN($user_id)."'");
		return true;
	} 
	catch (Exception $e) {
		SQL_QUERY("insert into zugent.sms_log set date_sent=NOW(), message='".SQL_CLEAN($message)."', to_number='".SQL_CLEAN($to)."', user_id='".SQL_CLEAN($user_id)."', info='".SQL_CLEAN($z)."'");
		return json_encode($e);
	}			

}
