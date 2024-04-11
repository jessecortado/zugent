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

	$sth = SQL_QUERY("select * from user_email_templates where user_email_template_id=".$_POST['user_email_template_id']." limit 1");

	$template = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$template[] = $data;
	}

	echo json_encode(array('msg'=>true,'template'=>$template));
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