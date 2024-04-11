<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth(true, false);

$smarty->assign('company', $_SESSION['company']);

if(isset($_POST['company_name'])) {
	$sth = SQL_QUERY("update companies set 
		company_name='".SQL_CLEAN($_POST['company_name'])."',
		email_footer_line_1='".SQL_CLEAN($_POST['email_footer_line_1'])."',
		email_footer_line_2='".SQL_CLEAN($_POST['email_footer_line_2'])."',
		phone_office='".SQL_CLEAN($_POST['phone_office'])."',
		city='".SQL_CLEAN($_POST['city'])."',
		street_address='".SQL_CLEAN($_POST['street_address'])."',
		state='".SQL_CLEAN($_POST['state'])."',
		zip='".SQL_CLEAN($_POST['zip'])."',
		timezone='".SQL_CLEAN($_POST['timezone'])."',
		phone_fax='".SQL_CLEAN($_POST['phone_fax'])."',
		allow_agents_email_logo='".SQL_CLEAN($_POST['allow_agents_email_logo'])."' 
		where company_id='".SQL_CLEAN($_POST['company_id'])."'");

	$sth = SQL_QUERY("select * from companies where company_id=".SQL_CLEAN($_POST['company_id']));
	$company_data = SQL_ASSOC_ARRAY($sth);
	$_SESSION['company'] = $company_data;

	$smarty->assign('company', $_SESSION['company']);
	$smarty->assign('display_message', TRUE);

}

$sth = SQL_QUERY("select * from appointment_types where company_id=".SQL_CLEAN($_SESSION['user']['company_id']));
$appointment_types = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$appointment_types[] = $data;
}

$sth = SQL_QUERY("select * from file_types where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and is_deleted=0 order by sequence, name ");
$file_types = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$file_types[] = $data;
}

$sth = SQL_QUERY("select * from company_variables where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])."");
$custom_strings = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$custom_strings[] = $data;
}

/* For Admin Card Details */
// User Editor
$sth = SQL_QUERY("select 
	t1.date_created, 
	concat(t2.first_name,' ',t2.last_name) as editor 
	from users as t1 left join users as t2 on t2.user_id = t1.created_by_user_id 
	where t1.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." order by t1.date_created desc");
$user_editor_data = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$user_editor_data[] = $data;
}
// Office Manager
$sth = SQL_QUERY("select * from offices where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." order by office_id desc");
$office_manager_data = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$office_manager_data[] = $data;
}
// Appointment Types
$sth = SQL_QUERY("select * from appointment_types where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." order by appointment_type_id desc");
$appointment_types_data = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$appointment_types_data[] = $data;
}
// File Types
$sth = SQL_QUERY("select concat(t2.first_name,' ',t2.last_name) as editor 
	from file_types as t1 left join users as t2 on t2.user_id = t1.user_id 
	where t1.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." order by t1.file_type_id desc");
$file_types_data = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$file_types_data[] = $data;
}
// Buckets
$sth = SQL_QUERY("select bucket_id from contact_buckets where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." order by bucket_id desc");
$buckets_data = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$buckets_data[] = $data;
}
// Custom Strings
$sth = SQL_QUERY("select 
	t1.date_modified, 
	concat(t2.first_name,' ',t2.last_name) as editor 
	from company_variables as t1 left join users as t2 on t2.user_id = t1.user_id 
	where t1.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." order by t1.date_modified desc");
$custom_strings_data = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$custom_strings_data[] = $data;
}
// Transaction Settings
$sth = SQL_QUERY("select transaction_type_id from transaction_type where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." union 
	select transaction_status_id from transaction_status where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." order by transaction_type_id desc");
$transaction_settings_data = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$transaction_settings_data[] = $data;
}
// Transaction Checklists
$sth = SQL_QUERY("select 
	CASE WHEN t1.modified_user_id != 0 THEN t1.date_modified ELSE t1.date_added END AS date, 
	concat(t2.first_name,' ',t2.last_name) as editor 
	from transaction_checklists as t1 left join users as t2 on (t2.user_id=t1.created_user_id and t1.modified_user_id=0) or (t2.user_id=t1.modified_user_id and t1.modified_user_id!=0)
	where t2.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." order by date desc");
$transaction_checklists_data = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$transaction_checklists_data[] = $data;
}
// Campaigns
$sth = SQL_QUERY("select concat(t2.first_name,' ',t2.last_name) as editor 
	from campaigns as t1 left join users as t2 on t2.user_id = t1.user_id 
	where t2.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." order by t1.campaign_id desc");
$campaigns_data = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$campaigns_data[] = $data;
}
// Companies for zugent portal
$sth = SQL_QUERY("select * 
	from companies");
$zugent_portal_data = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$zugent_portal_data[] = $data;
}


// echo '<pre>';
// print_r(count($campaigns_data));
// echo '<br>';
// print_r($campaigns_data);
// echo '</pre>';
// die('die testing: settings');


// die(var_dump(timezone_identifiers_list(2)));


$smarty->assign('timezones', get_timezones());
$smarty->assign('user_editor_data', array('count'=>count($user_editor_data),'date'=>$user_editor_data[0]['date_created'],'editor'=>$user_editor_data[0]['editor']));
$smarty->assign('file_types_data', array('count'=>count($file_types_data),'date'=>'','editor'=>$file_types_data[0]['editor']));
$smarty->assign('office_manager_data', array('count'=>count($office_manager_data)));
$smarty->assign('appointment_types_data', array('count'=>count($appointment_types_data)));
$smarty->assign('buckets_data', array('count'=>count($buckets_data)));
$smarty->assign('custom_strings_data', array('count'=>count($custom_strings_data),'date'=>$custom_strings_data[0]['date_modified'],'editor'=>$custom_strings_data[0]['editor']));
$smarty->assign('transaction_settings_data', array('count'=>count($transaction_settings_data)));
$smarty->assign('transaction_checklists_data', array('count'=>count($transaction_checklists_data),'date'=>$transaction_checklists_data[0]['date'],'editor'=>$transaction_checklists_data[0]['editor']));
$smarty->assign('campaigns_data', array('count'=>count($campaigns_data),'editor'=>$campaigns_data[0]['editor']));
$smarty->assign('zugent_portal_data', array('count'=>(count($zugent_portal_data)-1),'editor'=>"Zugent"));
$smarty->assign('custom_strings', $custom_strings);
$smarty->assign('appointment_types', $appointment_types);
$smarty->assign('file_types', $file_types);
$smarty->assign("footer_js", "includes/footers/settings.tpl");
$smarty->display('settings.tpl');

?>