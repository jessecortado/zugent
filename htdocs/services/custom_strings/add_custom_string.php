<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xcus7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);


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

	// Add company variable log (Add)
	add_user_log("Added a company variable (".$company_variable_id.")", "company_variables", array("importance" => "Info", "action" => "Add") );

	echo json_encode(array('msg'=>true, 'company_variable_id'=>$company_variable_id, 'var_key'=>$_POST['var_key'], 'var_val'=>$_POST['var_val']));
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xcus7");
	}
}

?>