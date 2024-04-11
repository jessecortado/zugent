<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1x0c7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'contact_appointments',
	"main_table_field" => 'contact_appointment_id',
	"main_field_value" => $_POST['contact_appointment_id'],
	"table_join_name" => 'contacts',
	"table_join_field" => 'contact_id',
	"additional_where" => array(
		"t2.company_id" => $_SESSION['user']['company_id'],
		"t1.is_completed" => '0',
		"t1.is_cancelled" => '0'
		)
);

auth_process($data, $is_ajax);


if(isset($_POST['contact_appointment_id'])){

	$date = gmdate("Y-m-d H:i:s");

	$sth = SQL_QUERY("
			insert into 
				contact_appointment_comments set
				comment='".SQL_CLEAN($_POST['comment']).
				"', contact_appointment_id='".SQL_CLEAN($_POST['contact_appointment_id']).
				"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
				"', date_comment='".$date."'
		");
	
	// Add appointment log
	add_user_log("Added contact appointment comment (".$_POST['contact_appointment_id'].")", "appointments", array("importance" => "Info", "action" => "Add") );

	// header("location: /contacts_edit.php?id=".$_POST['contact_id']);
	// echo json_encode(array("text"=>"Success","sent"=>$_POST));
	echo json_encode(true);

}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1x0c7");
	}
}

?>