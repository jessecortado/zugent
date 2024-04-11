<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/includes/contact_send_email.php");
require_once($_SERVER['SITE_DIR']."/includes/send_letter.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

$data = array(
	"code" => '1x0c7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'contacts',
	"main_table_field" => 'contact_id',
	"main_field_value" => $_REQUEST['id'],
	"table_join_name" => 'contacts_rel_users',
	"table_join_field" => 'contact_id',
	"additional_where" => array(
		"t1.contact_id" => $_REQUEST['id'],
		"t1.company_id" => $_SESSION['user']['company_id'],
		"t2.user_id" => $_SESSION['user']['user_id'],
		"t2.contact_id" => $_REQUEST['id'],
		"t2.is_deleted!" => '1'
		)
);

auth_process($data);

if(isset($_GET['pool_lead']) && $_GET['pool_lead'] == "true") {
	$smarty->assign("show_pool_claimed", "true");
}
else {
	$smarty->assign("show_pool_claimed", "false");
}

$assign_data = contact_viewable($_REQUEST['id']);

SQL_QUERY("update contacts_rel_users set date_viewed=NOW() where user_id='".SQL_CLEAN($_SESSION['user_id'])."' and contact_id='".SQL_CLEAN($_REQUEST['id'])."' limit 1");

$sth = SQL_QUERY("
	select
		*
	from contacts
	where contact_id='".SQL_CLEAN($_REQUEST['id'])."'
	limit 1
");
if (SQL_NUM_ROWS($sth) == 0) {
	header("location: /dashboard.php");
}

$contact_data = SQL_ASSOC_ARRAY($sth);

// For Progress bar (Time To Action)
if ($contact_data['date_defined_timetoaction']) {
	if ($start > $end)
		$contact_data['progress_percentage'] = "100";
	else {
		$start = strtotime($contact_data['date_defined_timetoaction']);
		$end = strtotime($contact_data['date_due_timetoaction']);
		// die ($contact_data['date_defined_timetoaction']. " and ". $end);
		$current = strtotime(date("Y-m-d H:i:s"));
		if ($current == $start) {
			$contact_data['progress_percentage'] = "0";
			$contact_data['progress_message'] = date_difference(date("Y-m-d H:i:s", $start), date("Y-m-d H:i:s", $end)) . " left";
		}
		else {
			// die(round((($current - $start) / ($end - $start)) * 100));
			$contact_data['progress_percentage'] = round((($current - $start) / ($end - $start)) * 100);
			// die("End: ".$end . " <br>start: " . $start . "<br>current: ".$current."<br>defined: ".$contact_data['date_defined_timetoaction']."<br>due:".$contact_data['date_due_timetoaction']);
			$contact_data['progress_message'] = date_difference(date("Y-m-d H:i:s", $start), date("Y-m-d H:i:s", $end)) . " left";
		}
	}
}

$sth = SQL_QUERY("
	select
		*
	from contact_emails
	where contact_id='".SQL_CLEAN($_REQUEST['id'])."'
");
$contact_emails = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$contact_emails[] = $data;
	if ($data['is_primary']) $contact_data['primary_email'] = $data['email'];
}


$sth = SQL_QUERY("
	select
		*
	from contact_phones
	where contact_id='".SQL_CLEAN($_REQUEST['id'])."'
");
$contact_phones = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$contact_phones[] = $data;
	if ($data['is_primary']) $contact_data['primary_phone'] = $data['phone_number'];
}

$sth = SQL_QUERY("
	select
		c.*
		, u.first_name
		, u.last_name
	from contact_comments as c
	left join users as u on u.user_id=c.user_id
	where c.contact_id='".SQL_CLEAN($_REQUEST['id'])."'
	order by date_added desc

");
$contact_comments = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {

	$data['date_added'] = convert_to_local($data['date_added']);
	$data['comment'] = str_replace("<br>","\n",$data['comment']);
	$data['comment'] = trim(strip_tags($data['comment']));
	$contact_comments[] = $data;
}

$sth = SQL_QUERY("
	select
		c.*
		, u.first_name
		, u.last_name
	from campaigns as c
	left join users as u on u.user_id=c.user_id
	where
		c.user_id='".SQL_CLEAN($_SESSION['user_id'])."'
		or (u.company_id='' and c.shared_level=1)
		or c.shared_level=2
 	order by campaign_name
");
$campaigns = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$campaigns[] = $data;
}

$sth = SQL_QUERY("
	select
		cc.*
		, c.campaign_name
	from campaigns_rel_contacts as cc
	left join campaigns as c on c.campaign_id=cc.campaign_id
	where cc.contact_id='".SQL_CLEAN($_REQUEST['id'])."'
");
$contact_campaigns = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$contact_campaigns[] = $data;
}

$sth = SQL_QUERY("select * from contact_buckets where company_id=".SQL_CLEAN($_SESSION['user']['company_id']));
$buckets = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$buckets[] = $data;
}

$sth = SQL_QUERY("
	select
		c.*
		, concat(rb.first_name, ' ', rb.last_name) as referred_by
		, concat(rt.first_name, ' ', rt.last_name) as referred_to
	from contact_referral as c
	left join users as rb on rb.user_id=c.referred_by_user_id
	left join users as rt on rt.user_id=c.user_id
	where c.contact_id='".SQL_CLEAN($_REQUEST['id'])."'
");
$contact_referrals = array();
$contact_referrals_notactive = array();
$contact_refered_user = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$data['date_referral'] = convert_to_local($data['date_referral']);
	if ($data['is_active'] == 1) {
		$contact_referrals[] = $data;
		$contact_refered_user[] = $data['user_id'];
	}
	else if ($data['is_active'] == 0) {
		$contact_referrals_notactive[] = $data;
	}
}

$sth = SQL_QUERY("select appointment_type, appointment_type_id from appointment_types where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and is_active=1");
$appointment_types = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$appointment_types[] = $data;
}

$sth = SQL_QUERY("select * from zugent.contact_searches where is_deleted != 1");
$mls_searches = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$mls_searches[] = $data;
}

// die(date("Y-m-d H:i:s"). " UTC: ". gmdate("Y-m-d H:i:s"));

$sth = SQL_QUERY("select ca.*, at.appointment_type, u.first_name, u.last_name from contact_appointments as ca
					left join appointment_types as at on ca.appointment_type_id=at.appointment_type_id
					left join users as u on ca.user_id=u.user_id where ca.contact_id=".SQL_CLEAN($_REQUEST['id'])."");
$contact_appointments = array();
$complete_appointments = array();
$cancelled_appointments = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$sth_cac = SQL_QUERY("select * from contact_appointment_comments where contact_appointment_id=".$data['contact_appointment_id']);
	$data['comments_count'] = SQL_NUM_ROWS($sth_cac);
	$data['date_appointment'] = convert_to_local($data['date_appointment']);
	$data['date_completed'] = convert_to_local($data['date_completed']);

	if($data['is_completed'] == 1)
		$complete_appointments[] = $data;
	else if($data['is_cancelled'] == 1)
		$cancelled_appointments[] = $data;
	else
		$contact_appointments[] = $data;
}

$completed_appointments_count = count($complete_appointments);


// die(var_dump($_SESSION));

$sth = SQL_QUERY("select cru.*, u.first_name, u.last_name, u.company_id
	from contacts_rel_users as cru
	left join users as u on u.user_id = cru.user_id
	where contact_id='".SQL_CLEAN($_REQUEST['id'])."'
	and u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])."
	and cru.is_deleted=0
	order by is_primary DESC, first_name ASC, last_name ASC");
$contact_assignments = array();
$contact_assigned_user = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$contact_assignments[] = $data;
	$contact_assigned_user[] = $data['user_id'];
}

$users_list = array();
$sth = SQL_QUERY("select u.* from users as u where u.is_active=1 and u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'");
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$users_list[] = $data;
}

$company_available_users = array();
$sth = SQL_QUERY("select u.* from users as u where u.is_active=1 and u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and u.user_id not in ( '" . implode($contact_assigned_user, "', '") . "' )");
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$company_available_users[] = $data;
}

// $sth = SQL_QUERY("select cru.*, u.first_name, u.last_name, u.company_id
// 	from contacts_rel_users as cru
// 	left join users as u on u.user_id = cru.user_id
// 	where contact_id='".SQL_CLEAN($_REQUEST['id'])."'
// 	and u.company_id<>".SQL_CLEAN($_SESSION['user']['company_id'])."
// 	order by is_primary DESC, first_name ASC, last_name ASC");
// $contact_assignments_2 = array();
// while ($data = SQL_ASSOC_ARRAY($sth)) {
// 	$contact_assignments_2[] = $data;
// }

$sth = SQL_QUERY("
	select
		c.*
	from companies as c
 	order by company_name
");
$companies = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$companies[] = $data;
}

$sth = SQL_QUERY("select cft.*
	from file_types as cft
	where cft.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])."
	order by cft.name ASC");
$file_types = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	if ($data['is_deleted'] != 1)
	$file_types[] = $data;
}

// $sth = SQL_QUERY("select cft.*
// 	from file_types as cft
// 	where cft.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])."
// 	order by cft.name ASC");
// $file_types = array();
// while ($data = SQL_ASSOC_ARRAY($sth)) {
// 	$file_types[] = $data;
// }

$sth = SQL_QUERY("select cf.*, cft.name as file_type_name
	from contact_files as cf
	left join file_types as cft on cft.file_type_id = cf.file_type_id
	where cf.contact_id=".SQL_CLEAN($_REQUEST['id'])." and cf.is_deleted=0
	order by cf.file_name ASC");
$contact_files = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$data['date_uploaded'] = convert_to_local($data['date_uploaded']);
	$contact_files[] = $data;
}

$sth = SQL_QUERY("select cf.*, cft.name as file_type_name
	from contact_files as cf
	left join file_types as cft on cft.file_type_id = cf.file_type_id
	where cf.contact_id=".SQL_CLEAN($_REQUEST['id'])."
	and cf.is_deleted=1
	order by cf.file_name ASC");
$deleted_contact_files = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$deleted_contact_files[] = $data;
}

$dfc_count = count($deleted_contact_files);
$ca_1_count = count($contact_assignments);
// $ca_2_count = count($contact_assignments_2);
// $ca_total = $ca_1_count + $ca_2_count;
// $smarty->assign("ca_2_count", $ca_2_count);
$smarty->assign("ca_total", $ca_1_count);

$sth = SQL_QUERY("select * from transaction_type where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])."");
$transaction_types = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$transaction_types[] = $data;
}

$sth = SQL_QUERY("select * from transaction_status where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])."");
$transaction_status = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$transaction_status[] = $data;
}

$sth = SQL_QUERY("select o.* from offices as o where o.is_active=1 and o.office_id not in (select co.office_id from contact_rel_offices as co where co.contact_id=".SQL_CLEAN($_REQUEST['id']).") and o.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." order by o.name");
$active_offices = array();
$ctr = 1;
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$data['count'] = $ctr;
	$active_offices[] = $data;
	$ctr++;
}

$sth = SQL_QUERY("select co.contact_rel_office_id, o.* from contact_rel_offices as co
	left join offices as o on o.office_id=co.office_id
	where is_active=1 and co.contact_id='".SQL_CLEAN($_REQUEST['id'])."'
	order by o.name");
$contact_offices = array();
		// $ctr = 1;
while ($data = SQL_ASSOC_ARRAY($sth)) {
			// $data['count'] = $ctr;
	$contact_offices[] = $data;
	$ctr++;
}

$sth = SQL_QUERY("select t.*, ts.transaction_status, tt.transaction_type, u.company_id as company_id
	from transactions as t
	left join transaction_status as ts on ts.transaction_status_id =  t.transaction_status_id
	left join transaction_type as tt on tt.transaction_type_id =  t.transaction_type_id
	left join users as u on u.user_id =  t.user_id
	where t.contact_id=".SQL_CLEAN($_REQUEST['id'])."
	order by t.date_created ASC");
$transactions = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$data['transaction_description'] = str_replace("\n","<BR/>",$data['transaction_description']);
	$data['transaction_description'] = strip_tags($data['transaction_description']);
	$data['date_created'] = convert_to_local($data['date_created']);
	if (strlen($data['transaction_description']) > 500) {
		$start = substr($data['transaction_description'], 0, 500);
		$end = substr($data['transaction_description'],500,strlen($data['transaction_description']));
		$data['description_start'] = $start;
		$data['description_end'] = $end;
	}

	$transactions[] = $data;
}

if (isset($_POST['a'])) {
	if($_SESSION['user']['is_admin'] == 1) {
		SQL_QUERY("update contacts set summary='".SQL_CLEAN($_POST['summary'])."',".
			"first_name='".SQL_CLEAN($_POST['first_name'])."',".
			"last_name='".SQL_CLEAN($_POST['last_name'])."',".
			"street_address='".SQL_CLEAN($_POST['street_address'])."',".
			"city='".SQL_CLEAN($_POST['city'])."',".
			"state='".SQL_CLEAN($_POST['state'])."',".
			"county='".SQL_CLEAN($_POST['county'])."',".
			"bucket_id='".SQL_CLEAN($_POST['bucket_id'])."',".
			"mls_number='".SQL_CLEAN($_POST['mls_number'])."',".
			"contact_source='".SQL_CLEAN($_POST['contact_source'])."',".
			"county='".SQL_CLEAN($_POST['county'])."',".
			"zip='".SQL_CLEAN($_POST['zip'])."'".
			" where contact_id='".SQL_CLEAN($_POST['id'])."' limit 1
			");
	}
	else {
		SQL_QUERY("update contacts set summary='".SQL_CLEAN($_POST['summary'])."',".
			"first_name='".SQL_CLEAN($_POST['first_name'])."',".
			"last_name='".SQL_CLEAN($_POST['last_name'])."',".
			"street_address='".SQL_CLEAN($_POST['street_address'])."',".
			"city='".SQL_CLEAN($_POST['city'])."',".
			"state='".SQL_CLEAN($_POST['state'])."',".
			"county='".SQL_CLEAN($_POST['county'])."',".
			"bucket_id='".SQL_CLEAN($_POST['bucket_id'])."',".
			"county='".SQL_CLEAN($_POST['county'])."',".
			"zip='".SQL_CLEAN($_POST['zip'])."'".
			" where contact_id='".SQL_CLEAN($_POST['id'])."' limit 1
			");
	}

	SQL_QUERY("update contact_phones set phone_number='".SQL_CLEAN($_POST['primary_phone']).
		"' where contact_id='".SQL_CLEAN($_POST['id'])."' and is_primary=1 limit 1
		");

	SQL_QUERY("update contact_emails set email='".SQL_CLEAN($_POST['primary_email']).
		"' where contact_id='".SQL_CLEAN($_POST['id'])."' and is_primary=1 limit 1
		");

	header("location: /contacts_edit.php?id=".$_POST['id']);
}

// For Error Notification on Direct Access or No Data Sent
if(isset($_GET['code'])) {
	if($_GET['code'] == '1x007') {
		$smarty->assign("display_error_message", TRUE);
	}
}

$smarty->assign('contact_campaigns', $contact_campaigns);
$smarty->assign('contact_offices', $contact_offices);
$smarty->assign('offices', $active_offices);
$smarty->assign('contact_referrals', $contact_referrals);
$smarty->assign('contact_referrals_notactive', $contact_referrals_notactive);
$smarty->assign('campaigns', $campaigns);
$smarty->assign('contact_data', $contact_data);
$smarty->assign('contact_emails', $contact_emails);
$smarty->assign('contact_phones', $contact_phones);
$smarty->assign('assign_data', $assign_data);
$smarty->assign('contact_comments', $contact_comments);
$smarty->assign("buckets", $buckets);
$smarty->assign("contact_appointments", $contact_appointments);
$smarty->assign("complete_appointments", $complete_appointments);
$smarty->assign("cancelled_appointments", $cancelled_appointments);
$smarty->assign("complete_appointments_count", $completed_appointments_count);
$smarty->assign("appointment_types", $appointment_types);
$smarty->assign("contact_assignments", $contact_assignments);
$smarty->assign("mls_searches", $mls_searches);
$smarty->assign("companies", $companies);
$smarty->assign("contact_files", $contact_files);
$smarty->assign("deleted_contact_files", $deleted_contact_files);
$smarty->assign("file_types", $file_types);
$smarty->assign("dfc_count", $dfc_count);
$smarty->assign("transaction_types", $transaction_types);
$smarty->assign("transaction_status", $transaction_status);
$smarty->assign("transactions", $transactions);
$smarty->assign("user", $_SESSION['user']);
$smarty->assign("users_list", $users_list);
$smarty->assign("company_available_users", $company_available_users);
$smarty->assign("footer_js", "includes/footers/contacts_edit_footer.tpl");

$smarty->display('contacts_edit.tpl');

?>
