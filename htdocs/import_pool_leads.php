<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

ini_set('auto_detect_line_endings',TRUE);
ini_set('post_max_size', "64M");

// phpinfo();
// die();
error_reporting(E_ERROR | E_WARNING | E_PARSE);

// temporarily disable
// if($_SESSION['user']['is_admin'] == 0)
// header("location: /dashboard.php");

if(isset($_GET['id'])) {

	// die(var_dump($_SESSION['pool']));
	$smarty->assign('id', $_GET['id']);
	$smarty->assign('pool', $_SESSION['pool']);
	$smarty->assign("footer_js", "includes/footers/import_pool_leads_footer.tpl");
	$smarty->display('import_pool_leads.tpl');

}
else
	exit;

?>
