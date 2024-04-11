<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/htdocs/services/copy_campaign_file.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

// Shared_level
// ------------
// 0 = User Only
// 1 = Company Wide
// 2 = Global

if(isset($_GET['id'])) {

	// check if id is_base=1 is_copyable=1 shared_level=2

	$sth = SQL_QUERY("
		select 
			c.* 
			, u.first_name 
			, u.last_name 
			, u.company_id 
			, com.company_name 
			, com.phone_office
			, com.phone_fax
			, com.street_address
			, com.state
			, com.zip
			, com.city 
		from campaigns as c 
		left join users as u on c.user_id=u.user_id 
		left join companies as com on u.company_id=com.company_id
		where 
			c.campaign_id=".SQL_CLEAN($_GET["id"])." and
			((u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and c.shared_level=1) 
			or (c.is_base=1 and c.is_copyable=1 and c.shared_level=2 ))
		order by c.campaign_name limit 1
	");

	if(SQL_NUM_ROWS($sth) > 0) {
		$data = SQL_ASSOC_ARRAY($sth);

		$sth_campaign_event = SQL_QUERY("select count(*) as events_count, max(send_after_days) as max from campaign_events where campaign_id=".$data['campaign_id']);
		$temp = SQL_ASSOC_ARRAY($sth_campaign_event);
		$data["events_count"] = $temp["events_count"];
		$data["max"] = $temp["max"];
		$smarty->assign('id', $_GET['id']);
		$smarty->assign('data', $data);
		$smarty->display('confirm_purchase_campaign.tpl');
	}
		
}
else if(isset($_POST['id'])) {
	$id = SQL_CLEAN($_POST['id']);

	$sth = SQL_QUERY("
		select 
			c.* 
			, u.first_name 
			, u.last_name 
			, u.company_id 
			, com.company_name 
			, com.phone_office
			, com.phone_fax
			, com.street_address
			, com.state
			, com.zip
			, com.city 
		from campaigns as c 
		left join users as u on c.user_id=u.user_id 
		left join companies as com on u.company_id=com.company_id
		where 
			c.campaign_id=".$id." and
			((u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and c.shared_level=1) 
			or (c.is_base=1 and c.is_copyable=1 and c.shared_level=2 ))
		order by c.campaign_name limit 1
	");

	if(SQL_NUM_ROWS($sth) > 0) {
	// die(SQL_CLEAN($_SESSION['user']['user_id']));
		$data = SQL_ASSOC_ARRAY(SQL_QUERY("select * from campaigns where campaign_id=".$id." limit 1"));

		SQL_QUERY("insert into campaigns(
					campaign_name,
					user_id,
					description,
					copy_cost,
					copied_from_campaign_id
				)
				values('
					".addslashes($data['campaign_name'])."',
					".SQL_CLEAN($_SESSION['user']['user_id']).",'
					".addslashes($data['description'])."',
					".$data['copy_cost'].",
					".$id."
				)
			");

		$new_id = SQL_INSERT_ID();

		$sth_ce =  SQL_QUERY("select * from campaign_events where campaign_id=".$id);
		$date = date("Y-m-d H:i:s");

		while ($data_ce = SQL_ASSOC_ARRAY($sth_ce)) {
			SQL_QUERY("insert into campaign_events(
						campaign_id,
						is_event_appointment_triggered,
						appointment_trigger_column,
						appointment_trigger_type,
						appointment_trigger_value,
						send_after_days,
						user_id,
						event_subject,
						is_event_to_user,
						is_event_to_client,
						is_starting_event,
						event_body_filename,
						event_name,
						event_body,
						event_txt_body,
						date_modified,
						date_created
					) 
					values(
						".$new_id.",
						".$data_ce['is_event_appointment_triggered'].",'
						".$data_ce['appointment_trigger_column']."','
						".$data_ce['appointment_trigger_type']."','
						".$data_ce['appointment_trigger_value']."',
						".$data_ce['send_after_days'].",
						".SQL_CLEAN($_SESSION['user']['user_id']).",'
						".addslashes($data_ce['event_subject'])."',
						".$data_ce['is_event_to_user'].",
						".$data_ce['is_event_to_client'].",
						".$data_ce['is_starting_event'].",'
						".addslashes($data_ce['event_body_filename'])."','
						".addslashes($data_ce['event_name'])."','
						".addslashes($data_ce['event_body'])."','
						".addslashes($data_ce['event_txt_body'])."','
						".$data_ce['date_modified']."','
						".$date."'
					)");
		}

		$sth_cv =  SQL_QUERY("select * from campaign_variables where campaign_id=".$id);

		while ($data_cv = SQL_ASSOC_ARRAY($sth_cv)) {
			SQL_QUERY("insert into campaign_variables(
						campaign_id,
						var_key,
						var_val,
						date_modified,
						date_created
					) 
					values(
						".$new_id.",'
						".$data_cv['var_key']."','
						".$data_cv['var_val']."','
						".$data_cv['date_modified']."','
						".$date."'
					)");
		}
		// die(var_dump($data));

		$sth = SQL_QUERY("select * from campaign_downloads where campaign_id=".$id);

		// die(" ROWS ".SQL_NUM_ROWS($sth));
		while($data = SQL_ASSOC_ARRAY($sth)) {
			copy_file($id, $new_id, $data);
		}
	
		header("location: /thank_you_campaign.php?id=".$new_id);
	}
}


	
?>