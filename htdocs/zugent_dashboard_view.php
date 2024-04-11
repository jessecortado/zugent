<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth(true);

if ( $_SESSION['user']['company_id'] !== "1" )
    header("location: /dashboard");

$sth = SQL_QUERY("select u.*
	from users as u 
	where u.company_id='".SQL_CLEAN($_GET['id'])."'
    order by u.last_name ASC");
    
$users = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$users[] = $data;
}

$smarty->assign("company_id", $_SESSION['user']['company_id']);
$smarty->assign("users", $users);

$smarty->assign("footer_js", "includes/footers/zugent_dashboard_view.tpl");
$smarty->display('zugent_dashboard_view.tpl');

?>