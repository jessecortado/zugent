<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// CHECK IF LOCATION OF USER CHANGED
$sth = SQL_QUERY("select * from users 
	where user_id=".SQL_CLEAN($_SESSION['user_id'])."
");

// CHECK IF LOCATION OF USER CHANGED
$user_info = SQL_QUERY("select last_latitude, last_longitude from users where user_id='".SQL_CLEAN($_SESSION['user_id'])."' and is_active=1 limit 1");

$user_location = array();

while ($data = SQL_ASSOC_ARRAY($user_info)) {
	$user_location[] = $data;
}

if (!empty($user_location)) {
	if ($user_location[0]['last_latitude'] == $_POST['lat'] && $user_location[0]['last_longitude'] == $_POST['lon']) {
		// RETURN FALSE IF ARRAY IS EMPTY
		echo json_encode(false);
	}
	else {
		// RETURN TRUE IF ARRAY IS EMPTY
		echo json_encode(true);
	}
}
else {
	// RETURN TRUE IF ARRAY IS EMPTY
	echo json_encode(true);
}

?>