<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");


// Get User Letter Templates
$letter_temp = SQL_QUERY("select * from user_email_templates 
	where user_email_template_id = '".$_POST['user_letter_template_id']."'");

$letter_template = array();

while ($data = SQL_ASSOC_ARRAY($letter_temp)) {
	$letter_template[] = $data;
}

// Get Contacts
$ct = SQL_QUERY("select * from contacts as c 
	left join contact_emails as ce on ce.contact_id=c.contact_id 
	where c.contact_id = '".$_POST['contact_id']."'");

$contact_detail = array();

while ($data = SQL_ASSOC_ARRAY($ct)) {
	$contact_detail[] = $data;
}

// echo "<pre>";
// print_r($contact_detail[0]['email']);
// echo "</pre>";
// die('asdasd');

// SEND LETTER TO CONTACT
$mail = new PHPMailer;
$mail->isSMTP();
$mail->Host = 'ssl://email-smtp.us-west-2.amazonaws.com';

$mail->SMTPAuth = true;
$mail->Username = 'AKIAJN22CVQO3RCBUGYA';
$mail->Password = 'AnVynA9xT3YijjIlmcF2Z8DNCgPb4CYGbnRNORTsBY0B';

$mail->SMTPSecure = 'tls';
$mail->Port = 443;
$mail->IsHTML(true);

$mail->Subject = $letter_template[0]['subject'];
$mail->Body    = " ";
$mail->AltBody = "";

// $mail->AddReplyTo($from);
$mail->SetFrom("support@zugent.com", $_SESSION['user']['first_name'].' '.$_SESSION['user']['last_name']);
// $mail->addAddress("jessecortado@gmail.com"); // FOR TESTING ONLY
$mail->addAddress($contact_detail[0]['email']);

$mail->addAttachment('../../assets/pdfs/preview_letter.pdf');

if ($mail->Send()) {
	echo json_encode(array("msg" => true));
}
else {
	echo json_encode(array("msg" => false));
}

?>