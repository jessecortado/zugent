<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// if(empty($_SERVER['HTTPS']) || $_SERVER['HTTPS'] == 'off') {
// 	$redirect = 'https://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
// 	header('HTTP/1.1 301 Mover Permanently');
// 	header('Location: ' . $redirect);
// 	exit();
// }

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();


function calc_distance($lat1, $lon1, $lat2, $lon2, $unit) {

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

// AGENT REQUESTS
$list_agent = SQL_QUERY("select u.* from users as u ".
	"where u.last_drive != '' and ".
	"u.company_id = '".$_SESSION['user']['company_id']."' and ".
	"u.user_id != '".$_SESSION['user']['user_id']."' ".
	"order by u.last_drive desc");

$agents = array();

while ($data = SQL_ASSOC_ARRAY($list_agent)) {
	$data['distance'] = calc_distance($_SESSION['user']['last_latitude'], $_SESSION['user']['last_longitude'], $data['last_latitude'], $data['last_longitude'], 'M');
	$agents[] = $data;
}


// echo "<pre>";
// print_r($agents);
// echo "</pre>";
// die("asdasdasd");


$smarty->assign('agents', $agents);
$smarty->assign('user_latitude', $_SESSION['user']['last_latitude']);
$smarty->assign('user_longitude', $_SESSION['user']['last_longitude']);

$smarty->assign('footer_js', 'includes/footers/drive_spoof_footer.tpl');

$smarty->display('drive_spoof.tpl');

?>