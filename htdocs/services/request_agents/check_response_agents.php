<?php 

require_once($_SERVER['SITE_DIR']."/htdocs/services/send_sms.php");

header('Access-Control-Allow-Origin: *');

try {
	$inputJSON = file_get_contents('php://input');

	if (!isset($_POST['latitude']) && !isset($_GET['request'])) {
		$_POST = json_decode($inputJSON, TRUE);
	}
	else {
		echo json_encode("404");
	}
} catch (EXCEPTION $e) {
	echo json_encode($e);
}

if (isset($_REQUEST['contact_id'])) {
	// Check for response by checking if a company id has been set to any id not 0.
	// Also get only the primary agent assigned - and if for some reason there isn't a primary then return
	// the first user (achieved via a order by limit 1)
	$sth = SQL_QUERY("
		select 
			c.*
			, cp.phone_number
			, u.user_id
			, ce.email
			, u.last_latitude
			, u.last_longitude
		from contacts as c 
		left join contact_phones as cp on cp.contact_id=c.contact_id and cp.is_primary=1 
		left join contact_emails as ce on ce.contact_id=c.contact_id and ce.is_primary=1 
		left join contacts_rel_users as cu on cu.contact_id=c.contact_id 
		left join users as u on u.user_id=cu.user_id 
		where c.contact_id='".SQL_CLEAN($_REQUEST['contact_id'])."'
		order by cu.is_primary desc limit 1
	");

	$data = SQL_ASSOC_ARRAY($sth);

	if ($data['company_id'] == 0) {
		echo json_encode(array("accepted" => false));
	}
	else {
		// $message = "Success! An agent has accepted your request and is on the way.";
		$sth = SQL_QUERY("select u.*, c.company_name from users as u left join companies as c on c.company_id=u.company_id where u.user_id='".SQL_CLEAN($data['user_id'])."'");
		$agent = SQL_ASSOC_ARRAY($sth);

		// send_to_one($_POST['phone'], '+12062029550', $message); -- Don't send an SMS notice to the contact - just show them on the page.
		echo json_encode(array("accepted" => true, "agent_id" => $data['user_id'], "agent" => $agent, "lat" => $data['last_latitude'], "lon" => $data['last_longitude']));
	}

}
else {
	header("location: /request_agent.php?code=1x007");
}

?>