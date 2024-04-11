<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

$message = "<b>Name:</b> ".$_REQUEST['name']."<br/>\n";
$message .= "<b>Phone:</b> ".$_REQUEST['phone']."<br/>\n";
$message .= "<b>Email:</b> ".$_REQUEST['email']."<br/>\n";
$message .= "<b>Message:</b><br/> ".str_replace("\n","<br/>",$_REQUEST['message'])."<br/>\n";

$result = send_message($_POST['email'], array("support@ruopen.com", "RUOPEN Contact Request"), "Contact Request from " . $_POST['name'], $message);

if ($result){
	echo json_encode("message sent! from " . $_POST['email'] . " " . $_POST['name'] . " " . $_POST['message']);
}
else {
	echo json_encode("error");
}
	exit;
?>