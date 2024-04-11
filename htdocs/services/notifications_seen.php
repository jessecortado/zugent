<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

$sth = SQL_QUERY("
	update notifications set seen=1
		where user_id=".SQL_CLEAN($_SESSION['user_id'])."
");

echo json_encode($sth);
exit;

?>