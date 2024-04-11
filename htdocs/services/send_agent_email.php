<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
header('Access-Control-Allow-Origin: *');

try {
	$inputJSON = file_get_contents('php://input');

	if (!isset($_POST['user_phone']) && !isset($_POST['user_email'])) {
		$_POST = json_decode($inputJSON, TRUE);
	}
	else {
		echo json_encode("404");
	}
} catch (EXCEPTION $e) {
	echo json_encode($e);
}

// echo json_encode($_POST);

$message = "<b>Name:</b> ".$_POST['user_first_name']." ".$_POST['last_name']."<br/>\n";
$message .= "<b>Phone:</b> ".$_POST['user_phone']."<br/>\n";
$message .= "<b>Email:</b> ".$_POST['user_email']."<br/>\n";
$message .= "<b>Message:</b><br/> ".str_replace("\n","<br/>",$_POST['message'])."<br/>\n";

$result = send_message($_POST['agent_email'], array("support@ruopen.com", "Potential Client Contacted You"), "ZugApp " . $_POST['user_first_name'] . " " . $_POST['user_last_name'] . " sent you a message", $message);

if ($result) {
	echo json_encode(true);
}
else {
	echo json_encode(false);
}
	exit;
?>