<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('campaigns');

auth();

// Shared_level
// ------------
// 0 = User Only
// 1 = Company Wide
// 2 = Global

$sth = SQL_QUERY("
	select
		c.*
		, u.first_name
		, u.last_name
		, u.company_id
	from campaigns as c
	left join users as u on c.user_id=u.user_id
	where
		(u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and shared_level=2)
		or c.user_id='".SQL_CLEAN($_SESSION['user_id'])."'
	order by c.campaign_name
");

$global_campaigns = array();
$company_campaigns = array();
$my_campaigns = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {

	$sth_campaign_event = SQL_QUERY("select count(*) as events_count, max(send_after_days) as max from campaign_events where campaign_id=".$data['campaign_id']);
	$temp = SQL_ASSOC_ARRAY($sth_campaign_event);
	$data["events_count"] = $temp["events_count"];
	$data["max"] = $temp["max"];

	if ($data['shared_level'] == 3) 
		$global_campaigns[] = $data;
	if ($data['company_id'] == $_SESSION['user']['company_id'] && $data['shared_level'] == 2) 
		$company_campaigns[] = $data;
	if ($data['user_id'] == $_SESSION['user_id']) 
		$my_campaigns[] = $data;

}

$smarty->assign('global_campaigns', $global_campaigns);
$smarty->assign('company_campaigns', $company_campaigns);
$smarty->assign('my_campaigns', $my_campaigns);

$smarty->display('campaign_list.tpl');


	
?>