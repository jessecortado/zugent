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

	$date = gmdate("Y-m-d H:i:s", strtotime(SQL_CLEAN($_POST['date_appointment'])));
	$now = gmdate("Y-m-d H:i:s");

	//get old data and compare
	$sth = SQL_QUERY("select ca.*, at.appointment_type, u.first_name, u.last_name from contact_appointments as ca 
					left join appointment_types as at on ca.appointment_type_id=at.appointment_type_id 
					left join users as u on ca.user_id=u.user_id where ca.contact_appointment_id = ".SQL_CLEAN($_POST['contact_appointment_id'])." limit 1");

	$old = SQL_ASSOC_ARRAY($sth);

	// Get Appointment Type Name
	$sth = SQL_QUERY("select appointment_type from appointment_types where appointment_type_id=".SQL_CLEAN($_POST['appointment_type_id'])." limit 1");

	$selected_appointment_type = SQL_ASSOC_ARRAY($sth);

	$comment = "Appointment was updated on ". $now . " (" . $old['first_name'] . " " . $old['last_name'] . "). The ff. changes were made:<br>";

	if($old['date_appointment'] !== $date) {
		$comment .= "From " . $old['date_appointment'] . " to " .  $date . "<br>";
	}
	if($old['description'] !== $_POST['description']) {
		$comment .= "Description was changed ";
		$comment .= 'From "' . $old['description'] . '" to "' . $_POST['description'] . '"<br>';
	}
	if($old['appointment_type_id'] !== $_POST['appointment_type_id']) {
		$comment .= "Appointment Type was changed ";
		$comment .= 'From "' . $old['appointment_type'] . '" to "' . $selected_appointment_type['appointment_type'] . '"';
	}
	
	$sth = SQL_QUERY("
			update contact_appointments  set
				appointment_type_id='".SQL_CLEAN($_POST['appointment_type_id']).
				"', date_appointment='".$date.
				"', contact_id='".SQL_CLEAN($_POST['contact_id']).
				"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
				"', description='".SQL_CLEAN($_POST['description']).
				"' where contact_appointment_id=".SQL_CLEAN($_POST['contact_appointment_id']));
	
	// Add appointment log
	add_user_log("Update contact appointment (".$_POST['contact_appointment_id'].")", "appointments", array("importance" => "Info", "action" => "Update") );

	$sth2 = SQL_QUERY("
			insert into 
				contact_comments set
				comment='".$comment."'
				, contact_id='".SQL_CLEAN($_POST['contact_id']).
				"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
				"', date_added='".$now."'
		");

	$appointment_type_id = SQL_INSERT_ID();


	$sth = SQL_QUERY("select ca.*, at.appointment_type, u.first_name, u.last_name from contact_appointments as ca 
					left join appointment_types as at on ca.appointment_type_id=at.appointment_type_id 
					left join users as u on ca.user_id=u.user_id where ca.contact_id=".SQL_CLEAN($_POST['contact_id'])." and ca.contact_appointment_id = ".SQL_CLEAN($_POST['contact_appointment_id'])." limit 1");

	$recently_updated_data = array();

	while($data = SQL_ASSOC_ARRAY($sth)) {
		$recently_updated_data[] = $data;
	}

	echo json_encode(array('msg'=>true, 'data'=>$recently_updated_data, 'comment'=>$comment));

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