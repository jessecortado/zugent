<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");


$sth = SQL_QUERY("select * from message_pages where message_page_id='".SQL_CLEAN($_REQUEST['a'])."' and page_code='".SQL_CLEAN($_REQUEST['b'])."' limit 1");
if (SQL_NUM_ROWS($sth) == 0) {
	header("location: /");
	exit;
}
$data = SQL_ASSOC_ARRAY($sth);
$smarty->assign('spage', $data);

$smarty->display('spage.tpl');


	
?>