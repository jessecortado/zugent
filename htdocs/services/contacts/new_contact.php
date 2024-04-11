<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1x0c7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);

$sth = SQL_QUERY("select * from contact_buckets where company_id=".SQL_CLEAN($_SESSION['user']['company_id']));
$buckets = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$buckets[] = $data;
}

if (isset($_REQUEST['user_id']) && $_REQUEST['user_id'] != '') {

	$sql = "
		insert into contacts 
		(
			first_name
			, last_name
			, date_created
			, date_updated
			, company_id
			, bucket_id
		) values (
			'".SQL_CLEAN($_REQUEST['first_name'])."'
			, '".SQL_CLEAN($_REQUEST['last_name'])."'
			, NOW()
			, NOW()
			, '".SQL_CLEAN($_SESSION['company']['company_id'])."'
			, '".SQL_CLEAN($_REQUEST['bucket_id'])."'
		)
	";

	$sth = SQL_QUERY($sql);
	$contact_id = SQL_INSERT_ID();

	SQL_QUERY("
		insert into contacts_rel_users 
		(
			user_id
			, contact_id
			, date_assigned 
			, is_primary
			, assigned_by_user_id
		) values (
			'".SQL_CLEAN($_REQUEST['user_id'])."'
			, '".SQL_CLEAN($contact_id)."'
			, NOW()
			, 1
			, '".SQL_CLEAN($_SESSION['user_id'])."'
		)
	");

	echo json_encode(array('msg'=>true, 'contact_id'=>$contact_id));

}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1x0c7");
	}
}

?>