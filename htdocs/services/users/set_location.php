<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/includes/degree_location.php");


if(isset($_POST['lat']) && isset($_POST['lon'])) {

	$date = gmdate("Y-m-d H:i:s");

	// Get Recent Location
	$user_info = SQL_QUERY("select last_latitude, last_longitude from users where user_id='".SQL_CLEAN($_SESSION['user_id'])."' and is_active=1 limit 1");

	$user_location = array();

	while ($data = SQL_ASSOC_ARRAY($user_info)) {
		$user_location[] = $data;
	}

	$startpoint['lat'] = $user_location[0]['last_latitude'];
	$startpoint['lng'] = $user_location[0]['last_longitude'];

	$endpoint['lat'] = $_POST['lat'];
	$endpoint['lng'] = $_POST['lon'];

	// Get Degree Direction
	$direction = convertToDirection(getDegreeLocation(($endpoint['lat'] - $startpoint['lat']),($endpoint['lng'] - $startpoint['lng'])));

	if ($startpoint['lat'] == $endpoint['lat'] && $startpoint['lng'] == $endpoint['lng']) {

		SQL_QUERY("update users set 
			last_drive=NOW(), 
			last_latitude='".SQL_CLEAN($_POST['lat'])."', 
			last_longitude='".SQL_CLEAN($_POST['lon'])."'
			where user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."' LIMIT 1");
	}
	else {
		// GOOGLE GEOCODE NEAREST ADDRESS
		$url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=".$_POST['lat'].",".$_POST['lon']."&sensor=true&key=AIzaSyAq8WuTeXonjSzYw_vVLiN7PCRQNqf_v_Q";

	    $ch = curl_init();
	    curl_setopt($ch, CURLOPT_URL, $url);
	    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	    $json_data = json_decode(curl_exec($ch), true);

		SQL_QUERY("update users set 
			last_drive=NOW(), 
			last_latitude='".SQL_CLEAN($_POST['lat'])."', 
			last_longitude='".SQL_CLEAN($_POST['lon'])."', 
			recent_latitude='".SQL_CLEAN($user_location[0]['last_latitude'])."', 
			recent_longitude='".SQL_CLEAN($user_location[0]['last_longitude'])."', 
			direction='".SQL_CLEAN($direction)."', 
			current_address='".SQL_CLEAN($json_data['results']['0']['formatted_address'])."' 
			where user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."' LIMIT 1");
	}

	SQL_QUERY("insert into user_locations (latitude,longitude,date_collected,user_id) values ('".SQL_CLEAN($_POST['lat'])."','".SQL_CLEAN($_POST['lon'])."',NOW(),'".SQL_CLEAN($_SESSION['user']['user_id'])."')");

	echo json_encode(array("lat"=>$_POST["lat"], "lon"=>$_POST["lon"], "user_id"=>$_SESSION["user_id"], "date_collected"=>$date, "direction" => $direction));

} else {
	if ($is_ajax) {
		echo json_encode(false);
	} else {
		header("location: /dashboard.php?code=1xdv7");
	}
}

?>
