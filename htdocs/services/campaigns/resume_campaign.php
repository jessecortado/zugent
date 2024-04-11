<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xcp7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);

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
	echo json_encode(array('msg'=>"User Not Related"));
	exit;
}

$sth = SQL_QUERY("update campaigns_rel_contacts set is_onhold=0 where contact_id='".SQL_CLEAN($_POST['id'])."' and campaign_id='".SQL_CLEAN($_POST['campaign'])."' limit 1");

echo json_encode(array('msg'=>true));

?>