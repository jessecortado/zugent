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
	"main_table_name" => 'transaction_checklists',
	"main_table_field" => 'checklist_id',
	"main_field_value" => $_POST['checklist_id'],
	"table_join_name" => 'users',
	"table_join_field" => 'company_id',
	"additional_where" => array(
		"t1.company_id" => $_SESSION['user']['company_id'],
		"t2.company_id" => $_SESSION['user']['company_id']
	)
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['checklist_id'])){

	if ($_POST["is_active"] == 'active') {
		$set_active = 0;
	}
	else {
		$set_active = 1;
	}

	$sth = SQL_QUERY("update transaction_checklists set is_active=".SQL_CLEAN($set_active)." where checklist_id=".SQL_CLEAN($_POST["checklist_id"]));

	// Add checklist log
	add_user_log("Set a checklist step to is_active=".$set_active." (".$_POST['step_id'].")", "checklist", array("importance" => "Info", "action" => "Status") );

	$sth3 = SQL_QUERY("select tc.*, CONCAT(u1.first_name,' ',u1.last_name) as created_by, CONCAT(u2.first_name,' ',u2.last_name) as modified_by from transaction_checklists as tc
					left join users as u1 on u1.user_id=tc.created_user_id 
					left join users as u2 on u2.user_id=tc.modified_user_id 
					where tc.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])."  and tc.checklist_id=".SQL_CLEAN($_POST['checklist_id'])." limit 1");

	$recently_added_data = array();

	while($data = SQL_ASSOC_ARRAY($sth3)) {
		$recently_added_data[] = $data;
	}

	echo json_encode(array('msg'=>$sth, 'data'=>$recently_added_data));
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