<?php
require_once($_SERVER['SITE_DIR']."/includes/common.php");

if($_POST['action'] == "reset_random"){
  $to = $_POST['email'];
  $from = "support@ruopen.com";
  $pass = $_POST['pass_val'];
  $subject = "Reset Password";
  $user_id = $_POST['id'];
  $body = "Your password to the RUOpen agent portal has been reset. Your new password is {$pass}. To login browse to <a href='https://crm.zugent.com'>https://crm.zugent.com</a>.";

  $sth = SQL_QUERY("update users set temporary_password='', password='".password_hash(SQL_CLEAN($pass),PASSWORD_DEFAULT)."' where user_id='".$user_id."'");
  if($_POST['email_to_user'] == "send_email"){
    $send_mail = send_message_to_contact($to, $from, $subject, $body);
  }
  header("location: /users_list.php");
  exit;
}

function send_message_to_contact($to, $from, $subject, $body, $bcc=false) {
	global $smarty;
	$mail_array = array('subject' => $subject, 'body' => $body);

	$smarty->assign('mail_to', $to);
	$smarty->assign('mail', $mail_array);
	$smarty->assign('body', $body);

	$message_body = $smarty->fetch("email_templates/standard_new.tpl");

	$mail = new PHPMailer;
	$mail->isSMTP();
	$mail->Host = 'ssl://email-smtp.us-west-2.amazonaws.com';

	$mail->SMTPAuth = true;
	$mail->Username = 'AKIAJN22CVQO3RCBUGYA';
	$mail->Password = 'AnVynA9xT3YijjIlmcF2Z8DNCgPb4CYGbnRNORTsBY0B';

	$mail->SMTPSecure = 'tls';
	$mail->Port = 443;
	$mail->IsHTML(true);

	$mail->Subject = $subject;
	$mail->Body    = $message_body;
	$mail->AltBody = "";

	$mail->AddReplyTo($from);
	$mail->SetFrom("support@ruopen.com");

	$mail->addAddress($to);
	if ($bcc == "true") {
		$mail->AddBCC($_SESSION['user']['email']);
	}

	$ret = $mail->Send();
	//print_r($ret);
	return $ret;
}

?>
