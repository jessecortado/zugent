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


$date = gmdate("Y-m-d H:i:s");

$sth = SQL_QUERY("update transaction_files set ".
	"is_deleted=0".
	" where transaction_file_id=".SQL_CLEAN($_POST['transaction_file_id']).
	" and transaction_id=".SQL_CLEAN($_POST['transaction_id'])
	);

// header("location: /transaction/".$_POST["transaction_id"]."/#transactionFilesTbl");

// Add transaction log
add_user_log("Restored transaction file (".$_POST['transaction_file_id'].") for transaction (".$_POST['transaction_id'].")", "transaction", array("importance" => "Info", "action"=>"Restore") );

echo json_encode(array("result"=>$sth));

// header("location: /transaction/".$_POST['transaction_id']);

exit;


