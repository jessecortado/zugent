<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
	
	// Add campaign log
	add_user_log("Logged out", "login", array("importance" => "Info") );

session_destroy();

//if cookie[rememberme] is set reset value
if (isset($_COOKIE['RS5B8XNrwmgHy4VR'])) {
	$days = 30;
	setcookie ("RS5B8XNrwmgHy4VR","", time() + (86400 * $days), "/");
}

header("location: /");
exit;

	
?>