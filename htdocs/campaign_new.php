<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('campaigns');

auth();


if (isset($_POST['campaign_name']) && trim($_POST['campaign_name']) != '') {
	$sth = SQL_QUERY("
		select
			c.*
			, u.first_name
			, u.last_name
			, u.company_id
		from campaigns as c
		left join users as u on c.user_id=u.user_id
		where
			c.user_id='".SQL_CLEAN($_SESSION['user_id'])."'
			and c.campaign_name='".SQL_CLEAN($_POST['campaign_name'])."'
		order by c.campaign_name
	");
	if (SQL_NUM_ROWS($sth) != 0) {
		header("location: /campaign_new.php?err=8x00");
		exit;
	}
	SQL_QUERY("insert into campaigns (campaign_name,shared_level,user_id) values ('".SQL_CLEAN($_POST['campaign_name'])."',0,'".SQL_CLEAN($_SESSION['user_id'])."')");
	$id = SQL_INSERT_ID();
	header("location: /campaign_edit.php?id=".$id);
	exit;
}



$smarty->display('campaign_new.tpl');


	
?>