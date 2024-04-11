<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xts7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'transactions',
	"main_table_field" => 'transaction_id',
	"main_field_value" => $_POST['transaction_id'],
	"table_join_name" => 'contacts',
	"table_join_field" => 'contact_id',
	"additional_where" => array(
		"t2.company_id" => $_SESSION['user']['company_id']
	)
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['transaction_id'])){

	$sth1 = SQL_QUERY("select * from transactions where transaction_id=".SQL_CLEAN($_POST['transaction_id']));
	$sth2 = SQL_QUERY("select * from transaction_comments where transaction_id=".SQL_CLEAN($_POST['transaction_id']));
	$sth3 = SQL_QUERY("select * from transaction_files where transaction_id=".SQL_CLEAN($_POST['transaction_id']));

	// TODO check if status has connected contacts or has status/sub status
	if (SQL_NUM_ROWS($sth2) > 0 && SQL_NUM_ROWS($sth3) > 0) {
		$msg = "You won't be able to revert this!<br>";
		$msg .= "Transaction has ".SQL_NUM_ROWS($sth1)." file/s attached.<br>";
		$msg .= "Please confirm if you still want to delete.";
		$has_comments = true;
		$has_files = true;
	}
	else if (SQL_NUM_ROWS($sth2) == 0 && SQL_NUM_ROWS($sth3) > 0) {
		$msg = "You won't be able to revert this!<br>";
		$msg .= "Transaction has ".SQL_NUM_ROWS($sth1)." file/s attached.<br>";
		$msg .= "Please confirm if you still want to delete.";
		$has_comments = false;
		$has_files = true;
	}
	else if (SQL_NUM_ROWS($sth2) > 0 && SQL_NUM_ROWS($sth3) == 0) {
		$msg = "You won't be able to revert this!<br>";
		$msg .= "Please confirm if you still want to delete.";
		$has_comments = true;
		$has_files = false;
	}
	else {
		$msg = "You won't be able to revert this!<br>";
		$msg .= "Please confirm if you still want to delete.";
		$has_comments = false;
		$has_files = false;
	}

	echo json_encode(array("connected"=>true, "msg"=>$msg, "has_comments"=>$has_comments, "has_files"=>$has_files));
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xts7");
	}
}

?>