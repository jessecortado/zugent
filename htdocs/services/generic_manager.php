<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

if(isset($_POST['action'])){

	if($_POST['action'] == "edit_my_profile"){
		
		$column = SQL_CLEAN($_POST['column']);

		$sth = SQL_QUERY("Update users set $column='".SQL_CLEAN($_POST['value'])."' where user_id=".SQL_CLEAN($_SESSION['user_id']));

		$_SESSION['user'][$column] = SQL_CLEAN($_POST['value']);

		echo json_encode(array("result"=>$sth));
		
	}
	elseif ($_POST['action'] == "edit_company_variable") {
		
		$column = SQL_CLEAN($_POST['column']);

		$sth = SQL_QUERY("Update company_variables set $column='".SQL_CLEAN($_POST['value'])."' where company_variable_id=".SQL_CLEAN($_POST['id']));

		echo json_encode(array("result"=>$sth));

	}
	elseif ($_POST['action'] == "insert_records") {

		$table = SQL_CLEAN($_POST['table']);
		$fields = SQL_CLEAN($_POST['fields']);
		$values = SQL_CLEAN($_POST['values']);

		$sql = "INSERT INTO $table (";

		foreach ($fields as $row) {
			$sql .= "";
		}

	}
	elseif ($_POST['action'] == "edit_user") {
		
		$column = SQL_CLEAN($_POST['column']);

		$sth = SQL_QUERY("Update users set $column='".SQL_CLEAN($_POST['value'])."' where user_id=".SQL_CLEAN($_POST['user_id']));

		echo json_encode(array("result"=>$sth));

	}

}
else
	echo json_encode("No Action Sent");


exit;

	
?>