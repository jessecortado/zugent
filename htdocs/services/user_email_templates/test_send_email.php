<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

ini_set('default_charset', 'UTF-8');

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xue7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);


if ($_POST['template_id']) {

	// GET EMAIL TEMPLATE
	$sth = SQL_QUERY("select * from user_email_templates where user_email_template_id=".$_POST['template_id']." limit 1");

	$template = array();

	if (SQL_NUM_ROWS($sth) == 1) {

		while ($data = SQL_ASSOC_ARRAY($sth)) {
			$template[] = $data;
		}

		send_message(
			"", 
		    array($_SESSION['user']['email'], "Zugent Test Email Template"), 
		    $template[0]['subject'], 
		    $template[0]['message']
		);

		echo json_encode(true);

	}
	else {
		echo json_encode(false);
	}
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