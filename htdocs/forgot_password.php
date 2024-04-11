<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

if (isset($_POST) && !empty($_POST)) {
	$sth = SQL_QUERY("select * from users where email ='".SQL_CLEAN($_POST['email'])."'");

	// email exists
	if (SQL_NUM_ROWS($sth) != 0) {

		$temp = SQL_ASSOC_ARRAY($sth);
		$user_id = $temp['user_id'];
		$random = generate_random_string(20);
		$host = $_SERVER['HTTP_HOST'];
		// $host = "fcc.local";

		$sth = SQL_QUERY("update users set temporary_password='".$random."' where email='".SQL_CLEAN($_POST['email'])."'");

		// $result = send_message("support@zugent.com", 
		// 		array(SQL_CLEAN($_POST['email']),"support@zugent.com"), 
		// 		"Important message from support@zugent.com", 
		// 		'<h1 style="text-align:center;">ZugEnt Forgot Password</h1> <br><br> Click <a href="http://'.$host."/forgot_password_verify.php?gen_string=".$random."&user_id=".$user_id.'"> here </a>to reset and change your password.');

		$result = send_message("support@ruopen.com", 
				array(SQL_CLEAN($_POST['email']),"support@ruopen.com"), 
				"Important message from support@ruopen.com", 
                '<tr>
                    <td class="last">
                        <h4>RUOPEN Forgot Password</h4>
                        <p class="m-b-5">Please click the following URL to enter a new password:</p>
                    </td>
                </tr>
                <tr>
                    <td class="panel">
                        <a href="https://'.$host."/forgot_password_verify.php?gen_string=".$random."&user_id=".$user_id.'">http://'.$host."/forgot_password_verify.php?gen_string=".$random."&user_id=".$user_id.'</a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p class="m-t-15 last">If clicking the URL above does not work, copy and paste the URL into a browser window.</p>
                    </td>
                </tr>');
		if($result)
			$smarty->assign("display_message", TRUE);
	}
	else {
		// email does not exist
		// die("");
		$smarty->assign("not_found", TRUE);
	}

}

$smarty->display("forgot_password.tpl");
	
?>