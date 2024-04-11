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
	"table_join_name" => 'users',
	"table_join_field" => 'user_id',
	"additional_where" => array(
		"t2.user_id" => $_SESSION['user']['user_id'],
		"t2.company_id" => $_SESSION['user']['company_id']
	)
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['transaction_id'])){

	$sth = SQL_QUERY("
		update transactions set 
			date_modified=NOW()"."
			, extended_data='".SQL_CLEAN($_POST['extended_data'])."' 
			where transaction_id=".SQL_CLEAN($_POST['transaction_id'])."
	");

	// Add transaction log
	add_user_log("Updated transaction's extended data; extended_data=".$_POST['extended_data']." for transaction id (".$_POST['transaction_id'].")", "transaction", array("importance" => "Info","action"=>"Update") );

	echo json_encode($sth);
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