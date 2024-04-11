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
	"main_table_name" => 'contact_referral',
	"main_table_field" => 'contact_referral_id',
	"main_field_value" => $_POST['referral_id'],
	"table_join_name" => 'contacts',
	"table_join_field" => 'contact_id',
	"additional_where" => array(
		"t1.contact_id" => $_POST['contact_id'],
		"t2.company_id" => $_SESSION['user']['company_id'],
		"t2.contact_id" => $_POST['contact_id'],
		"t1.is_active" => '1'
		)
);

auth_process($data, $is_ajax, TRUE);

if(isset($_POST['referral_source'])){

	$date = date("Y-m-d H:i:s");

	$sth = SQL_QUERY("
		select * from contact_referral where contact_referral_id=".SQL_CLEAN($_POST['referral_id']));

	$old = SQL_ASSOC_ARRAY($sth);

	$comment = "Referral was updated on ". $date . " (" . $_SESSION['user']['user_id']."). The ff. changes were made: <br>";

	if($old['user_id'] !== $_POST['user_id'])
		$comment .= "From " . $old['user_id'] . " to " .  $_POST['user_id'] . "<br>";
	if($old['referral_source'] !== $_POST['referral_source'])
		$comment .= "From " . $old['referral_source'] . " to " .  $_POST['referral_source'] . "<br>";
	if($old['referral_bob'] !== $_POST['referral_bob'])
		$comment .= "From " . $old['referral_bob'] . " to " .  $_POST['referral_bob'] . "<br>";

	$sth2 = SQL_QUERY("
		insert into 
		contact_comments set
		comment='".$comment.
		"', contact_id='".SQL_CLEAN($_POST['contact_id']).
		"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
		"', date_added='".$date."'
		");

	$sth = SQL_QUERY("
		update 
		contact_referral set 
		referral_source='".SQL_CLEAN($_POST['referral_source']).
		"', referral_bob='".SQL_CLEAN($_POST['referral_bob']).
		"', user_id='".SQL_CLEAN($_POST['user_id']).
		"', modified_user_id=".SQL_CLEAN($_SESSION['user']['user_id']).
		" where contact_referral_id=".SQL_CLEAN($_POST['referral_id'])
		);

	// Add referral log
	add_user_log("Updated a referral (".$referral_id.")", "referrals", array("importance" => "Info", "action" => "Update") );


	$sth3 = SQL_QUERY("select c.*, concat(rb.first_name, ' ', rb.last_name) as referred_by, concat(rt.first_name, ' ', rt.last_name) as referred_to 
		from contact_referral as c left join users as rb on rb.user_id=c.referred_by_user_id 
		left join users as rt on rt.user_id=c.user_id where c.contact_id=".SQL_CLEAN($_POST['contact_id'])." and c.contact_referral_id=".SQL_CLEAN($_POST['referral_id'])." limit 1");

	$recently_updated_data = array();

	while($data = SQL_ASSOC_ARRAY($sth3)) {
	 	$recently_updated_data[] = $data;
	}

	echo json_encode(array('msg'=>true, 'data'=>$recently_updated_data, 'comment'=>$comment));

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