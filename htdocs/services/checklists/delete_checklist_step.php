<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xts7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'transaction_checklist_step',
	"main_table_field" => 'checklist_step_id',
	"main_field_value" => $_POST['step_id'],
	"table_join_name" => 'transaction_checklists',
	"table_join_field" => 'checklist_id',
	"additional_where" => array(
		"t1.checklist_id" => $_POST['checklist_id'],
		"t2.checklist_id" => $_POST['checklist_id'],
		"t2.company_id" => $_SESSION['user']['company_id']
	)
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['step_id'])){

	// TODO check if buckets have connected contacts
	$sth = SQL_QUERY("delete from transaction_checklist_step where checklist_step_id=".SQL_CLEAN($_POST["step_id"]));

	// Add checklist log
	add_user_log("Deleted a checklist step (".$_POST['step_id'].")", "checklist", array("importance" => "Info", "action" => "Delete") );

	// TODO Before delete all status, for each connected status delete child sub status
	echo json_encode($sth);
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xts7");
	}
}

?>