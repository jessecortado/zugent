<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1x0u7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'users',
	"main_table_field" => 'user_id',
	"main_field_value" => $_POST['user_id'],
	"additional_where" => array(
		"company_id" => $_SESSION['user']['company_id']
	)
);

auth_process($data, $is_ajax, TRUE);


// if($_SESSION['user']['is_superadmin'] == 0)
// 	exit;

if(isset($_POST['user_id'])){
	$sth = SQL_QUERY("update users set is_admin=".SQL_CLEAN($_POST['is_admin'])." where user_id=".SQL_CLEAN($_POST['user_id']));

	echo json_encode($sth);
	
	// Add set admin log
	add_user_log("Set user (".$_POST['user_id'].") is_admin=".$_POST['is_admin'], "login", array("importance" => "Critical") );
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1x0u7");
	}
}

?>