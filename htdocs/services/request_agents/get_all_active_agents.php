<?php 

// require_once($_SERVER['SITE_DIR']."/htdocs/services/send_sms.php");
require_once($_SERVER['SITE_DIR']."/includes/common.php");

header('Access-Control-Allow-Origin: *');


if (isset($_POST['all_agents'])) {
	
	$agents = array();
	$least_distance = array();
	$temp = array();

	if ($_POST['check_in_duration'] != "") {
		$check_in_duration = $_POST['check_in_duration'];
	}
	else {
		$check_in_duration = "6 HOUR";
	}


	// $sth = SQL_QUERY("select DISTINCT u.user_id, u.is_profile_photo, u.first_name, u.last_name, 
	// 	u.last_latitude, u.last_longitude, u.phone_mobile, comp.company_name 
	// 	from users as u 
	// 	left join companies as comp on u.company_id=comp.company_id 
	// 	where u.is_active = 1 and (u.last_latitude != '' and u.last_longitude != '')
	// 	and u.user_id != ".$_SESSION['user']['user_id']."");

	$sth = SQL_QUERY("select DISTINCT u.user_id, u.is_profile_photo, u.first_name, u.last_name, 
		u.last_latitude, u.last_longitude, u.phone_mobile, comp.company_name 
		from users as u 
		left join companies as comp on u.company_id=comp.company_id 
		where u.is_active = 1 and (u.last_latitude != '' and u.last_longitude != '') 
		and (u.last_drive > DATE_SUB(NOW(), INTERVAL ".$check_in_duration.") or u.is_perm_drive = 1) 
		and u.user_id != ".$_SESSION['user']['user_id']."");

	// die(print_r($sth));

	while($data = SQL_ASSOC_ARRAY($sth)) {
		$agents[] = $data;
	}

	// echo "<pre>";
	// print_r(array("error" => false, "count" => count($agents), "agents" => $agents));
	// echo "</pre>";
	// die('TESTING');

	echo json_encode(array("error" => false, "count" => count($agents), "agents" => $agents));

}
else {
	header("location: /dashboard.php?code=1x007");
}

?>