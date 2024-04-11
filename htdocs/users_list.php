<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth(true);

$sth = SQL_QUERY("select u.*, UNIX_TIMESTAMP(u.last_drive) as unixtime_lastdrive 
	from users as u 
	where u.company_id='".$_SESSION['user']['company_id']."'
	and is_active='1' order by u.last_name ASC");
$users = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$users[] = $data;
}

$sth = SQL_QUERY("select u.*
	from users as u 
	where u.company_id='".$_SESSION['user']['company_id']."'
	and is_active=0 order by u.last_name ASC");
$inactive_users = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$inactive_users[] = $data;
}

$smarty->assign("company_id", $_SESSION['user']['company_id']);
$smarty->assign("inactive_users", $inactive_users);
$smarty->assign("users", $users);

$smarty->assign("footer_js", "includes/footers/user_list_footer.tpl");
$smarty->display('users_list.tpl');

?>