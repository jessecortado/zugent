<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

// Start

$contacts_count = 0;
$contacts = array();
$filtered = true;

$sth = SQL_QUERY("
select
	count(cu.contact_id) as total_campaigns
	from contacts_rel_users as cu
	left join campaigns_rel_contacts as cc on cc.contact_id=cu.contact_id 
	left join users as u on u.user_id=cu.user_id 
	where u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and is_onhold != 1 and is_completed != 1
");
list($total_campaigns) = SQL_ROW($sth);
$smarty->assign('total_campaigns', $total_campaigns);



$sth = SQL_QUERY("
select
	count(*) as total_messages
	from contacts_rel_users as cu
	left join campaigns_rel_contacts as cc on cc.contact_id=cu.contact_id
	left join campaign_event_rel_contacts as cec on cec.contact_id=cu.contact_id 
	left join users as u on u.user_id=cu.user_id 
	where u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and is_onhold != 1 and is_completed != 1
");
list($total_messages) = SQL_ROW($sth);
$smarty->assign('total_messages', $total_messages);

if(isset($_GET["bucket"])) {

	$sth_buckets = SQL_QUERY("
		select distinct
			cb.* 
		from contact_buckets as cb
		inner join contacts as c on c.bucket_id=cb.bucket_id 
		where cb.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and cb.is_dashboard=1 and cb.bucket_id=".SQL_CLEAN($_GET['bucket'])."
	");

	while ($bucket = SQL_ASSOC_ARRAY($sth_buckets)) {

		$key = $bucket['bucket_name'];
		$sth = SQL_QUERY("
			select 
				c.*
				, cp.phone_number
				, ce.email
				, cu.date_viewed
				, concat(u.first_name, ' ', u.last_name) as primary_user 
			from contacts_rel_users as cu
			left join contacts as c on c.contact_id=cu.contact_id
			left join contact_emails as ce on ce.contact_id=cu.contact_id and ce.is_primary=1
			left join contact_phones as cp on cp.contact_id=cu.contact_id and cp.is_primary=1 
			left join users as u on cu.user_id=u.user_id and cu.is_primary=1 
			where u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and c.bucket_id='".$bucket['bucket_id']."' and cu.is_deleted != 1 
			order by c.date_activity DESC
		");

		while ($data = SQL_ASSOC_ARRAY($sth)) {

			$contacts_count++;

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

	$smarty->assign("name", $key);
	$smarty->assign('search_name', "bucket_id");
	$smarty->assign('search_id', $_GET['bucket']);

}

else if(isset($_GET["undefined"])) {

	$sth = SQL_QUERY("
		select 
			c.*
			, cp.phone_number
			, ce.email
			, cu.date_viewed
			, concat(u.first_name, ' ', u.last_name) as primary_user 
		from contacts_rel_users as cu
		left join contacts as c on c.contact_id=cu.contact_id
		left join contact_emails as ce on ce.contact_id=cu.contact_id and ce.is_primary=1
		left join contact_phones as cp on cp.contact_id=cu.contact_id and cp.is_primary=1 
		left join users as u on u.user_id=cu.user_id and cu.is_primary=1 
		where u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and cu.is_deleted != 1 and c.bucket_id=0 
		order by c.date_activity DESC
	");

	$contacts = array();
	while ($data = SQL_ASSOC_ARRAY($sth)) {

		$contacts_count++;

		$data['date_created'] = convert_to_local($data['date_created']);
		$data['date_viewed'] = convert_to_local($data['date_viewed']);
		$data['date_last_opened_event'] = convert_to_local($data['date_last_opened_event']);

		$sth_camp = SQL_QUERY("select c.*, datediff(NOW(),cc.date_added) as days_in from campaigns_rel_contacts as cc left join campaigns as c on c.campaign_id=cc.campaign_id where cc.contact_id='".$data['contact_id']."' limit 1");
		$data['campaigns'] = array();
		while ($c_data = SQL_ASSOC_ARRAY($sth_camp)) {
			$data['campaigns'][] = $c_data;
		}
		$contacts["undefined"][] = $data;
	}

	$smarty->assign("name", "undefined");

	$smarty->assign('search_name', "undefined");
	$smarty->assign('search_id', $_GET['undefined']);


}
else if(isset($_GET["new"])) {

	$sth = SQL_QUERY("
		select 
			c.*
			, cp.phone_number
			, ce.email
			, cu.date_viewed
			, concat(u.first_name, ' ', u.last_name) as primary_user 
		from contacts_rel_users as cu
		left join contacts as c on c.contact_id=cu.contact_id
		left join contact_emails as ce on ce.contact_id=cu.contact_id and ce.is_primary=1
		left join contact_phones as cp on cp.contact_id=cu.contact_id and cp.is_primary=1 
		left join users as u on u.user_id=cu.user_id and cu.is_primary=1 
		where u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and cu.is_deleted != 1 and (cu.date_viewed = 0 or cu.date_viewed is null or cu.date_viewed='0000-00-00 00:00:00') 
		order by c.date_activity DESC
	");

	while ($data = SQL_ASSOC_ARRAY($sth)) {

		$contacts_count++;

		$data['date_created'] = convert_to_local($data['date_created']);
		$data['date_viewed'] = convert_to_local($data['date_viewed']);
		$data['date_last_opened_event'] = convert_to_local($data['date_last_opened_event']);
		
		$sth_camp = SQL_QUERY("select c.*, datediff(NOW(),cc.date_added) as days_in from campaigns_rel_contacts as cc left join campaigns as c on c.campaign_id=cc.campaign_id where cc.contact_id='".$data['contact_id']."' limit 1");
		$data['campaigns'] = array();
		while ($c_data = SQL_ASSOC_ARRAY($sth_camp)) {
			$data['campaigns'][] = $c_data;
		}
		$contacts['new'][] = $data;
	}

	$smarty->assign("name", "new");

	$smarty->assign('search_name', "new");
	$smarty->assign('search_id', $_GET['new']);
}
else {

	$filtered = false;
	$smarty->assign("name", "All company contacts");

}

$smarty->assign('contacts', $contacts);
$smarty->assign('filtered', $filtered);

$smarty->assign('total_count', $contacts_count);

$smarty->assign('user', $_SESSION['user']);

$smarty->assign('footer_js', 'includes/footers/dashboard.tpl');

$smarty->display('company_contacts.tpl');


	
?>