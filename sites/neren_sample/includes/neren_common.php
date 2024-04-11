<?php
require_once($_SERVER['SITE_DIR'].'/includes/PHPMailer/PHPMailerAutoload.php');
require_once($_SERVER['SITE_DIR']."/includes/db.php");
require_once($_SERVER['SITE_DIR']."/includes/smarty/libs/Smarty.class.php");

SQL_CONNECT("crm.ruopen.com","zugent","L8rJuyakdsd82");
global $smarty;

$smarty = new Smarty();
$smarty->compile_check = true;

$smarty->template_dir = $_SERVER['SITE_DIR']."/sites/neren_sample/templates/";
$smarty->compile_dir = $_SERVER['SITE_DIR']."/sites/neren_sample/templates_c/";
$smarty->plugins_dir = array($_SERVER['SITE_DIR']."/includes/smarty/libs/plugins",$_SERVER['SITE_DIR']."/includes/smarty_plugins");	

session_start();

function geocode($address) {
	// https://developers.google.com/maps/documentation/geocoding/start
	$api_key = "AIzaSyDRBXks6G9tzZrO6nfBWRWMzTUlBgZ9EwY";
	$url = "https://maps.googleapis.com/maps/api/geocode/json?address=".urlencode($address)."&sensor=false&key=".$api_key;
	$data = file_get_contents($url);
    $json = json_decode($data);
    if (isset($json->results[0]->formatted_address)) return array($json->results[0]->geometry->location->lat,  $json->results[0]->geometry->location->lng);
    return false;
}

?>