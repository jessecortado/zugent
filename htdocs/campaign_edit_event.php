<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('campaigns');

auth();

if (!isset($_REQUEST['id']) || $_REQUEST['id'] == '') {
	header("location: /campaign_list.php");
	exit;
}

$custom_strings = array();
$sth = SQL_QUERY("select var_key from company_variables where company_id='".SQL_CLEAN($_SESSION['company']['company_id'])."' order by var_key");
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$custom_strings[] = $data['var_key'];
}
$smarty->assign('custom_strings', $custom_strings);

$sth = SQL_QUERY("select * from campaign_events where campaign_event_id='".SQL_CLEAN($_REQUEST['id'])."' LIMIT 1");
if (SQL_NUM_ROWS($sth) == 0) {
	header("location: /campaign_list.php");
	exit;
}
$event = SQL_ASSOC_ARRAY($sth);

$sth = SQL_QUERY("select * from campaigns where campaign_id='".SQL_CLEAN($event['campaign_id'])."' and user_id='".SQL_CLEAN($_SESSION['user_id'])."' limit 1");
if (SQL_NUM_ROWS($sth) == 0) {
	header("location: /campaign_list.php");
	exit;	
}
$campaign = SQL_ASSOC_ARRAY($sth);

$sth = SQL_QUERY("select * from campaign_variables where campaign_id=".SQL_CLEAN($event['campaign_id'])."");
$custom_strings = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$custom_strings[] = $data;
}


if (isset($_REQUEST['action']) && $_REQUEST['action'] == 'n') {
	print_r($_REQUEST);
	// $sql = "
	// 	UPDATE campaign_events SET
	// 		appointment_trigger_column='".SQL_CLEAN($_REQUEST['appointment_trigger_column'])."'
	// 		, appointment_trigger_type='".SQL_CLEAN($_REQUEST['appointment_trigger_type'])."'
	// 		, appointment_trigger_value='".SQL_CLEAN($_REQUEST['appointment_trigger_value'])."'
	// 		, send_after_days=".INTVAL(SQL_CLEAN($_REQUEST['send_after_days']))."
	// 		, user_id='".SQL_CLEAN($_SESSION['user_id'])."'
	// 		, event_subject='".SQL_CLEAN($_REQUEST['event_subject'])."'
	// 		, event_name='".SQL_CLEAN($_REQUEST['event_name'])."'
	// 		, event_body='".SQL_CLEAN($_REQUEST['event_body'])."'
	// 		, date_modified=now()
	// ";
	$sql = "
		UPDATE campaign_events SET 
			send_after_days=".INTVAL(SQL_CLEAN($_REQUEST['send_after_days']))."
			, user_id='".SQL_CLEAN($_SESSION['user_id'])."'
			, event_subject='".SQL_CLEAN($_REQUEST['event_subject'])."'
			, event_name='".SQL_CLEAN($_REQUEST['event_name'])."'
			, event_body='".SQL_CLEAN($_REQUEST['event_body'])."'
			, date_modified=now()
	";
	if (isset($_REQUEST['is_event_appointment_triggered'])) {
		$sql .= ", is_event_appointment_triggered=1";
	} else {
		$sql .= ", is_event_appointment_triggered=0";
	}
	if (isset($_REQUEST['is_event_to_user'])) {
		$sql .= ", is_event_to_user=1";
	} else {
		$sql .= ", is_event_to_user=0";
	}
	if (isset($_REQUEST['is_event_to_client'])) {
		$sql .= ", is_event_to_client=1";
	} else {
		$sql .= ", is_event_to_client=0";
	}
	if (isset($_REQUEST['is_starting_event'])) {
		$sql .= ", is_starting_event='".SQL_CLEAN($_REQUEST['is_starting_event'])."'";
	} else {
		$sql .= ", is_starting_event=0";
	}
	$sql .= " where campaign_event_id='".SQL_CLEAN($_REQUEST['id'])."' limit 1";
	SQL_QUERY($sql);
	header("location: /campaign_edit_event.php?id=".$event['campaign_event_id']);
	exit;
}

$smarty->assign('custom_strings', $custom_strings);
$smarty->assign('campaign', $campaign);
$smarty->assign('event', $event);

$smarty->display('campaign_edit_event.tpl');

?>