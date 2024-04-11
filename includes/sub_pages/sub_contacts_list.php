<?php

// Populates the table on contacts list page

if(isset($xcategory["bucket"])) {

	$sth_buckets = SQL_QUERY("
		select distinct
		cb.* 
		from contact_buckets as cb
		inner join contacts as c on c.bucket_id=cb.bucket_id 
		where cb.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and cb.is_dashboard=1 and cb.bucket_id=".SQL_CLEAN($xcategory['bucket'])."
		");

	while ($bucket = SQL_ASSOC_ARRAY($sth_buckets)) {

		$key = $bucket['bucket_name'];

		$sth;

		if (isset($xcategory["c"])) {
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
				where c.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and c.bucket_id='".$bucket['bucket_id']."' 
				order by c.date_activity DESC
			");
		}
		else {
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
		}

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

		$smarty->assign("name", $key);

	}

	$smarty->assign('search_name', "bucket_id");
	$smarty->assign('search_id', $xcategory['bucket']);

}
else if(isset($xcategory["undefined"])) {

	if (isset($xcategory["c"])) {
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
			where c.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and c.bucket_id=0 
			order by c.date_activity DESC
		");
	}
	else {
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
	}

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
	$smarty->assign('search_id', $xcategory['undefined']);

}
else if(isset($xcategory["new"])) {

	if (isset($xcategory["c"])) { 
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
			where c.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and (cu.date_viewed = 0 or cu.date_viewed is null or cu.date_viewed='0000-00-00 00:00:00') 
			order by c.date_activity DESC
		");
	}
	else {
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
			where cu.user_id='".SQL_CLEAN($_SESSION['user_id'])."' and cu.is_deleted != 1 and (cu.date_viewed = 0 or cu.date_viewed is null or cu.date_viewed='0000-00-00 00:00:00') 
			order by c.date_activity DESC
			");
	}

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
	$smarty->assign('search_id', $xcategory['new']);
}
else if(isset($xcategory["overdue"])) {

	$sth = SQL_QUERY("select ct.*, cp.phone_number, ce.email, cru.date_viewed from contacts_rel_users as cru ".
		"left join contacts as ct on ct.contact_id = cru.contact_id ".
		"left join contact_appointments as ca on ca.contact_id = cru.contact_id ".
		"left join contact_emails as ce on ce.contact_id=cru.contact_id and ce.is_primary=1 ".
		"left join contact_phones as cp on cp.contact_id=cru.contact_id and cp.is_primary=1 ".
		"where cru.user_id = '".SQL_CLEAN($_SESSION['user_id'])."' and ".
		"(ca.is_completed = 0 and ca.is_cancelled = 0) and ".
		"(ca.date_appointment < '".date("Y-m-d H:i:s")."') ".
		"order by ca.date_appointment asc");

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
		$contacts['overdue'][] = $data;
	}

	$smarty->assign("name", "overdue");

	$smarty->assign('search_name', "overdue");
	$smarty->assign('search_id', $xcategory['overdue']);
}
else if(isset($xcategory["upcoming"])) {

	$sth = SQL_QUERY("select ct.*, cp.phone_number, ce.email, cru.date_viewed from contacts_rel_users as cru ".
		"left join contacts as ct on ct.contact_id = cru.contact_id ".
		"left join contact_appointments as ca on ca.contact_id = cru.contact_id ".
		"left join contact_emails as ce on ce.contact_id=cru.contact_id and ce.is_primary=1 ".
		"left join contact_phones as cp on cp.contact_id=cru.contact_id and cp.is_primary=1 ".
		"where cru.user_id = '".SQL_CLEAN($_SESSION['user_id'])."' and ".
		"(ca.is_completed = 0 and ca.is_cancelled = 0) and ".
		"(ca.date_appointment >= '".date("Y-m-d H:i:s")."') and ".
		"(ca.date_appointment <= '".date("Y-m-d H:i:s", strtotime("+15 day", strtotime(date("Y-m-d H:i:s"))))."') ".
		"order by ca.date_appointment asc");

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
		$contacts['upcoming'][] = $data;
	}

	$smarty->assign("name", "upcoming");

	$smarty->assign('search_name', "upcoming");
	$smarty->assign('search_id', $xcategory['upcoming']);
}

if (isset($xcategory["c"])) {
	$smarty->assign('active_page','company_contacts');
}
else {
	$smarty->assign('active_page','contacts');
}

?>