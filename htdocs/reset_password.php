<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

$content = checkOldPassword();

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	echo checkOldPassword();
	exit;
}

//check old password if is a match
function checkOldPassword() {
	$sth = SQL_QUERY("select * from users where user_id ='".SQL_CLEAN($_SESSION['user_id'])."'");
	$result = SQL_ASSOC_ARRAY($sth);

	if (password_verify($_REQUEST['current_password'], $result['password'])) {
		return json_encode(200);
	}
	else {
		return json_encode(404);
	}
}

if (isset($_POST['new_password'])) {
	$sth = SQL_QUERY("update users set temporary_password='', password='".password_hash(SQL_CLEAN($_POST['new_password']),PASSWORD_DEFAULT)."' where user_id='".SQL_CLEAN($_SESSION['user_id'])."'");

	if($sth)
		session_destroy();
		header("location: /login.php?code=3x092");
}

$smarty->assign('footer_js', 'includes/footers/reset_password.tpl');
$smarty->display('reset_password.tpl');

?>
