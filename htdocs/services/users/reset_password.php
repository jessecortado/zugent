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

// Add reset password user log
add_user_log($_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." (".$_SESSION['user_id'].") "." has reset his/her password.", "login", array("importance" => "Critical") );
	


if(isset($_POST['user_id'])){
	$sth = SQL_QUERY("update users set password='', temporary_password='".password_hash(SQL_CLEAN('1234'),PASSWORD_DEFAULT)."' where user_id=".SQL_CLEAN($_POST['user_id']));

	echo json_encode($sth);
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