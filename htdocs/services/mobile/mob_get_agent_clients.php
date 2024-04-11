<?php 

require_once('connection.php');
require_once('mob_get_json.php');

header('Access-Control-Allow-Origin: *');

if(isset($_POST['user_id'])) {

	$sth = SQL_QUERY("select distinct c.first_name, c.last_name, UNIX_TIMESTAMP(cr.date_referral) as unixtime_referral, cr.date_referral, cb.bucket_name, cb.bucket_id, c.contact_id, ar.latitude, ar.longitude, cp.phone_number, ce.email, c.is_unsubscribed 
		from contact_referral as cr 
		inner join contacts as c on cr.contact_id=c.contact_id 
		left join contacts_rel_users as cru on cr.contact_id=cru.contact_id 
		left join contact_buckets as cb on c.bucket_id=cb.bucket_id 
		left join agent_requests as ar on c.contact_id=ar.contact_id 
		left join contact_phones as cp on c.contact_id=cp.contact_id and cp.is_primary=1 
		left join contact_emails as ce on c.contact_id=ce.contact_id and ce.is_primary=1 
		where cr.referral_source='ZugDrive' and cru.user_id=".SQL_CLEAN($_POST['user_id'])." 
		order by cr.date_referral desc
	");

	$contacts = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$clean_phone_mobile = preg_replace("/[^0-9]/", "", $data['phone_number']);
		$data['clean_phone_mobile'] = $clean_phone_mobile;

		$data['contact_status'] = "";
		if (!empty($data['bucket_name'])) {
			$data['contact_status'] = $data['bucket_name'];
		}
		else {
			$data['contact_status'] = "Uncategorized";
		}

		$contacts[] = $data;
	}

	echo json_encode(array("error" => false, "contacts" => $contacts));

} else {
	echo json_encode(array("error" => true));
}

?>