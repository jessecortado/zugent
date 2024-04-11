<?php
/**
 * @name: mob_nearest_roads.php
 * @description: Fetch the nearest street addresses relative to the user's current location. 
 * @description: FROM GOOGLE ROAD API. 
 * @objetive: First, call geocoding API by using parameters: coordinates. Then, use the nearest street address as parameter to fetch the coordinates, which is reverse geocoding
 * @return : [<description>] //Well what does it return? 
 * @author [Joy Victoria] <[<jvictoria@zugent.com>]>
 */
require_once('connection.php');
require_once('mob_get_json.php');

/** @var string [description] */
if (isset($_POST)) {
	$latitude = $_POST['latitude'];
	$longitude = $_POST['longitude'];
	$api_key = 'AIzaSyDTD-gXCYJ83e7f0h06UV9EGg_VsAThBz4'; //joymarievictoria@gmail.com

	/**
	 * [$points Check first if parameters are in string condition. Else, parse to float. ]
	 */
	if(is_string($latitude)) {
		$latitude = floatval($latitude);
	} 
	if(is_string($longitude)) {
		$longitude = floatval($longitude);
	} 
	$points = $latitude.','.$longitude;
	$url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=".$points."&key=".$api_key.""; //Geocoding

	/**
	 * [$ch CURL]
	 * @var [type]
	 */
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	$json_data = json_decode(curl_exec($ch), true);

	$geometry = array();
	$tempGeometry = array();
	if($json_data['status'] === "OK") {
		/*print_r($json_data);*/	
		if ($json_data['status'] === "OK") {
			foreach ($json_data['results'] as $key => $value) {
				if($value['formatted_address'] !== null || $value['formatted_address'] !== "") {
					$tempGeometry[] = $value['geometry'];
				}
			}
		}

		$countRes = count($tempGeometry); //The more the better.
		if($countRes > 0) {
			/** return the first array value */
			$locationFirst = $tempGeometry[0]; //Should be "location_type":"ROOFTOP"
			$geometry[] = array(
				'error' => 0, 
				'data' => $locationFirst, 
				'message' => 'SUCCESS'
			);

		} else {
			$geometry[] = array('error' => 1, "data" => $geometry, 'message' => 'No coordinates found.');
		}
	} else {
		$geometry[] = array('error' => 1, 'data' => [], 'message' => $json_data);
	}
	echo json_encode($geometry);
} else {
	echo json_encode(array('error' => 1, 'data' => [], 'mesage' => 'Parameters undefined. '));
}

?>