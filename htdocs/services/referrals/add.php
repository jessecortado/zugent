<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1x0c7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'contacts',
	"main_table_field" => 'contact_id',
	"main_field_value" => $_POST['contact_id'],
	"table_join_name" => 'contacts_rel_users',
	"table_join_field" => 'contact_id',
	"additional_where" => array(
		"t1.contact_id" => $_POST["contact_id"],
		"t1.company_id" => $_SESSION['user']['company_id'],
		"t2.user_id" => $_SESSION['user']['user_id'],
		"t2.contact_id" => $_POST["contact_id"],
		"t2.is_deleted!" => '1'
		)
);

auth_process($data, $is_ajax, TRUE);

$date = date("Y-m-d H:i:s");

if(isset($_POST['referral_source'])){
	$sth = SQL_QUERY("
		insert into 
		contact_referral set 
		referral_source='".SQL_CLEAN($_POST['referral_source']).
		"', contact_id='".SQL_CLEAN($_POST['contact_id']).
		"', user_id='".SQL_CLEAN(SQL_CLEAN($_POST['user_id'])).
		"', date_referral='".SQL_CLEAN($date).
		"', referred_by_user_id=".SQL_CLEAN($_SESSION['user']['user_id']).
		", is_active=1, is_counted=1, is_complete=0"
		);

	$referral_id = SQL_INSERT_ID();

	// Add referral log
	add_user_log("Added a referral (".$referral_id.") for contact (".$_POST['contact_id']." and user (".$_POST['user_id'].")", "referrals", array("importance" => "Info", "action" => "Add") );


	$sth3 = SQL_QUERY("select c.*, concat(rb.first_name, ' ', rb.last_name) as referred_by, concat(rt.first_name, ' ', rt.last_name) as referred_to 
		from contact_referral as c left join users as rb on rb.user_id=c.referred_by_user_id 
		left join users as rt on rt.user_id=c.user_id where c.contact_id=".SQL_CLEAN($_POST['contact_id'])." and c.contact_referral_id=".SQL_CLEAN($referral_id)." limit 1");

	$recently_added_data = array();

	while($data = SQL_ASSOC_ARRAY($sth3)) {
		$recently_added_data[] = $data;
	}

	echo json_encode(array('msg'=>true, 'data'=>$recently_added_data));
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