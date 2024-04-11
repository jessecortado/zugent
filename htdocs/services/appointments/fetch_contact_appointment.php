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
		"t2.company_id" => $_SESSION['user']['company_id']
		)
);

auth_process($data, $is_ajax);


if(isset($_POST['contact_appointment_id'])){

	$sth = SQL_QUERY("select c.*, ca.date_appointment, at.appointment_type, ca.description from contact_appointments as ca 
		left join contacts as c on ca.contact_id=c.contact_id 
		left join appointment_types as at on ca.appointment_type_id=at.appointment_type_id 
		where ca.contact_appointment_id='".SQL_CLEAN($_POST['contact_appointment_id'])."'
	");

	$contact_appointment = array();


	if (SQL_NUM_ROWS($sth) > 0) {
		while ($data = SQL_ASSOC_ARRAY($sth)) {
			$contact_appointment[] = $data;
		}

		echo json_encode(array("msg" => true, "data" => $contact_appointment));
	}
	else {
		echo json_encode(array("msg" => false));
	}


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