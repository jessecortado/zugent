<?PHP


	require_once($_SERVER['SITE_DIR'].'/includes/PHPMailer/PHPMailerAutoload.php');

	$mail = new PHPMailer;
	$mail->isSMTP();
	$mail->Host = 'ssl://email-smtp.us-west-2.amazonaws.com';
	
	$mail->SMTPAuth = true;
	$mail->Username = 'AKIAJN22CVQO3RCBUGYA';
	$mail->Password = 'AnVynA9xT3YijjIlmcF2Z8DNCgPb4CYGbnRNORTsBY0B';
	
	$mail->SMTPSecure = 'tls';
	$mail->Port = 443;

	
	$mail->Subject = "Beta Signup Request";
	$mail->Body    = "You have a beta signup request from ".$_REQUEST['email_address'];
	
	// $mail->AddReplyTo($from[0], $from[1]);
	$mail->SetFrom("support@ruopen.com", "RUOPEN Mail");
	
	$mail->addAddress("razmage@gmail.com");
	
	$ret = $mail->Send();

	header("location: /spage.php?a=1&b=a9Owk");


?>