<?php
/**
 * @name: mob_nearest_roads.php
 * @description: Fetch the nearest street addresses relative to the user's current location. 
 * @description: FROM GOOGLE ROAD API
 * @return : [<description>] //Well what does it return? 
 * @author [Joy Victoria] <[<jvictoria@zugent.com>]>
 */
require_once('connection.php');
require_once('mob_get_json.php');
$conn = $GLOBALS['conn'];

/** @var string [description] */
$latitude = '40.50245559';
$longitude = '-73.738545';
$api_key = 'AIzaSyDTD-gXCYJ83e7f0h06UV9EGg_VsAThBz4'; //SDK
$web_api = 'AIzaSyAq8WuTeXonjSzYw_vVLiN7PCRQNqf_v_Q'; //Web
$points = floatval($latitude).','.floatval($longitude);
$url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=".$points."&key=".$api_key.""; //Geocoding

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$json_data = json_decode(curl_exec($ch), true);

$geometry = array();
if($json_data[0] === "error_message") {
	$geometry = array('error' => 1, 'data' => "API ERROR");
} else {
	/*print_r($json_data);*/	
	if ($json_data['status'] === "OK") {
		$geometry[] = $json_data['results'];
	}

	echo json_encode($geometry);
}
?>