<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

if(isset($_POST['action'])){

	if($_POST['action'] == "add_checklist"){
		if(isset($_POST['checklist_name'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("
					insert into 
						transaction_checklists set 
						checklist_name='".SQL_CLEAN($_POST['checklist_name'])."', 
						date_added='".SQL_CLEAN($date)."', 
						created_user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."', 
						company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'
				");

			$checklist_id = SQL_INSERT_ID();

			echo json_encode(array('result'=>$sth, 'checklist_id'=>$checklist_id, 'checklist_name'=>$_POST['checklist_name']));
		}
		else {
			echo json_encode("No checklist sent");
		}
	}

	elseif($_POST['action'] == "add_checklist_step"){
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

			header("location: /transaction_checklist_edit.php?checklist_id=".$_POST['checklist_id']);
		}
		else {
			echo json_encode("No bucket sent");
		}
	}
	elseif($_POST['action'] == "disable_checklist"){
		if(isset($_POST['checklist_id'])){

			// TODO check if buckets have connected contacts
			$sth = SQL_QUERY("update transaction_checklists set is_active=0 where checklist_id=".SQL_CLEAN($_POST["checklist_id"]));

			// TODO Before delete all status, for each connected status delete child sub status

			echo $sth;
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "enable_checklist"){
		if(isset($_POST['checklist_id'])){

			// TODO check if buckets have connected contacts
			$sth = SQL_QUERY("update transaction_checklists set is_active=1 where checklist_id=".SQL_CLEAN($_POST["checklist_id"]));

			// TODO Before delete all status, for each connected status delete child sub status

			echo $sth;
		}
		else {
			echo json_encode("No id sent");
		}
	}

	elseif($_POST['action'] == "delete_checklist_step"){
		if(isset($_POST['step_id'])){

			// TODO check if buckets have connected contacts
			$sth = SQL_QUERY("delete from transaction_checklist_step where checklist_step_id=".SQL_CLEAN($_POST["step_id"]));

			// TODO Before delete all status, for each connected status delete child sub status

			echo $sth;
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "change_has_agent"){
		if(isset($_POST['step_id'])){
			$val = 0;
			if ($_POST['value'] == "true") 
				$val = 1;
			$sth = SQL_QUERY("update transaction_checklist_step set has_agent_checkbox=".$val." where checklist_step_id=".SQL_CLEAN($_POST['step_id']));
			
			echo json_encode(array("text" => "Success", "sent" => $_POST));
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "change_has_admin"){
		if(isset($_POST['step_id'])){
			$val = 0;
			if ($_POST['value'] == "true") 
				$val = 1;
			$sth = SQL_QUERY("update transaction_checklist_step set has_admin_checkbox=".$val." where checklist_step_id=".SQL_CLEAN($_POST['step_id']));
			
			echo json_encode(array("text" => "Success", "sent" => $_POST));
		}
		else {
			echo json_encode("No id sent");
		}
	}
	else {
		echo json_encode("Something is wrong");
	}

}

exit;

	
?>