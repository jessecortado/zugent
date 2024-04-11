<?php
/**
 * @name: mob_get_json
 * @desc required header for each php file to return proper json data. 
 * @date June 2018
 * @author [Joy Victoria] <[<jvictoria@zugent.com>]>
 */
require_once($_SERVER['SITE_DIR']."/htdocs/services/send_sms.php");
header('Access-Control-Allow-Origin: *');

try {
	$inputJSON = file_get_contents('php://input');

	if (!isset($_POST['latitude']) && !isset($_GET['request'])) {
		$_POST = json_decode($inputJSON, TRUE);
	}
	else {
		echo json_encode("404");
	}
} catch (EXCEPTION $e) {
	echo json_encode($e);
}
?>