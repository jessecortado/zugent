<?php 

require_once($_SERVER['SITE_DIR']."/htdocs/services/send_sms.php");

function baselog ($line, $file, $echo_errors=FALSE) {
	$array = explode("\n", $line);
	$line = "";
	foreach ($array as $ar) $line .= date ("Y-m-d H:i:s").": ".$ar."\n";

	$f = @fopen ($file, "a");
	if (!$f) {
		return FALSE;
	} elseif (!@fwrite ($f, $line) ) {
		if ($echo_errors) {
			echo "BASELOG: could not write to file $file: $line\n";
		}
		@fflush ($f);
		@fclose ($f);
	} else {
		@fflush ($f);
		@fclose ($f);
	}
}

if (isset($_GET['request'])) {
	$logmsg = "-----------------------------------------\n";
	$logmsg .= "Client IP: ".$_SERVER['REMOTE_ADDR']."\n";
	$logmsg .= "User Agent: ".$_SERVER['HTTP_USER_AGENT']."\n";
	$logmsg .= "Request Method: ".$_SERVER['REQUEST_METHOD']."\n";
	$logmsg .= "Request Vars:\n".print_r($_REQUEST,1)."\n";

	if ($_SERVER['HTTP_USER_AGENT'] == "Apache-HttpClient/4.3.4 (java 1.5)") $logmsg .= "Automated page load - bailing!\n";

	baselog($logmsg,"/var/log/ruopen/accept_request.log");

	if ($_SERVER['HTTP_USER_AGENT'] == "Apache-HttpClient/4.3.4 (java 1.5)" || $_SERVER['REQUEST_METHOD'] == 'HEAD') {
		header("location: /invalid_request.php?code=rax109");
		exit;
	}

	if (empty($_GET['request'])) 
		header('location: /404');

	$temp = explode('-', $_GET['request']);
	$sth = SQL_QUERY("select * from agent_requests where agent_request_id=".SQL_CLEAN($temp[1])." and request='".SQL_CLEAN($temp[0])."' limit 1");

	if (SQL_NUM_ROWS($sth) == 0) {
		header("location: /invalid_request.php?code=rax100");
		exit; 
	}

	$request_data = SQL_ASSOC_ARRAY($sth);

	// Check if the contact has been taken or doesn't exist
	$sth = SQL_QUERY("select * from contacts where contact_id=".SQL_CLEAN($request_data['contact_id'])." and company_id=0");

	if (SQL_NUM_ROWS($sth) == 0) {
		header("location: /invalid_request.php?code=rax101");
		exit;
	}

	$sth = SQL_QUERY("select * from users where user_id=".SQL_CLEAN($request_data['user_id']));
	$user_data = SQL_ASSOC_ARRAY($sth);

	SQL_QUERY("update contacts set company_id=".SQL_CLEAN($user_data['company_id'])." where contact_id=".SQL_CLEAN($request_data['contact_id']));
	SQL_QUERY("update contact_referral set user_id=".SQL_CLEAN($user_data['user_id'])." where contact_id=".SQL_CLEAN($request_data['contact_id']));

	$cond1 = SQL_QUERY("insert into contacts_rel_users set is_primary=1, date_assigned=NOW(), user_id=".SQL_CLEAN($user_data['user_id']).", contact_id=".SQL_CLEAN($request_data['contact_id']));
	$cond2 = SQL_QUERY("update agent_requests set accepted=1 where agent_request_id=".SQL_CLEAN($temp[1]));

	
	// Add referral log
	add_user_log("Agent (".$request_data['user_id'].") accepted a request", "requests", array("importance" => "Info", "action" => "Add") );

	if ($cond1 && $cond2) {
		// add notification
		// id, title, notification, url_action
		add_notification($user_data['user_id'], "New Contact", "You accepted a new contact", $_SERVER['HTTP_HOST']."/contacts_edit.php?id=".$request_data['contact_id']);			
		
		// add_notification($user_data['user_id'], "New Contact", "You accepted a new contact", $_SERVER['HTTP_HOST']."/contacts_edit.php?id=".$request_data['contact_id']);

		// Will change to display in website 
		// header("location: https://www.google.com/maps/dir/?api=1&destination=".$request_data['latitude'].",".$request_data['longitude']."");
		// header("location: /drive.php"); // redirect to drive page


		header("location: /contacts_edit.php?id=".$request_data['contact_id']."&accept=1"); // redirect to contacts page

	}

	// Send email to users is_drive_accepted_alert = 1
	$sth2 = SQL_QUERY("select * from users where is_drive_accepted_alert = 1");

	while($data = SQL_ASSOC_ARRAY($sth2)) {
		$agents[] = $data;
	}

	$sth3 = SQL_QUERY("select * from contacts as c 
		left join contact_emails as ce on ce.contact_id=c.contact_id 
		left join contact_phones as cp on cp.contact_id=c.contact_id 
		where c.contact_id=".SQL_CLEAN($request_data['contact_id']));
	$client_details = SQL_ASSOC_ARRAY($sth3);

	$contact_sum = str_replace("Formatted Address:", "", $client_details['summary']);
	$pos = strpos($contact_sum, "Contact request details:");
	$nearest_address = substr($contact_sum, 0, $pos);
	// EMAIL MESSAGE
	$message = 'A lead was accepted by '.$user_data['first_name'].' '.$user_data['last_name'].'.';
	$message.= "<br/><br/>\nContact Details:<br/>\n";
	$message.= "Name: ".$client_details['first_name']." ".$client_details['last_name']."<br/>\n";
	$message.= "Email: ".$client_details['email']."<br/>\n";
	$message.= "Nearest estimated address: ".$nearest_address."<br/>\n";

	if(!is_null($client_details['mls_number'])){
		$message.= "Phone Number: ".$client_details['phone_number']."<br/>\n";
		$message.= "MLS # or Address: ". $client_details['mls_number']."<br/><br/>\n";
	}else{
		$message.= "Phone Number: ".$client_details['phone_number']."<br/><br/>\n";
	}
	$message.= '<a href="https://www.google.com/maps/search/?api=1&query='.$client_details['latitude'].','.$client_details['longitude'].'">See Client Location</a>';

	// CLIENT INFORMATION MESSAGE
	$client_msg.= "Contact Details:<br/>\n";
	$client_msg.= "Name: ".$client_details['first_name']." ".$client_details['last_name']."<br/>\n";
	$client_msg.= "Email: ".$client_details['email']."<br/>\n";
	$client_msg.= "Nearest estimated address: ".$nearest_address."<br/>\n";

	if($client_details['has_broker'] == 1) {
		$client_msg.= "Client has a broker<br/>\n";
	}

	if(!is_null($client_details['mls_number'])){
		$client_msg.= "Phone Number: ".$client_details['phone_number']."<br/>\n";
		$client_msg.= "MLS # or Address: ". $client_details['mls_number']."<br/><br/>\n";
	}else{
		$client_msg.= "Phone Number: ".$client_details['phone_number']."<br/><br/>\n";
	}
	$client_msg.= '<a href="https://www.google.com/maps/search/?api=1&query='.$client_details['latitude'].','.$client_details['longitude'].'">See Client Location</a>';
	$client_msg.= "<br/><br/>\n";
	$client_msg.= '<a href="https://'.$_SERVER['HTTP_HOST'].'/contacts_edit.php?id='.$request_data['contact_id'].'">Go to Contact Page</a>';

	// SEND EMAIL TO AGENTS
	foreach ($agents as $agent => $value) {
		if ($user_data['user_id'] != $value['user_id']) {
			send_message("support@ruopen.com", 
				array($value['email'], "support@ruopen.com"), 
				'A potential client was accepted', 
				$message);
		}
	}

	// SEND AFFIRMATION MESSAGE TO AGENT AND CLIENT
	send_message("support@ruopen.com",
		array($user_data['email'], "support@ruopen.com"),
		'You have accepted a client',
		$client_msg);

	$affirmation_client = 'You have been matched with an agent! You should receive a call from '.$user_data['first_name'].' '.$user_data['last_name'].' soon or you can call your agent at '.$user_data['phone_mobile'].'.';
	send_to_one($client_details['phone_number'], '+12062029550', $affirmation_client, $user_data['user_id']);



}
else {
	header("location: /request_agent.php?code=1x007");
}

?>
