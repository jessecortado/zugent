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
	"main_table_name" => 'contacts',
	"main_table_field" => 'contact_id',
	"main_field_value" => $_POST['contact_id'],
	"additional_where" => array(
		"company_id" => $_SESSION['user']['company_id']
		)
);

auth_process($data, $is_ajax);


if(isset($_POST['appointment_type_id'])){
	// set_timezone();

	// $date = gmdate("Y-m-d H:i:s", strtotime(SQL_CLEAN($_POST['date_appointment'])));
	$date = date("Y-m-d H:i:s", strtotime(SQL_CLEAN($_POST['date_appointment'])));
	
	$send_result = array();

	$sth = SQL_QUERY("
			insert into 
				contact_appointments set
				appointment_type_id='".SQL_CLEAN($_POST['appointment_type_id']).
				"', date_appointment='".$date.
				"', contact_id='".SQL_CLEAN($_POST['contact_id']).
				"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
				"', description='".SQL_CLEAN($_POST['description'])."'
		");

	$id = SQL_INSERT_ID();
	
	// Add appointment log
	add_user_log("Added contact appointment (".$id.") for contact (".$_POST['contact_id'].")", "appointments", array("importance" => "Info", "action" => "Add") );

	$sth = SQL_QUERY("
			select u.user_id, u.email as user_email, CONCAT(c.first_name,' ',c.last_name) as contact_name from contacts_rel_users as cu 
				left join users as u on cu.user_id=u.user_id 
				left join contacts as c on c.contact_id=cu.contact_id 
				where cu.contact_id=".SQL_CLEAN($_POST['contact_id'])." and cu.is_deleted=0
		");

	while($data = SQL_ASSOC_ARRAY($sth)) {

		$body = $_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." has scheduled a follow-up / contact for you and ".$data['contact_name'].".";
		$body .= "\nClick <a href='".$_SERVER['HTTP_HOST']."/appointment_action.php?id=".$id."'>here</a> to copy this this follow-up / contact schedule to your calendar or to decline this schedule.";
		
		$send_result[] = send_message("support@ruopen.com", 
									array($data['user_email'], "juncalpito@zugent.com"), 
										"A new follow-up / contact has been scheduled for your contact", 
									$body);

		$body = $_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." has scheduled a follow-up / contact for you and ".$data['contact_name'].".";

		// id, title, notification, url_action
		add_notification($data['user_id'], "New Appointment", $body, $_SERVER['HTTP_HOST']."/appointment_action.php?id=".$id);
	}

	$sth3 = SQL_QUERY("select ca.*, at.appointment_type, u.first_name, u.last_name from contact_appointments as ca 
					left join appointment_types as at on ca.appointment_type_id=at.appointment_type_id 
					left join users as u on ca.user_id=u.user_id where ca.contact_id=".SQL_CLEAN($_POST['contact_id'])." and ca.contact_appointment_id = ".SQL_CLEAN($id)." limit 1");

	$recently_added_data = array();

	while($data = SQL_ASSOC_ARRAY($sth3)) {
		$recently_added_data[] = $data;
	}

	echo json_encode(array('msg'=>true, 'data'=>$recently_added_data));
	
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