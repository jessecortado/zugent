<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$sth = SQL_QUERY("select * from contact_referral where contact_referral_id=".SQL_CLEAN($_POST['referral_id']));
$referral_data = SQL_ASSOC_ARRAY($sth);

$data = array(
	"code" => '1x0c7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'contact_referral',
	"main_table_field" => 'contact_referral_id',
	"main_field_value" => $_POST['referral_id'],
	"table_join_name" => 'contacts',
	"table_join_field" => 'contact_id',
	"additional_where" => array(
		"t1.contact_id" => $referral_data['contact_id'],
		"t2.company_id" => $_SESSION['user']['company_id'],
		"t2.contact_id" => $referral_data['contact_id']
		)
);

auth_process($data, $is_ajax, TRUE);

if(isset($_POST['user_id'])){

	if ($_POST["is_active"] == '1') {
		$comment = "Referral has been marked as active.";
	}
	else {
		$comment = "Referral has been marked as inactive.";
	}

	$sth = SQL_QUERY("insert into contact_comments set comment='".$comment."', contact_id='".SQL_CLEAN($referral_data['contact_id'])."', user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."', date_added=NOW()");
	
	SQL_QUERY("update contact_referral set is_active='".SQL_CLEAN($_POST["is_active"])."', modified_user_id='".$_SESSION['user']['user_id']."' where contact_referral_id=".SQL_CLEAN($_POST["referral_id"]));
	
	// Add referral log
	add_user_log("Set a referral (".$referral_id.") to is_active=".$_POST['is_active'], "referrals", array("importance" => "Info", "action" => "Status") );

	$sth3 = SQL_QUERY("select c.*, concat(rb.first_name, ' ', rb.last_name) as referred_by, concat(rt.first_name, ' ', rt.last_name) as referred_to 
		from contact_referral as c left join users as rb on rb.user_id=c.referred_by_user_id 
		left join users as rt on rt.user_id=c.user_id where c.contact_id=".SQL_CLEAN($referral_data['contact_id'])." and c.contact_referral_id=".SQL_CLEAN($_POST['referral_id'])." limit 1");

	$recently_data = array();

	while($data = SQL_ASSOC_ARRAY($sth3)) {
	 	$recently_data[] = $data;
	}

	echo json_encode(array('msg'=>true, 'data'=>$recently_data, 'comment'=>$comment));
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