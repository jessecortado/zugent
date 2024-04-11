
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


function bulk_send_message($to, $subject, $body) {
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

	if(isset($company)) {
		if ($company['logo_file'] == '') {
			$mail->AddEmbeddedImage($_SERVER['SITE_DIR'].'/htdocs/assets/logos/ZugEntLogo.png','logo_cid');
		} else {
			$mail->AddEmbeddedImage($_SERVER['SITE_DIR'].'/htdocs/assets/logos/'.$company['logo_file'],'logo_cid');
		}
	}
	
	$mail->Subject = $subject;
	$mail->Body    = $message_body;
	$mail->AltBody = "";
	
	// $mail->AddReplyTo($from[0], $from[1]);
	$mail->SetFrom("support@ruopen.com", "RUOPEN Mail");
	
	$mail->addAddress($to[0], $to[1], 34);
	// $mail->Priority = 1;
	
	$ret = $mail->Send();
	//print_r($ret);
	return $ret;
}


if(isset($_POST['email_template'])){

	// GET EMAIL SUBJECT, BODY & CONTACTS FILTERED
	$email_template = $_POST['email_template'];
	$email_subject = $_POST['email_subject'];
	$email_body = $_POST['email_body'];
	$contacts = $_POST['contacts'];
	$filters = $_POST['filters'];

	// GET CONTACTS EMAIL
	$contact_ids = array();
	$contact_emails = array();

	foreach ($contacts as $key => $value) {
		$contact_ids[$key] = $value['contact_id'];
	}

	$gce = SQL_QUERY("select c.contact_id, ce.email from contacts as c 
		left join contact_emails as ce on c.contact_id=ce.contact_id 
		where c.company_id='".$_SESSION['user']['company_id']."' and c.contact_id IN ('".join("','", $contact_ids)."')");

	while ($data = SQL_ASSOC_ARRAY($gce)) {
		$contact_emails[] = $data;

		// SEND EMAIL TO QUEUE
		SQL_QUERY("insert into bulk_send_queue (user_id,bulk_template_id,contact_id,date_queued) 
					values (
						'".SQL_CLEAN($_SESSION['user_id'])."',
						'".SQL_CLEAN($email_template)."',
						'".SQL_CLEAN($data['contact_id'])."',
						NOW()
					)");
	}

	// LOG EMAIL SENT
	SQL_QUERY("insert into bulk_send_log (user_id,bulk_template_id,filters,date_queued) 
				values (
					'".SQL_CLEAN($_SESSION['user_id'])."',
					'".SQL_CLEAN($email_template)."',
					'".SQL_CLEAN(json_encode($filters))."',
					NOW()
				)");

	echo json_encode(array('msg'=>true));
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