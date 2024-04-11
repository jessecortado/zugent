<?php
require_once($_SERVER['SITE_DIR']."/includes/common.php");

if ($_GET['id'] > 0 && $_GET['c'] > 0) {
	$sth = SQL_QUERY("select * from campaign_event_rel_contacts where campaign_event_id='".SQL_CLEAN($_GET['id'])."' and contact_id='".SQL_CLEAN($_GET['c'])."' and is_opened != 1 limit 1");
	if (SQL_NUM_ROWS($sth) > 0) {
		SQL_QUERY("update campaign_event_rel_contacts set is_opened=1,date_opened=NOW() where campaign_event_id='".SQL_CLEAN($_GET['id'])."' and contact_id='".SQL_CLEAN($_GET['c'])."' and is_opened != 1 limit 1");
		SQL_QUERY("update contacts set last_opened_event_id='".SQL_CLEAN($_GET['id'])."', date_last_opened_event=NOW() where contact_id='".SQL_CLEAN($_GET['c'])."' limit 1");
	}
}

header('Content-Type: image/png');
$src = $_SERVER['SITE_DIR']."/htdocs/assets/img/transparent/black-0.3.png";
readfile($src);
	
?>