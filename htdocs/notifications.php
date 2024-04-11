<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

$sth = SQL_QUERY("
	select n.*, UNIX_TIMESTAMP(n.date_created) as unixtime_created from notifications as n where user_id=".SQL_CLEAN($_SESSION['user_id'])." order by n.date_created DESC
");

$notifications = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$notifications[] = $data;
}

$smarty->assign('notifs', $notifications);
$smarty->display('notifications.tpl');

?>