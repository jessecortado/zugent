<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

$assign_data = contact_viewable($_REQUEST['id']);

$sth = SQL_QUERY("
	select
		cc.campaign_event_contact_id
		, cc.campaign_event_id
		, cc.date_sent
		, cc.is_error
		, cc.error_text
		, ce.event_name
		, cc.is_opened
		, cc.date_opened
	from campaign_event_rel_contacts as cc
	left join campaign_events as ce on ce.campaign_event_id=cc.campaign_event_id
	where cc.contact_id='".SQL_CLEAN($_REQUEST['id'])."' and cc.campaign_id='".SQL_CLEAN($_REQUEST['c'])."'
	order by date_sent DESC
");
$history = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$history[] = $data;
}
$smarty->assign('history', $history);

$sth = SQL_QUERY("select * from campaigns where campaign_id='".SQL_CLEAN($_REQUEST['c'])."' limit 1");
if (SQL_NUM_ROWS($sth) == 0) {
	exit;
} else {
	$campaign_data = SQL_ASSOC_ARRAY($sth);
	$smarty->assign('campaign_data', $campaign_data);
}

$sth = SQL_QUERY("
	select 
		*
	from contacts
	where contact_id='".SQL_CLEAN($_REQUEST['id'])."'
	limit 1
");
if (SQL_NUM_ROWS($sth) == 0) {
	header("location: /dashboard.php");
}
$contact_data = SQL_ASSOC_ARRAY($sth);
$smarty->assign('contact_data', $contact_data);


$smarty->display('contact_campaign_history.tpl');


	
?>