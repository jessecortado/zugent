<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xat7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['appointment_type'])){
	$sth = SQL_QUERY("
			insert into 
				appointment_types set
				appointment_type='".SQL_CLEAN($_POST['appointment_type'])."', company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."',
				appointment_icon='".SQL_CLEAN($_POST['appointment_icon'])."'
		");

	$appointment_type_id = SQL_INSERT_ID();
	
	// Add appointment log
	add_user_log("Added an appointment type (".$appointment_type_id.")", "appointments", array("importance" => "Info", "action" => "Add") );

	echo json_encode(array('msg'=>true, 'appointment_type_id'=>$appointment_type_id, 'appointment_type'=>$_POST['appointment_type'], 'appointment_icon'=>$_POST['appointment_icon']));
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