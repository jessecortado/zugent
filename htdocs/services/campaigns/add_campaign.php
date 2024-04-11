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

// Check if user is related to contact
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

// Check if campaign already linked to contact
$sth = SQL_QUERY("select * from campaigns_rel_contacts where contact_id='".SQL_CLEAN($_POST['id'])."' and campaign_id='".SQL_CLEAN($_POST['campaign'])."' limit 1");

if (SQL_NUM_ROWS($sth) != 0) {
	echo json_encode(array('msg'=>"Already Exists"));
	exit;
}

SQL_QUERY("
	insert into campaigns_rel_contacts 
	(
		user_id
		, contact_id
		, date_added
		, campaign_id
	) values (
		'".SQL_CLEAN($_SESSION['user_id'])."'
		, '".SQL_CLEAN($_POST['id'])."'
		, NOW()
		, '".SQL_CLEAN($_POST['campaign'])."'
	)
");

$campaign_contact_id = SQL_INSERT_ID();
	
// Add campaign log
add_user_log("Added a campaign (".$campaign_id.")", "campaigns", array("importance" => "Info", "action" => "Add") );

//Get Recently Added Data
$sth3 = SQL_QUERY("select crc.*, cmp.campaign_name from campaigns_rel_contacts as crc 
	left join campaigns as cmp on cmp.campaign_id=crc.campaign_id 
	where crc.campaign_contact_id='".SQL_CLEAN($campaign_contact_id)."' limit 1");

$recently_added_data = array();

while($data = SQL_ASSOC_ARRAY($sth3)) {
	$recently_added_data[] = $data;
}

echo json_encode(array('msg'=>true, 'data'=>$recently_added_data));

?>