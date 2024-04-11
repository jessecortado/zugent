<?php
require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");


if ($_REQUEST['uid'] > 0 && $_REQUEST['cid'] > 0 && $_REQUEST['caid'] > 0) {
	
	$sth = SQL_QUERY("select * from campaign_event_rel_contacts where contact_id='".SQL_CLEAN($_REQUEST['uid'])."' and campaign_event_contact_id='".SQL_CLEAN($_REQUEST['cid'])."' and campaign_id='".SQL_CLEAN($_REQUEST['caid'])."' limit 1");
	if (SQL_NUM_ROWS($sth) != 1) {
		print "<h1>Error 404: File not found</h1>";
		exit;
	}
	$cdata = SQL_ASSOC_ARRAY($sth);
	
	SQL_QUERY("update campaign_event_rel_contacts set date_response=NOW(),response='".SQL_CLEAN($_REQUEST['response'])."' where campaign_event_contact_id='".SQL_CLEAN($_REQUEST['cid'])."' limit 1");
	header("location: /event_response.php");
	exit;
}

$smarty->display('event_response.tpl');

exit;
?>