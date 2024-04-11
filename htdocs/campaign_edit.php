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


if (isset($_POST['action']) && $_POST['action'] == "s") {
	$sql = "
		UPDATE campaigns SET 
			campaign_name='".SQL_CLEAN($_POST['campaign_name'])."'
			, shared_level='".SQL_CLEAN($_POST['shared_level'])."'
			, description='".SQL_CLEAN($_POST['description'])."'
	";

	if (isset($_POST['is_base']) && $_POST['is_base']) {
		$sql  .= ", is_base=1";
	} else {
		$sql  .= ", is_base=0";
	}

	if (isset($_POST['is_copyable']) && $_POST['is_copyable']) {
		$sql  .= ", is_copyable=1";
	} else {
		$sql  .= ", is_copyable=0";
	}
	
	$sql .= "	
		WHERE campaign_id='".SQL_CLEAN($_REQUEST['id'])."' limit 1
	";
	SQL_QUERY($sql);
	header("location: /campaign_edit.php?id=".$campaign['campaign_id']);
	exit;
}


$events = array();

$sth = SQL_QUERY("select * from campaign_events where campaign_id='".SQL_CLEAN($_REQUEST['id'])."' order by send_after_days");
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$data['date_modified'] = convert_to_local($data['date_modified']);
	$events[] = $data;
}


$campaign_downloads = array();
$sth = SQL_QUERY("select cd.*,u.first_name,u.last_name from campaign_downloads as cd left join users as u on u.user_id=cd.user_id where cd.campaign_id='".SQL_CLEAN($_REQUEST['id'])."'");
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$campaign_downloads[] = $data;
}


$sth = SQL_QUERY("select * from campaign_variables where campaign_id=".SQL_CLEAN($_REQUEST['id'])."");
$custom_strings = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$custom_strings[] = $data;
}

$smarty->assign('custom_strings', $custom_strings);
$smarty->assign('campaign_id', $_REQUEST['id']);
$smarty->assign('campaign_downloads', $campaign_downloads);
$smarty->assign('campaign', $campaign);
$smarty->assign('events', $events);

$smarty->display('campaign_edit.tpl');


	
?>