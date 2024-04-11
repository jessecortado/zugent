<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xft7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);

if(isset($_POST['name'])){
	$sth = SQL_QUERY("
			insert into 
				file_types set 
				name='".SQL_CLEAN($_POST['name']).
				"', sequence='".SQL_CLEAN($_POST['sequence']).
				"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
				"', is_deleted=0, ".
				"company_id='".SQL_CLEAN($_SESSION['user']['company_id'])
				."'");

	$file_type_id = SQL_INSERT_ID();

	// Add file type log
	add_user_log("Added a file_type (".$file_type_id.")", "file_types", array("importance" => "Info", "action" => "Add") );

	echo json_encode(array('msg'=>true, 'file_type_id'=>$file_type_id, 'name'=>$_POST['name'], 'sequence'=>$_POST['sequence'] , 'user_id'=>$_SESSION['user']['user_id'] , 'company_id'=>$_SESSION['user']['company_id'] ));
}
else {
	if ($is_ajax) {
		echo json_encode(array('msg'=>false));
	}
	else {
		header("location: /dashboard.php?code=1xft7");
	}
}

?>