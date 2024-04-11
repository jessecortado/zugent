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


function encrypt($sData) {
	$id = (double) $sData * 845672.35;
	return base64_encode($id);
}

function send_message_to_contact($to, $from, $subject, $body, $bcc, $cid) {
	global $smarty;
	$mail_array = array('subject' => $subject, 'body' => $body);

	$encryptCID = encrypt($cid);

	$unsubscribe_link = 'https://'.$_SERVER['HTTP_HOST'].'/unsubscribe.php?contact='.$encryptCID;

	//Get Company Details
	$sth = SQL_QUERY("select * from companies where company_id=".$_SESSION['user']['company_id']." limit 1");

	$company = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$company[] = $data;
	}

	$smarty->assign('mail_to', $to);
	$smarty->assign('mail', $mail_array);
	$smarty->assign('body', $body);
	$smarty->assign('agent', $_SESSION['user']);
	$smarty->assign('company', $company);
	$smarty->assign('unsubscribe_link', $unsubscribe_link);

	$message_body = $smarty->fetch("email_templates/send_email_contacts.tpl");

	$mail = new PHPMailer;
	$mail->isSMTP();
	$mail->Host = 'ssl://email-smtp.us-west-2.amazonaws.com';
	
	$mail->SMTPAuth = true;
	$mail->Username = 'AKIAJN22CVQO3RCBUGYA';
	$mail->Password = 'AnVynA9xT3YijjIlmcF2Z8DNCgPb4CYGbnRNORTsBY0B';
	
	$mail->SMTPSecure = 'tls';
	$mail->Port = 443;
	$mail->IsHTML(true);

	// if(isset($company)) {
	// 	if ($company['logo_file'] == '') {
	// 		$mail->AddEmbeddedImage($_SERVER['SITE_DIR'].'/htdocs/assets/logos/ZugEntLogo.png','logo_cid');
	// 	} else {
	// 		$mail->AddEmbeddedImage($_SERVER['SITE_DIR'].'/htdocs/assets/logos/'.$company['logo_file'],'logo_cid');
	// 	}
	// }
	
	$mail->Subject = $subject;
	$mail->Body    = $message_body;
	$mail->AltBody = "";
	
	$mail->AddReplyTo($from);
	$mail->SetFrom("support@ruopen.com", $_SESSION['user']['first_name'].' '.$_SESSION['user']['last_name']);
	
	$mail->addAddress($to);
	// $mail->Priority = 1;
	if ($bcc == "true") {
		$mail->AddBCC($_SESSION['user']['email']);
	}
	
	$ret = $mail->Send();
	//print_r($ret);
	return $ret;
}


if(isset($_POST['contact_id'])){

	// GET EMAIL SUBJECT, BODY & CONTACT EMAIL
	$contact_id = $_POST['contact_id'];
	$bcc_me = $_POST['bcc_me'];
	$email_subject = $_POST['email_subject'];
	$email_body = $_POST['email_body'];

	$sth = SQL_QUERY("select ce.* from contacts as c 
		left join contact_emails as ce on c.contact_id=ce.contact_id 
		where c.contact_id = '".$contact_id."' limit 1");

	$contact_email = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$contact_email[] = $data;
	}

	send_message_to_contact($contact_email[0]['email'], $_SESSION['user']['email'], $email_subject ,$email_body ,$bcc_me, $contact_id);

	// LOG EMAIL SENT
	SQL_QUERY("insert into contact_email_send_log (contact_id,user_id,subject,message,date_sent) 
				values (
					'".SQL_CLEAN($contact_id)."',
					'".SQL_CLEAN($_SESSION['user_id'])."',
					'".SQL_CLEAN($email_subject)."',
					'".SQL_CLEAN(json_encode($email_body))."',
					NOW()
				)");

	echo json_encode(array('msg'=>true));
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