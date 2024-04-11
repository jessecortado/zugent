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

	$sth = SQL_QUERY("
		select
			cac.*, u.first_name, u.last_name
		from contact_appointment_comments as cac
		left join users as u using(user_id) 
		where cac.contact_appointment_id='".SQL_CLEAN($_POST['contact_appointment_id'])."'
	");

	$contact_appointment_comments = array();
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$data['date_comment'] = date_format(new DateTime(convert_to_local($data['date_comment'])), "M d, Y h:i a");
		$contact_appointment_comments[] = $data;
	}

	echo json_encode(array("data"=>$contact_appointment_comments));

}
// else {
// 	echo json_encode(array("text" => "No contact appointment id sent (complete_appointment)", "sent" => $_POST));
// }
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1x0c7");
	}
}

?>