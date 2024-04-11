<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

if (isset($_POST['password'])) {
	if ($_POST['password'] == $_POST['password_verify']) 
	{
		$host = $_SERVER['HTTP_HOST'];
		// $host = "fcc.local";
		$sth = SQL_QUERY("select * from users where user_id ='".SQL_CLEAN($_POST['user_id'])."'");
		$result = SQL_ASSOC_ARRAY($sth);
		$email = $result['email'];

		$sth = SQL_QUERY("update users set temporary_password='', password='".password_hash(SQL_CLEAN($_POST['password']),PASSWORD_DEFAULT)."' where user_id='".SQL_CLEAN($_POST['user_id'])."'");

		// $result = send_message("support@zugent.com", 
		// 		array($email, "support@zugent.com"), 
		// 		"Important message from support@zugent.com", 
		// 		'Your password has successfully been changed.');

		$result = send_message("support@ruopen.com", 
				array($email, "support@ruopen.com"), 
				"Important message from support@ruopen.com", 
                '<tr>
                    <td class="last">
                        <h4>RUOPEN Password Changed</h4>
                        <p class="m-b-5">Your password has been changed successfully!</p>
                    </td>
                </tr>');

		if($result)
			header("location: /login.php?code=3x092");
		$smarty->display("forgot_password_verify.tpl");
		
	}
}
elseif (isset($_GET['gen_string']) && !empty($_GET['gen_string'])) {
	$sth = SQL_QUERY("select * from users where temporary_password ='".SQL_CLEAN($_GET['gen_string'])."' and user_id = ".SQL_CLEAN($_GET['user_id']));

	if (SQL_NUM_ROWS($sth) != 0) {
		$smarty->assign("user_id", $_GET['user_id']);
		$smarty->assign("temporary_password", $_GET['gen_string']);
		$smarty->display("forgot_password_verify.tpl");
	}

}

die("Please wait");
?>