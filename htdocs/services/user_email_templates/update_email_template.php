<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xue7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, FALSE);


if(isset($_POST['user_email_template_id'])){

	$sth = SQL_QUERY("update user_email_templates set 
		template_name='".SQL_CLEAN($_POST['template_name'])."', 
		subject='".SQL_CLEAN($_POST['template_subject'])."', 
		message='".SQL_CLEAN($_POST['template_body'])."', 
		is_email_type='".SQL_CLEAN($_POST['template_type_email'])."', 
		is_letter_type='".SQL_CLEAN($_POST['template_type_letter'])."' 
		where user_email_template_id=".SQL_CLEAN($_POST['user_email_template_id'])
	);

	header("location: /user_email_templates.php");
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xue7");
	}
}

?>