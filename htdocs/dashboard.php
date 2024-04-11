<?php
require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

require_once($_SERVER['SITE_DIR']."/includes/new_transaction.php");

$sth = SQL_QUERY("
	select
	count(cu.contact_id) as total_campaigns
	from contacts_rel_users as cu
	left join campaigns_rel_contacts as cc on cc.contact_id=cu.contact_id
	where cu.user_id='".SQL_CLEAN($_SESSION['user_id'])."' and cc.is_onhold != 1 and cc.is_completed != 1
	");
list($total_campaigns) = SQL_ROW($sth);
$smarty->assign('total_campaigns', $total_campaigns);


$sth = SQL_QUERY("
	select
	count(*) as total_messages
	from contacts_rel_users as cu
	left join campaigns_rel_contacts as cc on cc.contact_id=cu.contact_id
	left join campaign_event_rel_contacts as cec on cec.contact_id=cu.contact_id
	where cu.user_id='".SQL_CLEAN($_SESSION['user_id'])."' and cc.is_onhold != 1 and cc.is_completed != 1
	");
list($total_messages) = SQL_ROW($sth);
$smarty->assign('total_messages', $total_messages);

$contacts_count = 0;

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
	where cu.user_id='".SQL_CLEAN($_SESSION['user_id'])."' and cu.is_deleted != 1 and c.bucket_id=0
	order by c.date_activity DESC
	");

$contacts_count += SQL_NUM_ROWS($sth);

$undefined_contacts = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {

	$data['date_created'] = convert_to_local($data['date_created']);
	$data['date_viewed'] = convert_to_local($data['date_viewed']);
	$data['date_last_opened_event'] = convert_to_local($data['date_last_opened_event']);
	$sth_camp = SQL_QUERY("select c.*, datediff(NOW(),cc.date_added) as days_in from campaigns_rel_contacts as cc left join campaigns as c on c.campaign_id=cc.campaign_id where cc.contact_id='".$data['contact_id']."' limit 1");
	$data['campaigns'] = array();
	while ($c_data = SQL_ASSOC_ARRAY($sth_camp)) {
		$data['campaigns'][] = $c_data;
	}
	$undefined_contacts[] = $data;
}

// Start

$contacts = array();

$sth_buckets = SQL_QUERY("
	select distinct
	cb.*
	from contact_buckets as cb
	inner join contacts as c on c.bucket_id=cb.bucket_id
	where cb.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and cb.is_dashboard=1
	");

while ($bucket = SQL_ASSOC_ARRAY($sth_buckets)) {
	$key = $bucket['bucket_name'];
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
		where cu.user_id='".SQL_CLEAN($_SESSION['user_id'])."' and c.bucket_id='".$bucket['bucket_id']."' and cu.is_deleted != 1
		order by c.date_activity DESC
		");

	// $contacts_count += SQL_NUM_ROWS($sth);

	while ($data = SQL_ASSOC_ARRAY($sth)) {

		$data['date_created'] = convert_to_local($data['date_created']);
		$data['date_viewed'] = convert_to_local($data['date_viewed']);
		$data['date_last_opened_event'] = convert_to_local($data['date_last_opened_event']);
		$sth_camp = SQL_QUERY("select c.*, datediff(NOW(),cc.date_added) as days_in from campaigns_rel_contacts as cc left join campaigns as c on c.campaign_id=cc.campaign_id where cc.contact_id='".$data['contact_id']."' limit 1");
		$data['campaigns'] = array();
		while ($c_data = SQL_ASSOC_ARRAY($sth_camp)) {
			$data['campaigns'][] = $c_data;
		}
		$contacts[$key][] = $data;
	}

}


// UPDATED DASHBOARD - START

function time_elapsed_string($datetime) {

    $now = new DateTime();
    $ago = new DateTime($datetime);
    $diff = $now->diff($ago);

    $diff->w = floor($diff->d / 7);
    $diff->d -= $diff->w * 7;

    $string = array(
        'y' => 'year',
        'm' => 'month',
        'w' => 'week',
        'd' => 'day',
        'h' => 'hour',
        'i' => 'minute',
        's' => 'second',
    );

    foreach ($string as $k => &$v) {
        if ($diff->$k) {
            $v = $diff->$k . ' ' . $v . ($diff->$k > 1 ? 's' : '');
        } else {
            unset($string[$k]);
        }
    }

    ($ago > $now ? $laps=' to go' : $laps=' ago');

    $string = array_slice($string, 0, 1);
    return $string ? implode(', ', $string) . $laps : 'just now';

}

$overdue_appointments = array();
$upcoming_appointments = array();
$undefined_appointments = array();

$overdue = SQL_QUERY("select ct.*, cs.bucket_name, cp.phone_number, at.appointment_type, at.appointment_icon, ca.date_appointment, ca.date_appointment as time_elapsed from contact_appointments as ca ".
	"left join contacts as ct on ca.contact_id = ct.contact_id ".
	"left join contact_phones as cp on ca.contact_id = cp.contact_id ".
	"left join contacts_rel_users as cru on ca.contact_id = cru.contact_id ".
	"left join contact_buckets as cs on ct.bucket_id = cs.bucket_id ".
	"left join appointment_types as at on ca.appointment_type_id = at.appointment_type_id ".
	"where cru.user_id = '".SQL_CLEAN($_SESSION['user']['user_id'])."' and ".
	"(ca.is_completed = 0 and ca.is_cancelled = 0) and ".
	"(ca.date_appointment < '".date("Y-m-d H:i:s")."') ".
	"order by ca.date_appointment asc limit 5");

$upcoming = SQL_QUERY("select ct.*, cs.bucket_name, cp.phone_number, at.appointment_type, at.appointment_icon, ca.date_appointment, ca.date_appointment as time_elapsed from contact_appointments as ca ".
	"left join contacts as ct on ca.contact_id = ct.contact_id ".
	"left join contact_phones as cp on ca.contact_id = cp.contact_id ".
	"left join contacts_rel_users as cru on ca.contact_id = cru.contact_id ".
	"left join contact_buckets as cs on ct.bucket_id = cs.bucket_id ".
	"left join appointment_types as at on ca.appointment_type_id = at.appointment_type_id ".
	"where cru.user_id = '".SQL_CLEAN($_SESSION['user']['user_id'])."' and ".
	"(ca.is_completed = 0 and ca.is_cancelled = 0) and ".
	"(ca.date_appointment >= '".date("Y-m-d H:i:s")."') and ".
	"(ca.date_appointment <= '".date("Y-m-d H:i:s", strtotime("+15 day", strtotime(date("Y-m-d H:i:s"))))."') ".
	"order by ca.date_appointment asc limit 5");

$undefined = SQL_QUERY("select ct.*, cru.date_assigned from contacts as ct ".
	"left join contacts_rel_users as cru on ct.contact_id = cru.contact_id and cru.is_deleted <> 1 ".
	"where cru.user_id = '".SQL_CLEAN($_SESSION['user']['user_id'])."' and ".
	"ct.bucket_id = 0 ".
	"order by ct.contact_id asc limit 5");

while ($data = SQL_ASSOC_ARRAY($overdue)) {
	$data['time_elapsed'] = time_elapsed_string($data['time_elapsed']);
	$data['date_appointment'] = convert_to_local($data['date_appointment']);
	$overdue_appointments[] = $data;
}
while ($data = SQL_ASSOC_ARRAY($upcoming)) {
	$data['time_elapsed'] = time_elapsed_string($data['time_elapsed']);
	$data['date_appointment'] = convert_to_local($data['date_appointment']);
	$upcoming_appointments[] = $data;
}
while ($data = SQL_ASSOC_ARRAY($undefined)) {
	$undefined_appointments[] = $data;
}

// For Total Count
$total_overdue = SQL_QUERY("select ct.* from contact_appointments as ca ".
	"left join contacts as ct on ca.contact_id = ct.contact_id ".
	"left join contacts_rel_users as cru on ca.contact_id = cru.contact_id ".
	"where cru.user_id = '".SQL_CLEAN($_SESSION['user']['user_id'])."' and ".
	"(ca.is_completed = 0 and ca.is_cancelled = 0) and ".
	"(ca.date_appointment < '".date("Y-m-d H:i:s")."') ".
	"order by ca.date_appointment asc");

$total_upcoming = SQL_QUERY("select ct.* from contact_appointments as ca ".
	"left join contacts as ct on ca.contact_id = ct.contact_id ".
	"left join contacts_rel_users as cru on ca.contact_id = cru.contact_id ".
	"where cru.user_id = '".SQL_CLEAN($_SESSION['user']['user_id'])."' and ".
	"(ca.is_completed = 0 and ca.is_cancelled = 0) and ".
	"(ca.date_appointment >= '".date("Y-m-d H:i:s")."') and ".
	"(ca.date_appointment <= '".date("Y-m-d H:i:s", strtotime("+15 day", strtotime(date("Y-m-d H:i:s"))))."') ".
	"order by ca.date_appointment asc");

$total_undefined = SQL_QUERY("select ct.* from contacts as ct ".
	"left join contacts_rel_users as cru on ct.contact_id = cru.contact_id and cru.is_deleted <> 1 ".
	"where ct.company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' and ".
	"cru.user_id = '".SQL_CLEAN($_SESSION['user']['user_id'])."' and ".
	"ct.bucket_id = 0 ".
	"order by ct.contact_id asc");

// UPDATED DASHBOARD - END


// Transaction Alert - START
$transaction_alert = SQL_QUERY("
	select
		ta.*,
		(select mls.mls_name from zugent.mls as mls where mls.mls_id=ta.mls_id limit 1) as mls_name,
		(select count(*) from zugent.office_rel_offices as oro left join zugent.offices as o on o.office_id=oro.office_id where oro.mls_office_id=ta.selling_office_id and o.company_id=ta.company_id limit 1) as is_selling_side
	from zugent.transaction_alerts as ta
	where ta.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' order by transaction_alert_id desc limit 5");

$alerts = array();

while ($alert_data = SQL_ASSOC_ARRAY($transaction_alert)) {
	$alerts[] = $alert_data;
}
// Transaction Alert - END


if(isset($_GET['code'])) {
	if($_GET['code'] == '1xat7') {
		$smarty->assign("error_content", "appointment type");
	}
	else if($_GET['code'] == '1xft7') {
		$smarty->assign("error_content", "file type");
	}
	else if($_GET['code'] == '1xbuc7') {
		$smarty->assign("error_content", "bucket");
	}
	else if($_GET['code'] == '1xcus7') {
		$smarty->assign("error_content", "custom strings");
	}
	else if($_GET['code'] == '1x0c7') {
		$smarty->assign("error_content", "contact");
	}
	else if($_GET['code'] == '1xof7') {
		$smarty->assign("error_content", "office");
	}
	else if($_GET['code'] == '1xcp7') {
		$smarty->assign("error_content", "campaign");
	}
	else if($_GET['code'] == '1xts7') {
		$smarty->assign("error_content", "transaction");
	}
	else if($_GET['code'] == '1x0u7') {
		$smarty->assign("error_content", "user");
	}
	else if($_GET['code'] == '1xpl7') {
		$smarty->assign("error_content", "pool lead");
	}
	else if($_GET['code'] == '1xdv7') {
		$smarty->assign("error_content", "drive");
	}
	else if($_GET['code'] == '1xbe7') {
		$smarty->assign("error_content", "bulk email");
	}
	else if($_GET['code'] == '1xue7') {
		$smarty->assign("error_content", "user email template");
	}
	$smarty->assign("display_error_message", TRUE);
}

$smarty->assign('contacts', $contacts);

$smarty->assign('transaction_alerts', $alerts);

$smarty->assign('total_contacts', $contacts_count);

$smarty->assign('undefined_contacts', $undefined_contacts);

$smarty->assign('overdue_appointments', $overdue_appointments);
$smarty->assign('upcoming_appointments', $upcoming_appointments);
$smarty->assign('undefined_appointments', $undefined_appointments);

$smarty->assign('total_overdue', SQL_NUM_ROWS($total_overdue));
$smarty->assign('total_upcoming', SQL_NUM_ROWS($total_upcoming));
$smarty->assign('total_undefined', SQL_NUM_ROWS($total_undefined));

$smarty->assign('user', $_SESSION['user']);

$smarty->display('dashboard.tpl');

?>
