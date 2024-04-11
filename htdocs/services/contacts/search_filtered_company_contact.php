<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1x007',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);

if(isset($_POST['name'])){

	$like_param = "%".SQL_CLEAN($_POST['name'])."%";
	$filter = "";

	if($_POST['search_name'] == "undefined") {
		$filter = "((bucket_id=0 or bucket_id is null) and (status_id=0 or status_id is null) and (sub_status_id=0 or sub_status_id is null))";
	}
	else if($_POST['search_name'] == "new") {
		$filter = "(cu.date_viewed = 0 or cu.date_viewed is null or cu.date_viewed='0000-00-00 00:00:00')";
	}
	else {
		$filter = SQL_CLEAN($_POST['search_name'])."=".SQL_CLEAN($_POST['search_id']);
	}

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
		left join users as u on u.user_id=cu.user_id 
		where cu.is_deleted != 1 
		and CONCAT(c.first_name, ' ', c.last_name) like '".$like_param."' and u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
		and ".$filter."
		order by c.date_activity DESC
	");

	$contacts = array();
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$sth_camp = SQL_QUERY("select c.*, datediff(NOW(),cc.date_added) as days_in from campaigns_rel_contacts as cc left join campaigns as c on c.campaign_id=cc.campaign_id where cc.contact_id='".$data['contact_id']."' limit 1");
		$data['campaigns'] = array();
		while ($c_data = SQL_ASSOC_ARRAY($sth_camp)) {
			$data['campaigns'][] = $c_data;
		}
		$contacts[] = $data;
	}

	echo json_encode(array("msg"=>true, "data"=>$contacts));
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1x007");
	}
}

?>