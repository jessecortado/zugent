<?php
/**
 * [$site_config description]
 * @var [type]
 * @description 
 */
include_once('mob_get_json.php');

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
	where c.contact_id='".SQL_CLEAN($_POST['contact_id'])."'
	order by cu.is_primary desc limit 1
	");

$data = SQL_ASSOC_ARRAY($sth);

if ($data['company_id'] == 0) {
	echo json_encode(array("accepted" => false));
}
else {
		// $message = "Success! An agent has accepted your request and is on the way.";
	$sth = SQL_QUERY("select u.*, c.company_name, cps.site_address from users as u 
		left join companies as c on c.company_id=u.company_id 
		left join company_page_settings as cps on c.company_id=cps.company_id 
		where u.user_id='".SQL_CLEAN($data['user_id'])."'");

	$agent = array();

	while($data = SQL_ASSOC_ARRAY($sth)) {
		$clean_phone_mobile = preg_replace("/[^0-9]/", "", $data['phone_mobile']);
		$data['clean_phone_mobile'] = $clean_phone_mobile;
		$agent[] = $data;
	}

	// send_to_one($_POST['phone'], '+12062029550', $message); -- Don't send an SMS notice to the contact - just show them on the page.
	echo json_encode(array("accepted" => true, "agent_id" => $data['user_id'], "agent" => $agent, "lat" => $data['last_latitude'], "lon" => $data['last_longitude']));
}
?>
