<?php 

require_once('connection.php');
require_once('mob_get_json.php');

header('Access-Control-Allow-Origin: *');

if(isset($_POST['user_id'])) {

	$sth = SQL_QUERY("
		select 
		c.*
		, cp.phone_number
		, ce.email
		, cu.date_viewed
		from contacts_rel_users as cu
		left join contacts as c on c.contact_id=cu.contact_id
		left join contact_emails as ce on ce.contact_id=cu.contact_id and ce.is_primary=1
		left join contact_phones as cp on cp.contact_id=cu.contact_id and cp.is_primary=1
		where cu.user_id='".SQL_CLEAN($_POST['user_id'])."' and cu.is_deleted != 1 
		order by c.date_activity DESC
		");

	$contacts = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$clean_phone_mobile = preg_replace("/[^0-9]/", "", $data['phone_number']);
		$data['clean_phone_mobile'] = $clean_phone_mobile;

		$contacts[] = $data;
	}

	echo json_encode(array("error" => false, "total_contacts" => count($contacts), "contacts" => $contacts));

} else {
	echo json_encode(array("error" => true));
}

?>