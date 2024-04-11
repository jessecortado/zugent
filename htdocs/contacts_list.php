<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

// Start
$contacts_count = 0;
$contacts = array();
$filtered = true;

$sth = SQL_QUERY("
	select
	count(cu.contact_id) as total_campaigns
	from contacts_rel_users as cu
	left join campaigns_rel_contacts as cc on cc.contact_id=cu.contact_id
	where cu.user_id='".SQL_CLEAN($_SESSION['user_id'])."' and is_onhold != 1 and is_completed != 1
	");
list($total_campaigns) = SQL_ROW($sth);
$smarty->assign('total_campaigns', $total_campaigns);


$sth = SQL_QUERY("
	select
	count(*) as total_messages
	from contacts_rel_users as cu
	left join campaigns_rel_contacts as cc on cc.contact_id=cu.contact_id
	left join campaign_event_rel_contacts as cec on cec.contact_id=cu.contact_id
	where cu.user_id='".SQL_CLEAN($_SESSION['user_id'])."' and is_onhold != 1 and is_completed != 1
	");
list($total_messages) = SQL_ROW($sth);
$smarty->assign('total_messages', $total_messages);


// Place Before assigning to variable
require_once($_SERVER['SITE_DIR']."/includes/sub_pages.php");

$smarty->assign('contacts', $contacts);

$smarty->assign('total_count', $contacts_count);

$smarty->assign('user', $_SESSION['user']);

$smarty->assign('footer_js', 'includes/footers/dashboard.tpl');

$smarty->display('contacts_list.tpl');

?>