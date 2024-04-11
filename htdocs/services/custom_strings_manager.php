<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

if(isset($_POST['action'])){

	if($_POST['action'] == "add_custom_string"){
		
		if(isset($_POST['var_key'])){

			$now = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("insert into company_variables set ".
						"var_key='".SQL_CLEAN($_POST['var_key']).
						"', var_val='".SQL_CLEAN($_POST['var_val']).
						"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
						"', company_id='".SQL_CLEAN($_SESSION['user']['company_id']).
						"', date_modified='".$now.
						"', date_created='".$now.
						"'");

			$company_variable_id = SQL_INSERT_ID();

			echo json_encode(array('result'=>$sth, 'company_variable_id'=>$company_variable_id, 'var_key'=>$_POST['var_key'], 'var_val'=>$_POST['var_val']));
		}
		else {
			echo json_encode("No status sent");
		}
	}
	elseif ($_POST['action'] == "edit_company_variable") {
		
		$column = SQL_CLEAN($_POST['column']);

		$sth = SQL_QUERY("Update company_variables set $column='".SQL_CLEAN($_POST['value'])."' where company_variable_id=".SQL_CLEAN($_POST['id']));

		echo json_encode(array("result"=>$sth));

	}
	elseif($_POST['action'] == "add_campaign_variable"){
		
		if(isset($_POST['var_key'])){

			$now = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("insert into campaign_variables set ".
						"var_key='".SQL_CLEAN($_POST['var_key']).
						"', var_val='".SQL_CLEAN($_POST['var_val']).
						"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
						"', campaign_id='".SQL_CLEAN($_POST['campaign_id']).
						"', date_modified='".$now.
						"', date_created='".$now.
						"'");

			$company_variable_id = SQL_INSERT_ID();

			echo json_encode(array('result'=>$sth, 'campaign_variable_id'=>$company_variable_id, 'var_key'=>$_POST['var_key'], 'var_val'=>$_POST['var_val']));
		}
		else {
			echo json_encode("No status sent");
		}
	}
	elseif ($_POST['action'] == "edit_campaign_variable") {
		
		$column = SQL_CLEAN($_POST['column']);

		$sth = SQL_QUERY("Update campaign_variables set $column='".SQL_CLEAN($_POST['value'])."' where campaign_variable_id=".SQL_CLEAN($_POST['id']));

		echo json_encode(array("result"=>$sth));

	}
	else {
		echo json_encode("Action Not Found");
	}

}
else
	echo json_encode("No Action Sent");


exit;

	
?>