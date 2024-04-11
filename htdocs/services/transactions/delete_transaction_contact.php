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

	$process1 = SQL_QUERY("delete from transactions where transaction_id=".SQL_CLEAN($_POST["transaction_id"]));

	// Add transaction log
	add_user_log($_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." (".$_SESSION['user_id'].") "." deleted a transaction; id=".$_POST['transaction_id'], "transaction", array("importance" => "Info", "action"=>"Delete") );

	if ($process1) {
		if ($_POST['has_comments'] == 'true') {
			$process2 = SQL_QUERY("delete from transaction_comments where transaction_id=".SQL_CLEAN($_POST["transaction_id"]));
		}
		if ($_POST['has_files'] == 'true') {
			$process3 = SQL_QUERY("delete from transaction_files where transaction_id=".SQL_CLEAN($_POST["transaction_id"]));
		}
		echo json_encode(true);
	}
	else {
		echo json_encode(false);
	}
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