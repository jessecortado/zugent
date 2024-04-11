<?php
/**
 * mob_routes.php
 * @author [Joy Victoria] <[<jvictoria@zugent.com>]>
 * @description Fetch waypoints, alternative routes and geojson coordinates from MapBox Directions API
 */
require_once('mob_get_json.php');
if (isset($_POST)) {
	// $apiKey = 'sk.eyJ1Ijoiam95dmljdG9yaWEiLCJhIjoiY2psYWJldW12MGpxZDNwcGdrc2NocGFhcSJ9.Ny9wrrwqDPRd3KfDKlg30w';
	$apiKey = 'pk.eyJ1IjoiamdyYW51bSIsImEiOiJjam5mbW82OHAxY2ttM3JvMG5zZ2U2c2I5In0.QHxES64658j5BYkiAWfiYg';

	$fLat = floatval($_POST['fLat']);
	$fLon = floatval($_POST['fLon']);
	$sLat = floatval($_POST['sLat']);
	$sLon = floatval($_POST['sLon']);

	//SAMPLE DATA
	/*$fLat = floatval('13.611035;');
	$fLon = floatval('123.1797915');
	$sLat = floatval('13.6333488');
	$sLon = floatval('123.18872669999996');*/

	$steps = true; /** WaYPOINTS */
	$alternatives = true; //TRUE
	$geometries='geojson'; //geojson, polyline

	/** SAMPLE */
	//https://api.mapbox.com/directions/v5/mapbox/driving-traffic/123.1797915,13.611035;123.1994398,13.6304442?access_token=pk.eyJ1Ijoiam95dmljdG9yaWEiLCJhIjoiY2psYWIyMnpxMDZuZTN3cWlxOXZiMnkxeSJ9.gw88rh26SGw9a0cR3DdsGg&steps=true&alternatives=false&geometries=polyline

	$completeUrl = 'https://api.mapbox.com/directions/v5/mapbox/driving-traffic/'.$fLon.','.$fLat.';'.$sLon.','.$sLat.'?access_token='.$apiKey.'&steps=true&alternatives=false&geometries='.$geometries.'';

	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $completeUrl);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	$json_data = json_decode(curl_exec($ch), true);
	//return json_encode($json_data);

	$retVal = $json_data['routes'][0]['geometry']['coordinates'];
	$duration = $json_data['routes'][0]['legs'][0]['duration'];
	echo json_encode(array('data' => $retVal, 'duration' => $duration, 'error' => false, 'errorMessage' => null));
} else {
	echo json_encode(array('data' => 0, 'error' => true, 'errorMessage' => 'Expected parameters: COORDINATES.'));
}

?>