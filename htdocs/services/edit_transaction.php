<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

$sth = SQL_QUERY("select t.* 
					from transactions as t 
					left join users as u on u.user_id=t.user_id 
					where t.transaction_id=".SQL_CLEAN($_POST['transaction_id'])." and u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])
				);

if (SQL_NUM_ROWS($sth) == 0) {
	print "0";
	exit;
}

SQL_QUERY("
	update transactions set 
		date_modified=NOW()"."
		, transaction_description='".SQL_CLEAN($_POST['transaction_description'])."'
		, transaction_type_id='".SQL_CLEAN($_POST['transaction_type_id'])."'
		, transaction_status_id='".SQL_CLEAN($_POST['transaction_status_id'])."'
		, date_ended='".date("Y-m-d H:i:s", strtotime(SQL_CLEAN($_POST['date_ended'])))."'
		, date_complete='".date("Y-m-d H:i:s", strtotime(SQL_CLEAN($_POST['date_complete'])))."'
		, date_projected_complete='".date("Y-m-d H:i:s", strtotime(SQL_CLEAN($_POST['date_projected_complete'])))."'
		, date_pending='".date("Y-m-d H:i:s", strtotime(SQL_CLEAN($_POST['date_pending'])))."'
		, is_on_mls='".SQL_CLEAN($_POST['is_on_mls'])."'
		, listing_number='".SQL_CLEAN($_POST['listing_number'])."'
		, street_address='".SQL_CLEAN($_POST['street_address'])."'
		, city='".SQL_CLEAN($_POST['city'])."'
		, state='".SQL_CLEAN($_POST['state'])."'
		, zip='".SQL_CLEAN($_POST['zip'])."' 
		, source_id='".SQL_CLEAN($_POST['source_id'])."' 
		where transaction_id=".SQL_CLEAN($_POST['transaction_id'])."
");
	
// Add transaction log
add_user_log("Updated a transaction's details;
transaction id (".$_POST['transaction_id'].")", "transaction", array("importance" => "Info", "action" => "Update") );

header("location: /transaction/".$_POST['transaction_id']);

exit;

	
?>