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

$sth = SQL_QUERY("select * from campaigns where campaign_id='".SQL_CLEAN($_REQUEST['id'])."' and user_id='".SQL_CLEAN($_SESSION['user_id'])."' limit 1");
if (SQL_NUM_ROWS($sth) == 0) {
	header("location: /campaign_list.php");
	exit;	
}

$campaign = SQL_ASSOC_ARRAY($sth);


if (isset($_REQUEST['action']) && $_REQUEST['action'] == 'n') {
	print_r($_REQUEST);
	// $sql = "
	// 	INSERT into campaign_events SET
	// 		appointment_trigger_column='".SQL_CLEAN($_REQUEST['appointment_trigger_column'])."'
	// 		, date_created=now()
	// 		, date_modified=now()
	// 		, appointment_trigger_type='".SQL_CLEAN($_REQUEST['appointment_trigger_type'])."'
	// 		, appointment_trigger_value='".SQL_CLEAN($_REQUEST['appointment_trigger_value'])."'
	// 		, send_after_days=".INTVAL(SQL_CLEAN($_REQUEST['send_after_days']))."
	// 		, user_id='".SQL_CLEAN($_SESSION['user_id'])."'
	// 		, event_subject='".SQL_CLEAN($_REQUEST['event_subject'])."'
	// 		, event_name='".SQL_CLEAN($_REQUEST['event_name'])."'
	// 		, event_body='".SQL_CLEAN($_REQUEST['event_body'])."'
	// 		, campaign_id='".SQL_CLEAN($_REQUEST['id'])."'
	// ";
	$sql = "
		INSERT into campaign_events SET
			date_created=now()
			, date_modified=now()
			, send_after_days=".INTVAL(SQL_CLEAN($_REQUEST['send_after_days']))."
			, user_id='".SQL_CLEAN($_SESSION['user_id'])."'
			, event_subject='".SQL_CLEAN($_REQUEST['event_subject'])."'
			, event_name='".SQL_CLEAN($_REQUEST['event_name'])."'
			, event_body='".SQL_CLEAN($_REQUEST['event_body'])."'
			, campaign_id='".SQL_CLEAN($_REQUEST['id'])."'
	";

//echo "<pre>";
//print_r($_POST);
//echo "</pre>";
//die('TESTING POST');

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

	SQL_QUERY($sql);
	$id = SQL_INSERT_ID();
	header("location: /campaign_edit_event.php?id=".$id);
	exit;
}


$smarty->assign('campaign', $campaign);

$smarty->display('campaign_new_event.tpl');


	
?>