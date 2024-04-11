<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

header("location: /dashboard.php"); // REDIRECT THIS PAGE TO DASHBOARD TEMPORARILY

if(empty($_SERVER['HTTPS']) || $_SERVER['HTTPS'] == 'off') {
	$redirect = 'https://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
	header('HTTP/1.1 301 Mover Permanently');
	header('Location: ' . $redirect);
	exit();
}

check_company_page_access('drive');

auth(false, true);

$smarty->assign('footer_js', 'includes/footers/find_agent_footer.tpl');
$smarty->display('find_agent.tpl');

?>