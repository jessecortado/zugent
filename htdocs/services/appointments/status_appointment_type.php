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
		"t2.company_id" => $_SESSION['user']['company_id']
		)
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['appointment_type_id'])){
	$sth = SQL_QUERY("
			update appointment_types set
				is_active=".SQL_CLEAN($_POST['is_active'])." where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and appointment_type_id=".$_POST['appointment_type_id']."
		");
	
	// Add appointment log
	add_user_log("Set a contact appointment (".$_POST['contact_appointment_id'].") to is_active=".$_POST['is_active'], "appointments", array("importance" => "Info", "action" => "Status") );

	echo json_encode(array('msg'=>true, 'appointment_type_id'=>$_POST['appointment_type_id'], 'appointment_type'=>$_POST['appointment_type'], 'appointment_icon'=>$_POST['appointment_icon']));
}
else {
	if ($is_ajax) {
		echo json_encode(array('msg'=>false));
	}
	else {
		header("location: /dashboard.php?code=1xat7");
	}
}

?>