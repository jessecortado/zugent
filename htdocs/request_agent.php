<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

if(isset($_GET['code']) && $_GET['code'] == '1x007') {
	$smarty->assign("display_error_message", TRUE);
}

$smarty->display('request_agent.tpl');
	
?>