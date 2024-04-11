<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

$sth = SQL_QUERY("select * from contact_buckets where company_id=".SQL_CLEAN($_SESSION['user']['company_id']));
$buckets = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$buckets[] = $data;
}

if ($_REQUEST['action'] == 'n') {
	$sql = "
		insert into contacts 
		(
			first_name
			, last_name
			, date_created
			, date_updated
			, street_address
			, city
			, state
			, zip
			, county
			, summary
			, company_id
			, bucket_id
		) values (
			'".SQL_CLEAN($_REQUEST['first_name'])."'
			, '".SQL_CLEAN($_REQUEST['last_name'])."'
			, NOW()
			, NOW()
			, '".SQL_CLEAN($_REQUEST['street_address'])."'
			, '".SQL_CLEAN($_REQUEST['city'])."'
			, '".SQL_CLEAN($_REQUEST['state'])."'
			, '".SQL_CLEAN($_REQUEST['zip'])."'
			, '".SQL_CLEAN($_REQUEST['county'])."'
			, '".SQL_CLEAN($_REQUEST['summary'])."'
			, '".SQL_CLEAN($_SESSION['company']['company_id'])."'
			, '".SQL_CLEAN($_REQUEST['bucket_id'])."'
		)
	";
	$sth = SQL_QUERY($sql);
	$contact_id = SQL_INSERT_ID();

	if ($_REQUEST['primary_phone'] != '') SQL_QUERY("insert into contact_phones (contact_id, phone_number, is_primary) values ('".$contact_id."','".SQL_CLEAN($_REQUEST['primary_phone'])."',1)");
	if ($_REQUEST['primary_email'] != '') SQL_QUERY("insert into contact_emails (contact_id, email, is_primary) values ('".$contact_id."','".SQL_CLEAN($_REQUEST['primary_email'])."',1)");

	SQL_QUERY("
		insert into contacts_rel_users 
		(
			user_id
			, contact_id
			, date_assigned 
			, is_primary
			, assigned_by_user_id
		) values (
			'".SQL_CLEAN($_SESSION['user_id'])."'
			, '".SQL_CLEAN($contact_id)."'
			, NOW()
			, 1
			, '".SQL_CLEAN($_SESSION['user_id'])."'
		)
	");
	header("location: /contacts_edit.php?id=".$contact_id);
	exit;
}

$smarty->assign("buckets", $buckets);
$smarty->assign("footer_js", 'includes/footers/contact_new_footer.tpl');

$smarty->display('contacts_new.tpl');

?>