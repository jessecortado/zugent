<?php

	
require_once($_SERVER['SITE_DIR']."/includes/common.php");
	
if(isset($_POST['action'])){
	
	if($_POST['action'] == "add_transaction_type"){
		if(isset($_POST['transaction_type'])){

			$sth = SQL_QUERY("insert into transaction_type set ".
				" transaction_type='".SQL_CLEAN($_POST["transaction_type"]).
				"', company_id=".SQL_CLEAN($_POST["company_id"])
				);

			// header("location: /contacts_edit.php?id=".$_POST["contact_id"]);
			$transaction_type_id = SQL_INSERT_ID();

			echo json_encode(array('result'=>$sth, 'transaction_type_id'=>$transaction_type_id, 'transaction_type'=>$_POST['transaction_type']));
		}
		else {
			echo json_encode("No transaction type sent");
		}
	}
	
	elseif($_POST['action'] == "add_transaction_status"){
		if(isset($_POST['transaction_status'])){


			$sth = SQL_QUERY("insert into transaction_status set ".
				" transaction_status='".SQL_CLEAN($_POST["transaction_status"]).
				"', company_id=".SQL_CLEAN($_POST["company_id"])
				);

			// header("location: /contacts_edit.php?id=".$_POST["contact_id"]);
			$transaction_type_id = SQL_INSERT_ID();

			echo json_encode(array('result'=>$sth, 'transaction_status_id'=>$transaction_type_id, 'transaction_status'=>$_POST['transaction_status']));
		}
		else {
			echo json_encode("No transaction status sent");
		}
	}

	elseif($_POST['action'] == "delete_transaction_status"){
		if(isset($_POST['transaction_status_id'])){

			$sth = SQL_QUERY("delete from transaction_status where transaction_status_id=".SQL_CLEAN($_POST["transaction_status_id"]));

			$transaction_status_id = SQL_INSERT_ID();


			echo json_encode(array('result'=>$sth, 'transaction_status_id'=>$transaction_status_id));
		}
		else {
			echo json_encode("No id sent");
		}
	}
	
	elseif($_POST['action'] == "delete_transaction_type"){
		if(isset($_POST['transaction_type_id'])){

			$sth = SQL_QUERY("delete from transaction_type where transaction_type_id=".SQL_CLEAN($_POST["transaction_type_id"]));

			echo json_encode(array('result'=>$sth, 'transaction_type_id'=>$_POST["transaction_type_id"]));
		}
		else {
			echo json_encode("No id sent");
		}
	}

	elseif($_POST['action'] == "add_contact_transaction"){
		if(isset($_POST['transaction_type_id'])){

			$date = gmdate("Y-m-d H:i:s");
			$sth = SQL_QUERY("
					insert into 
						transactions set 
						transaction_description='".SQL_CLEAN($_POST['description']).
						"', transaction_type_id='".SQL_CLEAN($_POST['transaction_type_id']).
						"', transaction_status_id='".SQL_CLEAN($_POST['transaction_status_id']).
						"', date_created='".SQL_CLEAN($date).
						"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
						"', contact_id='".SQL_CLEAN($_POST['contact_id'])
						."'");

			header("location: /contacts_edit.php?id=".$_POST["contact_id"]);
			// echo $sth;
			// $transaction_id = SQL_INSERT_ID();

			// echo json_encode(array('result'=>$sth, 'transaction_id'=>$transaction_id, 'name'=>$_POST['name'], 'sequence'=>$_POST['sequence'] ));
		}
		else {
			echo json_encode("No tid sent");
		}
	}

	elseif($_POST['action'] == "edit_transaction_status"){
		if(isset($_POST['transaction_status_id'])){
			$data = gmdate("Y-m-d H:i:s");
			$sth = SQL_QUERY("update transactions set date_modified='".$date."'transaction_status_id='".SQL_CLEAN($_POST['transaction_status_id'])."' where transaction_id=".SQL_CLEAN($_POST['transaction_id']));
			
			echo json_encode(array("text" => "Success", "sent" => $_POST));
		}
		else {
			echo json_encode("No id sent");
		}
	}

	elseif($_POST['action'] == "edit_transaction_type"){
		if(isset($_POST['transaction_type_id'])){
			$data = gmdate("Y-m-d H:i:s");
			$sth = SQL_QUERY("update transactions set date_modified='".$date."' transaction_type_id='".SQL_CLEAN($_POST['transaction_type_id'])."' where transaction_id=".SQL_CLEAN($_POST['transaction_id']));
			
			echo json_encode(array("text" => "Success", "sent" => $_POST));
		}
		else {
			echo json_encode("No id sent");
		}
	}

	elseif($_POST['action'] == "get_transaction_status"){
		if(isset($_POST['company_id'])){
			$sth = SQL_QUERY("select * from transaction_status where company_id='".SQL_CLEAN($_POST["company_id"])."'");

			$status = array();
			while ($data = SQL_ASSOC_ARRAY($sth)) {
				$status[] = $data;
			}
			
			echo json_encode(array("data"=>$status));
		}
		else {
			echo json_encode("No company id sent");
		}
	}

	elseif($_POST['action'] == "get_transaction_types"){
		if(isset($_POST['company_id'])){
			$sth = SQL_QUERY("select * from transaction_type where company_id='".SQL_CLEAN($_POST["company_id"])."'");

			$status = array();
			while ($data = SQL_ASSOC_ARRAY($sth)) {
				$status[] = $data;
			}
			
			echo json_encode(array("data"=>$status, "count"=>count($status)));
		}
		else {
			echo json_encode("No company id sent");
		}
	}

	elseif($_POST['action'] == "edit_transaction_date"){
		$column = SQL_CLEAN($_POST['column']);
		$date = SQL_CLEAN($_POST['date']);
		if(isset($_POST['column'])){
			$data = gmdate("Y-m-d H:i:s");
			$sth = SQL_QUERY("update transactions set $column='".$date."' where transaction_id=".SQL_CLEAN($_POST['transaction_id']));
			
			echo json_encode(array("text" => "Success", "sent" => $_POST));
		}
		else {
			echo json_encode("No id sent");
		}
	}

}
else 
{
	echo json_encode("No Action sent");
}