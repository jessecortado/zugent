<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth(TRUE);


// Campaigns
$sth = SQL_QUERY("
	select *
	from contacts_rel_users as cu
	left join contacts as c on c.contact_id=cu.contact_id
	left join campaigns_rel_contacts as cc on cc.contact_id=cu.contact_id
	left join campaign_event_rel_contacts as cec on cec.contact_id=cu.contact_id
	left join campaign_events as ce on ce.campaign_event_id=cec.campaign_event_id
	left join campaigns as camp on camp.campaign_id=ce.campaign_id
	where cu.user_id='".SQL_CLEAN($_SESSION['user_id'])."' and cc.is_onhold != 1 and cc.is_completed != 1
	group by ce.campaign_event_id
	");

$campaigns = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$campaigns[] = $data;
}

// Campaign Messages
$sth2 = SQL_QUERY("
	select *
	from contacts_rel_users as cu
	left join contacts as c on c.contact_id=cu.contact_id
	left join campaigns_rel_contacts as cc on cc.contact_id=cu.contact_id
	left join campaign_event_rel_contacts as cec on cec.contact_id=cu.contact_id
	left join campaign_events as ce on ce.campaign_event_id=cec.campaign_event_id
	left join campaigns as camp on camp.campaign_id=ce.campaign_id
	where cu.user_id='".SQL_CLEAN($_SESSION['user_id'])."' and cc.is_onhold != 1 and cc.is_completed != 1
	");

$campaign_messages = array();
while ($data = SQL_ASSOC_ARRAY($sth2)) {
	$campaign_messages[] = $data;
}

$smarty->assign('campaigns', $campaigns);
$smarty->assign('campaign_messages', $campaign_messages);
$smarty->assign('total_campaign_messages', SQL_NUM_ROWS($sth2));

// $smarty->assign('footer_js', 'includes/footers/file_types_footer.tpl');
$smarty->display('campaign_message.tpl');

?>