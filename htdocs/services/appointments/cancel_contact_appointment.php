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
		"t2.contact_id" => $_POST['contact_id'],
		"t1.contact_id" => $_POST['contact_id'],
		"t2.company_id" => $_SESSION['user']['company_id'],
		"t1.is_completed" => '0',
		"t1.is_cancelled" => '0'
		)
);

auth_process($data, $is_ajax);


if(isset($_POST['contact_appointment_id'])){

	$date = gmdate("Y-m-d H:i:s");
	$sth = SQL_QUERY("update contact_appointments set is_completed='0', is_cancelled='1', date_completed='".$date."' where contact_appointment_id=".SQL_CLEAN($_POST['contact_appointment_id']));

	$comment = "<p><b>Appointment cancelled by ".$_SESSION['user']['first_name']." ".$_SESSION['user']['last_name'].".</b></p>";

	$sth2 = SQL_QUERY("
			insert into 
				contact_comments set
				comment='".$comment.
				"', contact_id='".SQL_CLEAN($_POST['contact_id']).
				"', is_history='1".
				"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
				"', date_added='".$date."'
		");
	
	// Add appointment log
	add_user_log("Cancelled a contact appointment (".$_POST['contact_appointment_id'].")", "appointments", array("importance" => "Info", "action" => "Delete") );

	$sth3 = SQL_QUERY("select ca.*, at.appointment_type, u.first_name, u.last_name from contact_appointments as ca 
					left join appointment_types as at on ca.appointment_type_id=at.appointment_type_id 
					left join users as u on ca.user_id=u.user_id where ca.contact_id=".SQL_CLEAN($_POST['contact_id'])." and ca.contact_appointment_id = ".SQL_CLEAN($_POST['contact_appointment_id'])." limit 1");

	$recent_data = array();

	while($data = SQL_ASSOC_ARRAY($sth3)) {
		$recent_data[] = $data;
	}

	echo json_encode(array('msg'=>true, 'data'=>$recent_data, 'comment'=>$comment));
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