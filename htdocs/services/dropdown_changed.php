<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

error_reporting(E_ERROR | E_WARNING | E_PARSE);

if(isset($_POST['bucket_id'])){
	$status = array();
	$sth = SQL_QUERY("select cs.* from contact_status as cs where cs.company_id=".SQL_CLEAN($_SESSION['user']['company_id']).
					" and cs.bucket_id=".SQL_CLEAN($_POST['bucket_id']));
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$status[] = $data;
	}
	$sth = SQL_QUERY("select cs.* from contact_status as cs where cs.company_id=".SQL_CLEAN($_SESSION['user']['company_id']).
					" and cs.bucket_id=0");
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$status[] = $data;
	}

	echo json_encode(array("data"=>$status));
}

elseif (isset($_POST['company_id'])) {
	$users = array();
	$sth = SQL_QUERY("select u.* from users as u where u.company_id=".SQL_CLEAN($_POST['company_id']));
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$users[] = $data;
	}

	echo json_encode(array("data"=>$users));
}

elseif (isset($_POST['filter'])) {

	$filter = explode(" - ",$_POST['filter']);

	if(isset($_POST['filter']) && $_POST['filter'] == "") {
		$pool_leads = array();
		$sth = SQL_QUERY("select pl.* from pool_leads as pl 
			left join users as u on pl.user_id=u.user_id 
			where u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
			and pl.pool_id=".SQL_CLEAN($_POST['id'])
			);
		while ($data = SQL_ASSOC_ARRAY($sth)) {
			$pool_leads[] = $data;
		}
		echo json_encode(array("data"=>$pool_leads));
	}
	elseif(isset($_POST['filter']) && $_POST['filter'] !== "") {
		$pool_leads = array();
		$sth = SQL_QUERY("select pl.* from pool_leads as pl 
			left join users as u on pl.user_id=u.user_id 
			where u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
			and pl.pool_id=".SQL_CLEAN($_POST['id'])." 
			and pl.city='".$filter[1]."' 
			and pl.county='".$filter[0]."'");
		while ($data = SQL_ASSOC_ARRAY($sth)) {
			$pool_leads[] = $data;
		}
		echo json_encode(array("data"=>$pool_leads));
	}

}

else {
	echo json_encode("nothing");
}




exit;
$sth = SQL_QUERY("
	select 
		* 
	from contacts_rel_users 
	where user_id='".SQL_CLEAN($_SESSION['user_id'])."' 
	and is_deleted != 1 
	and contact_id='".SQL_CLEAN($_POST['id'])."' 
	limit 1
");
if (SQL_NUM_ROWS($sth) == 0) {
	print "0";
	exit;
}

$sth = SQL_QUERY("select * from campaigns_rel_contacts where contact_id='".SQL_CLEAN($_POST['id'])."' and campaign_id='".SQL_CLEAN($_POST['campaign'])."' limit 1");
if (SQL_NUM_ROWS($sth) != 0) {
	print "0";
	exit;
}

SQL_QUERY("
	insert into campaigns_rel_contacts 
	(
		user_id
		, contact_id
		, date_added
		, campaign_id
	) values (
		'".SQL_CLEAN($_SESSION['user_id'])."'
		, '".SQL_CLEAN($_POST['id'])."'
		, NOW()
		, '".SQL_CLEAN($_POST['campaign'])."'
	)
");

print "1";
exit;

	
?>