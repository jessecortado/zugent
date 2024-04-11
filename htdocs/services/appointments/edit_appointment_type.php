<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xat7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'appointment_types',
	"main_table_field" => 'appointment_type_id',
	"main_field_value" => $_POST['appointment_type_id'],
	"table_join_name" => 'users',
	"table_join_field" => 'company_id',
	"additional_where" => array(
		"t2.user_id" => $_SESSION['user']['user_id'],
		"t1.company_id" => $_SESSION['user']['company_id'],
		"t2.company_id" => $_SESSION['user']['company_id'],
		"t1.is_active" => '1'
		)
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['appointment_type_id'])){
	
	$sth = SQL_QUERY("
			update appointment_types set
				".SQL_CLEAN($_POST['appointment_column'])."='".SQL_CLEAN($_POST['value'])."' where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and appointment_type_id=".SQL_CLEAN($_POST['appointment_type_id']));

	
	// Add appointment log
	add_user_log("Updated an appointment type (".$_POST['appointment_type_id'].")", "appointments", array("importance" => "Info", "action" => "Update") );

	echo json_encode(true);
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xat7");
	}
}

?>