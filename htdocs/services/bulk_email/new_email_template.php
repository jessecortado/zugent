<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xbe7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, FALSE);


if(isset($_POST['action']) && $_POST['action'] == 'new_email_template'){

	$sth = SQL_QUERY("insert into bulk_templates (user_id,company_id,name,is_active,date_created) 
			values (
				'".SQL_CLEAN($_SESSION['user_id'])."',
				'".SQL_CLEAN($_SESSION['user']['company_id'])."',
				'".SQL_CLEAN($_POST['template_name'])."',
				1,
				NOW()
			)");

	$bulk_template_id = SQL_INSERT_ID();

	echo json_encode(array('msg'=>true, 'bulk_template_id'=>$bulk_template_id));
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xbe7");
	}
}

?>