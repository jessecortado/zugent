<?php 
/**
* @name mob_update_agent_position.php
* @desc mobile version of "update_agent_position"
* @author [name] <[<email address>]>
* @author [Joy Victoria] <[<jvictoria@zugent.com>]> 
* @date May 2018
*/
include_once('mob_get_json.php');

if (isset($_POST['agent_id'])) {
	$sth = SQL_QUERY("select u.user_id, u.last_latitude, u.last_longitude, u.phone_mobile, u.first_name, u.last_name, u.phone_mobile, u.email from users as u where u.user_id=".SQL_CLEAN($_POST['agent_id']));
	$data = SQL_ASSOC_ARRAY($sth);
	echo json_encode(array("lat" => $data['last_latitude'], "lon" => $data['last_longitude']));
}
?>