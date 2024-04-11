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


$column = SQL_CLEAN($_POST['column']);
$date = SQL_CLEAN($_POST['date']);
if(isset($_POST['column'])){
	$sth = SQL_QUERY("update transactions set $column='".$date."' where transaction_id=".SQL_CLEAN($_POST['transaction_id']));
	
    // Add transaction log
	add_user_log("Changed a transaction date: ".$column."=".$date." for transaction id (".$_POST['transaction_id'].")", "transaction", array("importance" => "Info", "action"=>"Update") );

	echo json_encode(true);
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