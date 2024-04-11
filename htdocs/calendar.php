<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

if(isset($_POST['action'])) {

	$sth = SQL_QUERY("
	select
		ca.*
		, a.appointment_type, c.first_name, c.last_name
	from contact_appointments as ca
	left join appointment_types as a on a.appointment_type_id=ca.appointment_type_id
	left join contacts as c on c.contact_id=ca.contact_id
	where ca.user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."' and ca.is_completed=0
	
	");

	$contact_appointments = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$contact_appointments[] = $data;
	}

	exit;
}

$sth = SQL_QUERY("
	select
		ca.*
		, a.appointment_type, c.first_name, c.last_name
	from contact_appointments as ca
	left join appointment_types as a on a.appointment_type_id=ca.appointment_type_id
	left join contacts as c on c.contact_id=ca.contact_id
	where ca.user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."' and ca.is_completed=0
	
");

$contact_appointments = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$data['date_appointment'] = convert_to_local($data['date_appointment']);
	$data['description'] = strip_tags($data['description']);
	$data['description'] = str_replace(array("\r", "\n"), '<br>', $data['description']);
	$contact_appointments[] = $data;
}

// die(var_dump($contact_appointments));

$sth = SQL_QUERY("
				select 
				c.*
				, cp.phone_number
				, ce.email
				, cu.date_viewed
				from contacts_rel_users as cu
				left join contacts as c on c.contact_id=cu.contact_id
				left join contact_emails as ce on ce.contact_id=cu.contact_id and ce.is_primary=1
				left join contact_phones as cp on cp.contact_id=cu.contact_id and cp.is_primary=1
				where cu.user_id='".SQL_CLEAN($_SESSION['user_id'])."' and cu.is_deleted != 1 
				order by c.date_activity DESC
			");
$contacts = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$contacts[] = $data;
}

$sth = SQL_QUERY("select appointment_type, appointment_type_id from appointment_types where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and is_active=1");
$appointment_types = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$appointment_types[] = $data;
}

$smarty->assign("contact_appointments", $contact_appointments);
$smarty->assign("contacts", $contacts);
$smarty->assign("appointment_types", $appointment_types);

$smarty->display('calendar.tpl');


	
?>