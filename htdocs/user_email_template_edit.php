<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth(false, true);

if(isset($_GET['id'])) {

	$sth = SQL_QUERY("select * from user_email_templates where user_email_template_id='".SQL_CLEAN($_GET['id'])."' and user_id='".$_SESSION['user_id']."' limit 1");

	if (SQL_NUM_ROWS($sth) > 0) {
		$email_template = array();

		while ($data = SQL_ASSOC_ARRAY($sth)) {
			$email_template[] = $data;
		}

		$smarty->assign('email_template', $email_template);
		$smarty->assign('footer_js', 'includes/footers/user_email_template_edit_footer.tpl');
		$smarty->display('user_email_template_edit.tpl');
	}
	else {
		header("location: /dashboard.php?code=1xue7");
	}

}
else {
	header("location: /dashboard.php?code=1xue7");
}

?>