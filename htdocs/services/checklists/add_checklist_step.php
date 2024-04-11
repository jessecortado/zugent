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
	"additional_where" => array(
		"checklist_id" => $_POST['checklist_id'],
		"company_id" => $_SESSION['user']['company_id']
	)
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['step_name'])){

	$date = gmdate("Y-m-d H:i:s");

	$sth = SQL_QUERY("
			insert into 
				transaction_checklist_step set 
				step_name='".SQL_CLEAN($_POST['step_name'])."', 
				step_tooltip='".SQL_CLEAN($_POST['step_tooltip'])."', 
				due_event='".SQL_CLEAN($_POST['due_event'])."', 
				due_days='".SQL_CLEAN($_POST['due_days'])."', 
				checklist_id='".SQL_CLEAN($_POST['checklist_id'])."'
		");

	$step = SQL_INSERT_ID();
	
	// Add checklist log
	add_user_log("Added a checklist step (".$step.")", "checklist", array("importance" => "Info", "action" => "Add") );

	$sth3 = SQL_QUERY("select *, 
					case due_event
					  when 'After Checklist Added' then 1
					  when 'After Mutual' then 2
					  when 'After Closing' then 3
					  else 0
					end as num_due_event 
					from transaction_checklist_step 
					where checklist_step_id=".SQL_CLEAN($step)." 
					order by num_due_event,due_days limit 1");

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