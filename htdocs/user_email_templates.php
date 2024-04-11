<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth(false, true);

$sth = SQL_QUERY("select * from user_email_templates where user_id='".SQL_CLEAN($_SESSION['user_id'])."' and is_deleted = 0");

$email_templates = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$email_templates[] = $data;
}

$smarty->assign('email_templates', $email_templates);
$smarty->assign('footer_js', 'includes/footers/user_email_templates_footer.tpl');
$smarty->display('user_email_templates.tpl');

?>