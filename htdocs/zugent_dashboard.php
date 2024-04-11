<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}


auth(true);

if ( $_SESSION['user']['company_id'] !== "1" )
    header("location: /dashboard");
    
// $sth = SQL_QUERY("select u.*
// 	from users as u 
// 	where u.company_id='".$_SESSION['user']['company_id']."'
// 	and is_active='1' order by u.last_name ASC");
// $users = array();

// while ($data = SQL_ASSOC_ARRAY($sth)) {
// 	$users[] = $data;
// }

// $sth = SQL_QUERY("select u.*
// 	from users as u 
// 	where u.company_id='".$_SESSION['user']['company_id']."'
// 	and is_active=0 order by u.last_name ASC");
// $inactive_users = array();

// while ($data = SQL_ASSOC_ARRAY($sth)) {
// 	$inactive_users[] = $data;
// }

// $smarty->assign("company_id", $_SESSION['user']['company_id']);
// $smarty->assign("inactive_users", $inactive_users);
// $smarty->assign("users", $users);// $sth = SQL_QUERY("select u.*
// 	from users as u 
// 	where u.company_id='".$_SESSION['user']['company_id']."'
// 	and is_active='1' order by u.last_name ASC");
// $users = array();

// while ($data = SQL_ASSOC_ARRAY($sth)) {
// 	$users[] = $data;
// }

// $sth = SQL_QUERY("select u.*
// 	from users as u 
// 	where u.company_id='".$_SESSION['user']['company_id']."'
// 	and is_active=0 order by u.last_name ASC");
// $inactive_users = array();

// while ($data = SQL_ASSOC_ARRAY($sth)) {
// 	$inactive_users[] = $data;
// }

// $smarty->assign("company_id", $_SESSION['user']['company_id']);
// $smarty->assign("inactive_users", $inactive_users);
// $smarty->assign("users", $users);

$sth = SQL_QUERY("select c.*, COUNT(u.company_id) as active_users_count from companies as c 
                    left join users u on c.company_id=u.company_id group by c.company_id");
    
$companies = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$companies[] = $data;
}

$smarty->assign("companies", $companies);
$smarty->assign("footer_js", "includes/footers/zugent_dashboard.tpl");
$smarty->display('zugent_dashboard.tpl');

?>