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
	$val = 0;
	if ($_POST['value'] == "true") 
		$val = 1;
	$sth = SQL_QUERY("update transaction_checklist_step set has_agent_checkbox=".$val." where checklist_step_id=".SQL_CLEAN($_POST['step_id']));
	
	echo json_encode(true);
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