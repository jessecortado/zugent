<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/includes/contact_send_email.php");

// if(empty($_SERVER['HTTPS']) || $_SERVER['HTTPS'] == 'off') {
// 	$redirect = 'https://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
// 	header('HTTP/1.1 301 Mover Permanently');
// 	header('Location: ' . $redirect);
// 	exit();
// }

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('drive');

auth(false, true);

$sth = SQL_QUERY("
	select 
		ul.*, u.first_name, u.last_name , UNIX_TIMESTAMP(date_collected) as unixtime_collected, 
		u.is_perm_drive, u.is_drive_accepted_alert, u.direction 
	from user_locations as ul 
	left join users as u on ul.user_id=u.user_id 
	where ul.user_id='".SQL_CLEAN($_SESSION['user_id'])."' 
	order by date_collected desc limit 10
");
$user_locations = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$user_locations[] = $data;
}

$sth = SQL_QUERY("select distinct c.first_name, c.last_name, UNIX_TIMESTAMP(cr.date_referral) as unixtime_referral, cr.date_referral, cb.bucket_name, cb.bucket_id, c.contact_id, ar.latitude, ar.longitude, cp.phone_number, ce.email, c.is_unsubscribed 
	from contact_referral as cr 
	inner join contacts as c on cr.contact_id=c.contact_id 
	left join contacts_rel_users as cru on cr.contact_id=cru.contact_id 
	left join contact_buckets as cb on c.bucket_id=cb.bucket_id 
	left join agent_requests as ar on c.contact_id=ar.contact_id 
	left join contact_phones as cp on c.contact_id=cp.contact_id and cp.is_primary=1 
	left join contact_emails as ce on c.contact_id=ce.contact_id and ce.is_primary=1 
	where cr.referral_source='ZugDrive' and cru.user_id=".SQL_CLEAN($_SESSION['user_id'])." 
	order by cr.date_referral desc limit 5
");
$contacts = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$data['contact_status'] = "";
	if (!empty($data['bucket_name'])) {
		$data['contact_status'] = $data['bucket_name'];
	}
	else {
		$data['contact_status'] = "Uncategorized";
	}
	$contacts[] = $data;
}

$user_perm_drive = "false";

if($user_locations[0]['is_perm_drive'] == 1) {
	$user_perm_drive = "true";
}

$smarty->assign('user_locations', $user_locations);
$smarty->assign('user_latitude', $user_locations[0]['latitude']);
$smarty->assign('user_longitude', $user_locations[0]['longitude']);
$smarty->assign('user_perm_drive', $user_perm_drive);
$smarty->assign('user_direction', $user_locations[0]['direction']);
$smarty->assign('contacts', $contacts);
$smarty->assign('user', $_SESSION['user']);
$smarty->assign('footer_js', 'includes/footers/drive_footer.tpl');
$smarty->display('drive.tpl');

?>