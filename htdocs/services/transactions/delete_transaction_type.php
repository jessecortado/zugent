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
	"main_table_name" => 'transaction_type',
	"main_table_field" => 'transaction_type_id',
	"main_field_value" => $_POST['transaction_type_id'],
	"table_join_name" => 'users',
	"table_join_field" => 'company_id',
	"additional_where" => array(
		"t1.company_id" => $_SESSION['user']['company_id'],
		"t2.user_id" => $_SESSION['user']['user_id'],
		"t2.company_id" => $_SESSION['user']['company_id']
	)
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['transaction_type_id'])){

	$sth = SQL_QUERY("delete from transaction_type where transaction_type_id=".SQL_CLEAN($_POST["transaction_type_id"]));

	// Add transaction log
	add_user_log($_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." (".$_SESSION['user_id'].") "." deleted a transaction_type; id=".$_POST['transaction_type_id'], "transaction", array("importance" => "Info", "action"=>"Delete") );

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