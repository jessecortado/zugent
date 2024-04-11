<?PHP


require_once($_SERVER['SITE_DIR'].'/includes/PHPMailer/PHPMailerAutoload.php');
require_once($_SERVER['SITE_DIR'].'/includes/common.php');

/*
Server Name: email-smtp.us-west-2.amazonaws.com
Port:	25, 465 or 587
Use Transport Layer Security (TLS):	Yes
Authentication:	Your SMTP credentials - see below.

AIM: ses-smtp-user.20170406-220229

SMTP Username: AKIAJN22CVQO3RCBUGYA
SMTP Password: AnVynA9xT3YijjIlmcF2Z8DNCgPb4CYGbnRNORTsBY0B
*/

function send_message2($from, $to, $subject, $body) {
	global $smarty;
	$mail_array = array('subject' => $subject, 'body' => $body);

	$smarty->assign('mail_to', $to);
	$smarty->assign('mail', $mail_array);
	$message_body = $smarty->fetch("email_templates/standard.tpl");

	$mail = new PHPMailer;
//	$mail->isSMTP();
//	$mail->Host = 'ssl://email-smtp.us-west-2.amazonaws.com';
	
//	$mail->SMTPAuth = true;
//	$mail->Username = 'AKIAJN22CVQO3RCBUGYA';
//	$mail->Password = 'AnVynA9xT3YijjIlmcF2Z8DNCgPb4CYGbnRNORTsBY0B';
	
//	$mail->SMTPSecure = 'tls';
//	$mail->Port = 443;

//	$mail->IsHTML(true);


//	if ($company['logo_file'] == '') {
//		$mail->AddEmbeddedImage($_SERVER['SITE_DIR'].'/htdocs/assets/logos/ZugEntLogo.png','logo_cid');
//	} else {
//		$mail->AddEmbeddedImage($_SERVER['SITE_DIR'].'/htdocs/assets/logos/'.$company['logo_file'],'logo_cid');
//	}
	
	$mail->Subject = $subject;
	$mail->Body    = $message_body;
	$mail->AltBody = $txt_body;
	
	
	$mail->SetFrom($from[0], $from[1]);
	
	//$mail->AddReplyTo($from[0], $from[1]);
	//$mail->SetFrom("support@ruopen.com", "ZugEnt Mail");
	
	$mail->addAddress($to[0], $to[1], 34);
	// $mail->Priority = 1; 
	
	$ret = $mail->Send();
	//print_r($ret);
	return $ret;
}




print send_message2(array('jason@pipelineplatform.com','Jason Granum'), array('razmage@gmail.com','Jason Granum',2), 'Just a quick test message', 'Yo! Just testing to make sure this works.');
print "<hr>Done";


function stripUnwantedTagsAndAttrs($html_str){
	$xml = new DOMDocument();
	//Suppress warnings: proper error handling is beyond scope of example
	libxml_use_internal_errors(true);
	//List the tags you want to allow here, NOTE you MUST allow html and body otherwise entire string will be cleared
	$allowed_tags = array("html", "body", "b", "br", "em", "hr", "i", "li", "ol", "p", "s", "span", "table", "tr", "td", "u", "ul");
	//List the attributes you want to allow here
	$allowed_attrs = array ("class", "id", "style");
	if (!strlen($html_str)) { return false; }
	if ($xml->loadHTML($html_str, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD)) {
		foreach ($xml->getElementsByTagName("*") as $tag) {
			if (!in_array($tag->tagName, $allowed_tags)) {
				$tag->parentNode->removeChild($tag);
			} else {
				foreach ($tag->attributes as $attr) {
					if (!in_array($attr->nodeName, $allowed_attrs)) {
						$tag->removeAttribute($attr->nodeName);
					}
				}
			}
		}
	}
	return $xml->saveHTML();
}


?>