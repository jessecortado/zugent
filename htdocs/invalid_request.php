<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// auth();

if (isset($_GET['code'])) {
	if ($_GET['code'] == 'rax100') {
		$error_title = "Request not valid!";
	 	$error_msg = "Information sent is invalid";
	}
	elseif ($_GET['code'] == 'rax101') {
	 	$error_title = "Contact has already been assigned!";
	 	$error_msg = "An agent has already accepted this clients request";
	}
	// elseif ($_GET['code'] == 'rax102') {
	//  	$error_title = "";
	//  	$error_msg = "";
	// }
}
else {
 	$error_title = "";
 	$error_msg = "";
}


$smarty->assign("error_title", $error_title);
$smarty->assign("error_msg", $error_msg);

$smarty->display("invalid_request.tpl");
	
?>