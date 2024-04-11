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


if(isset($_POST['bulk_template_id'])){

	$sth = SQL_QUERY("update bulk_templates set 
		name='".SQL_CLEAN($_POST['template_name'])."', 
		subject='".SQL_CLEAN($_POST['template_subject'])."', 
		body='".SQL_CLEAN($_POST['template_body'])."', 
		is_company_shared='".SQL_CLEAN($_POST['template_shared'])."', 
		is_active='".SQL_CLEAN($_POST['template_active'])."', 
		date_updated=NOW() 
		where bulk_template_id=".SQL_CLEAN($_POST['bulk_template_id'])
	);

	header("location: /bulk_email_templates.php");
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