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
	from campaigns_rel_contacts as crc
	left join campaigns as camp on camp.campaign_id=crc.campaign_id
	left join contacts_rel_users as cru on cru.contact_id=crc.contact_id
	where cru.user_id='".SQL_CLEAN($_SESSION['user_id'])."' and crc.is_onhold != 1 and crc.is_completed != 1
	group by crc.campaign_id
	");

$campaigns = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$campaigns[] = $data;
}

// Contacts
$sth2 = SQL_QUERY("
	select c.*, crc.campaign_id, crc.date_added
	from campaigns_rel_contacts as crc
	left join campaigns as camp on camp.campaign_id=crc.campaign_id
	left join contacts_rel_users as cru on cru.contact_id=crc.contact_id
	left join contacts as c on c.contact_id=crc.contact_id
	where cru.user_id='".SQL_CLEAN($_SESSION['user_id'])."' and crc.is_onhold != 1 and crc.is_completed != 1
	");

$campaign_contacts = array();
while ($data = SQL_ASSOC_ARRAY($sth2)) {
	$campaign_contacts[] = $data;
}

$smarty->assign('campaigns', $campaigns);
$smarty->assign('campaign_contacts', $campaign_contacts);
// $smarty->assign('total_campaign_contacts', SQL_NUM_ROWS($sth2));

$smarty->display('campaign_active.tpl');

?>