<?php 

header('Access-Control-Allow-Origin: *');

// echo json_encode("working api");
$fLat = floatval('47.585734');
$fLon = floatval('-122.308453');
$sLat = floatval('47.624869');
$sLon = floatval('-122.294510');

	$apiKey = 'sk.eyJ1Ijoiam95dmljdG9yaWEiLCJhIjoiY2psYWJldW12MGpxZDNwcGdrc2NocGFhcSJ9.Ny9wrrwqDPRd3KfDKlg30w';
	// $apiKey = 'pk.eyJ1Ijoiam95dmljdG9yaWEiLCJhIjoiY2psYWIyMnpxMDZuZTN3cWlxOXZiMnkxeSJ9.gw88rh26SGw9a0cR3DdsGg';

	// $apiKey = 'pk.eyJ1IjoiamdyYW51bSIsImEiOiJjam5mbW82OHAxY2ttM3JvMG5zZ2U2c2I5In0.QHxES64658j5BYkiAWfiYg';
	$geometries='geojson'; //geojson, polyline


// $completeUrl = 'https://api.mapbox.com/directions/v5/mapbox/driving-traffic/'.$fLon.','.$fLat.';'.$sLon.','.$sLat.'?access_token=pk.eyJ1Ijoiam95dmljdG9yaWEiLCJhIjoiY2psYWIyMnpxMDZuZTN3cWlxOXZiMnkxeSJ9.gw88rh26SGw9a0cR3DdsGg&steps=true&alternatives=false&geometries=geojson';


	$completeUrl = 'https://api.mapbox.com/directions/v5/mapbox/driving-traffic/'.$fLon.','.$fLat.';'.$sLon.','.$sLat.'?access_token='.$apiKey.'&steps=true&alternatives=false&geometries='.$geometries.'';

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $completeUrl);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$json_data = json_decode(curl_exec($ch), true);
//return json_encode($json_data);

$retVal = $json_data['routes'][0]['geometry']['coordinates'];
$duration = $json_data['routes'][0]['legs'][0]['duration'];


echo '<pre>';
print_r($json_data);
echo '</pre>';

echo json_encode(array('data' => $retVal, 'duration' => $duration, 'error' => false, 'completeUrl' => $completeUrl));