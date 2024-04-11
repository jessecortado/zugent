<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

$sth = SQL_QUERY("
	select 
		* 
	from contacts_rel_users 
	where user_id='".SQL_CLEAN($_SESSION['user_id'])."' 
	and is_deleted != 1 
	and contact_id='".SQL_CLEAN($_POST['id'])."' 
	limit 1
");
if (SQL_NUM_ROWS($sth) == 0) {
	print "0";
	exit;
}

$sth = SQL_QUERY("update campaigns_rel_contacts set is_onhold=0 where contact_id='".SQL_CLEAN($_POST['id'])."' and campaign_id='".SQL_CLEAN($_POST['campaign'])."' limit 1");

// Add campaign log
add_user_log("Purchased a campaign (".$_POST['campaign'].")", "campaigns", array("importance" => "Info", "action" => "Purchase") );

print "1";
exit;

	
?>