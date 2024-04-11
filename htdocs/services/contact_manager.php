<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

if(isset($_POST['action'])){

	if($_POST['action'] == "add_file_type"){
		if(isset($_POST['name'])){
			$sth = SQL_QUERY("
					insert into 
						file_types set 
						name='".SQL_CLEAN($_POST['name']).
						"', sequence='".SQL_CLEAN($_POST['sequence']).
						"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
						"', is_deleted=0, ".
						"company_id='".SQL_CLEAN($_SESSION['user']['company_id'])
						."'");

			$file_type_id = SQL_INSERT_ID();

			echo json_encode(array('result'=>$sth, 'file_type_id'=>$file_type_id, 'name'=>$_POST['name'], 'sequence'=>$_POST['sequence'] ));
		}
		else {
			echo json_encode("No bucket sent");
		}
	}
	elseif($_POST['action'] == "delete_file_type"){
		if(isset($_POST['file_type_id'])){

			$sth = SQL_QUERY("update file_types set is_deleted=1 where file_type_id=".SQL_CLEAN($_POST["file_type_id"]));

			echo json_encode(true);
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "edit_file_type_name"){
		if(isset($_POST['file_type_id'])){

			$sth = SQL_QUERY("update file_types set  name='".SQL_CLEAN($_POST['name'])."' where file_type_id=".SQL_CLEAN($_POST["file_type_id"]));

			echo json_encode(true);
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "edit_sequence"){
		if(isset($_POST['file_type_id'])){

			$sth = SQL_QUERY("update file_types set  sequence='".SQL_CLEAN($_POST['sequence'])."' where file_type_id=".SQL_CLEAN($_POST["file_type_id"]));

			echo json_encode(true);
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "set_primary"){
		if(isset($_POST['user_id'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("update contacts_rel_users set ".
				"is_primary=1,".
				"date_updated='".$date."'".
				"where user_id=".SQL_CLEAN($_POST["user_id"])." and contact_id=".SQL_CLEAN($_POST["contact_id"]));

			echo json_encode(true);

			// header("location: /contacts_edit.php?id=".$_POST["contact_id"]);
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "unset_primary"){
		if(isset($_POST['user_id'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("update contacts_rel_users set ".
				"is_primary=0,".
				"date_updated='".$date."'".
				"where user_id=".SQL_CLEAN($_POST["user_id"])." and contact_id=".SQL_CLEAN($_POST["contact_id"]));

			echo json_encode(true);

			// header("location: /contacts_edit.php?id=".$_POST["contact_id"]);
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "add_user_to_contact"){
		if(isset($_POST['user_id'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("insert into contacts_rel_users set ".
				"is_primary=0".
				", user_id=".SQL_CLEAN($_POST["user_id"]).
				", contact_id=".SQL_CLEAN($_POST["contact_id"]).
				", date_assigned='".$date.
				"', assigned_by_user_id=".SQL_CLEAN($_SESSION["user"]["user_id"])
				);

			header("location: /contacts_edit.php?id=".$_POST["contact_id"]);

			echo json_encode(true);
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "remove_user_from_contact"){
		if(isset($_POST['contact_user_id'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("update contacts_rel_users set ".
				"is_primary=0".
				", is_deleted=1".
				", date_deleted='".$date.
				"', deleted_by_user_id=".SQL_CLEAN($_SESSION["user"]["user_id"]).
				" where contact_user_id=".SQL_CLEAN($_POST['contact_user_id'])
				);

			// header("location: /contacts_edit.php?id=".$_POST["contact_id"]);

			echo json_encode(true);
		}
		else {
			echo json_encode("No id sent (remove user from contact)");
		}
	}
	
	elseif($_POST['action'] == "delete_contact_file"){
		if(isset($_POST['contact_file_id'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("update contact_files set ".
				"is_deleted=1".
				" where contact_file_id=".SQL_CLEAN($_POST['contact_file_id']).
				" and contact_id=".SQL_CLEAN($_POST['contact_id'])
				);

			// header("location: /contacts_edit.php?id=".$_POST["contact_id"]);

			echo json_encode(array("result"=>$sth));
		}
		else {
			echo json_encode("No id sent (remove file from contact)");
		}
	}
	
	elseif($_POST['action'] == "edit_contact_file"){
		if(isset($_POST['contact_file_id'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("update contact_files set ".
				"file_type_id=".SQL_CLEAN($_POST['file_type_id']).
				", file_name='".SQL_CLEAN($_POST['file_name']).
				"' where contact_file_id=".SQL_CLEAN($_POST['contact_file_id']).
				" and contact_id=".SQL_CLEAN($_POST['contact_id'])
				);

			header("location: /contacts_edit.php?id=".$_POST["contact_id"]."#contactFilesTbl");
		}
		else {
			echo json_encode("No id sent (remove file from contact)");
		}
	}
	
	elseif($_POST['action'] == "restore_contact_file"){
		if(isset($_POST['contact_file_id'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("update contact_files set ".
				"is_deleted=0".
				" where contact_file_id=".SQL_CLEAN($_POST['contact_file_id']).
				" and contact_id=".SQL_CLEAN($_POST['contact_id'])
				);

			// header("location: /contacts_edit.php?id=".$_POST["contact_id"]);

			echo json_encode(array("result"=>$sth));
		}
		else {
			echo json_encode("No id sent (remove file from contact)");
		}
	}
	
	elseif($_POST['action'] == "search_contact"){
		if(isset($_POST['name'])){

			$like_param = "%".SQL_CLEAN($_POST['name'])."%";

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
				where cu.is_deleted != 1 
				and CONCAT(c.first_name, ' ', c.last_name) like '".$like_param."' and cu.user_id='".SQL_CLEAN($_SESSION['user_id'])."'
				order by c.date_activity DESC
			");

			$contacts = array();
			while ($data = SQL_ASSOC_ARRAY($sth)) {
				$sth_camp = SQL_QUERY("select c.*, datediff(NOW(),cc.date_added) as days_in from campaigns_rel_contacts as cc left join campaigns as c on c.campaign_id=cc.campaign_id where cc.contact_id='".$data['contact_id']."' limit 1");
				$data['campaigns'] = array();
				while ($c_data = SQL_ASSOC_ARRAY($sth_camp)) {
					$data['campaigns'][] = $c_data;
				}
				$contacts[] = $data;
			}

			echo json_encode(array("data"=>$contacts));
		}
		else {
			echo json_encode("No name sent (search)");
		}
	}
	
	elseif($_POST['action'] == "search_filtered_contact"){
		if(isset($_POST['name'])){

			$like_param = "%".SQL_CLEAN($_POST['name'])."%";
			$filter = "";

			if($_POST['search_name'] == "undefined") {
				// $filter = "((bucket_id=0 or bucket_id is null) and (status_id=0 or status_id is null) and (sub_status_id=0 or sub_status_id is null))";
				$filter = "(bucket_id=0 or bucket_id is null)";
			}
			else if($_POST['search_name'] == "new") {
				$filter = "(cu.date_viewed = 0 or cu.date_viewed is null or cu.date_viewed='0000-00-00 00:00:00')";
			}
			else {
				$filter = SQL_CLEAN($_POST['search_name'])."=".SQL_CLEAN($_POST['search_id']);
			}

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
				where cu.is_deleted != 1 
				and CONCAT(c.first_name, ' ', c.last_name) like '".$like_param."' and cu.user_id='".SQL_CLEAN($_SESSION['user_id'])."' 
				and ".$filter."
				order by c.date_activity DESC
			");

			$contacts = array();
			while ($data = SQL_ASSOC_ARRAY($sth)) {
				$sth_camp = SQL_QUERY("select c.*, datediff(NOW(),cc.date_added) as days_in from campaigns_rel_contacts as cc left join campaigns as c on c.campaign_id=cc.campaign_id where cc.contact_id='".$data['contact_id']."' limit 1");
				$data['campaigns'] = array();
				while ($c_data = SQL_ASSOC_ARRAY($sth_camp)) {
					$data['campaigns'][] = $c_data;
				}
				$contacts[] = $data;
			}

			echo json_encode(array("data"=>$contacts));
		}
		else {
			echo json_encode("No name sent (search)");
		}
	}

	elseif($_POST['action'] == "search_company_contact"){
		if(isset($_POST['name'])){

			$like_param = "%".SQL_CLEAN($_POST['name'])."%";

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
				left join users as u on u.user_id=cu.user_id 
				where cu.is_deleted != 1 
				and CONCAT(c.first_name, ' ', c.last_name) like '".$like_param."' and u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'
				order by c.date_activity DESC
			");

			$contacts = array();
			while ($data = SQL_ASSOC_ARRAY($sth)) {
				$sth_camp = SQL_QUERY("select c.*, datediff(NOW(),cc.date_added) as days_in from campaigns_rel_contacts as cc left join campaigns as c on c.campaign_id=cc.campaign_id where cc.contact_id='".$data['contact_id']."' limit 1");
				$data['campaigns'] = array();
				while ($c_data = SQL_ASSOC_ARRAY($sth_camp)) {
					$data['campaigns'][] = $c_data;
				}
				$contacts[] = $data;
			}

			echo json_encode(array("data"=>$contacts));
		}
		else {
			echo json_encode("No name sent (search)");
		}
	}
	
	elseif($_POST['action'] == "search_filtered_company_contact"){
		if(isset($_POST['name'])){

			$like_param = "%".SQL_CLEAN($_POST['name'])."%";
			$filter = "";

			if($_POST['search_name'] == "undefined") {
				// $filter = "((bucket_id=0 or bucket_id is null) and (status_id=0 or status_id is null) and (sub_status_id=0 or sub_status_id is null))";
				$filter = "(bucket_id=0 or bucket_id is null)";
			}
			else if($_POST['search_name'] == "new") {
				$filter = "(cu.date_viewed = 0 or cu.date_viewed is null or cu.date_viewed='0000-00-00 00:00:00')";
			}
			else {
				$filter = SQL_CLEAN($_POST['search_name'])."=".SQL_CLEAN($_POST['search_id']);
			}

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
				left join users as u on u.user_id=cu.user_id 
				where cu.is_deleted != 1 
				and CONCAT(c.first_name, ' ', c.last_name) like '".$like_param."' and u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
				and ".$filter."
				order by c.date_activity DESC
			");

			$contacts = array();
			while ($data = SQL_ASSOC_ARRAY($sth)) {
				$sth_camp = SQL_QUERY("select c.*, datediff(NOW(),cc.date_added) as days_in from campaigns_rel_contacts as cc left join campaigns as c on c.campaign_id=cc.campaign_id where cc.contact_id='".$data['contact_id']."' limit 1");
				$data['campaigns'] = array();
				while ($c_data = SQL_ASSOC_ARRAY($sth_camp)) {
					$data['campaigns'][] = $c_data;
				}
				$contacts[] = $data;
			}

			echo json_encode(array("data"=>$contacts));
		}
		else {
			echo json_encode("No name sent (search)");
		}
	}

	else if($_POST['action'] == "add_referral"){

		$date = gmdate("Y-m-d H:i:s");

		$sth_primary = SQL_QUERY("select * from contact_rel_users where contact_id=".SQL_CLEAN($_POST['contact_id'])." and is_primary=1 limit 1");
		$primary = SQL_ASSOC_ARRAY($sth_primary);

		// 

		if(isset($_POST['referral_source'])){
			$sth = SQL_QUERY("
					insert into 
						contact_referral set 
						referral_source='".SQL_CLEAN($_POST['referral_source']).
						"', contact_id='".SQL_CLEAN($_POST['contact_id']).
						"', user_id='".SQL_CLEAN(SQL_CLEAN($_POST['user_id'])).
						"', date_referral='".SQL_CLEAN($date).
						"', referred_by_user_id=".SQL_CLEAN($_SESSION['user']['user_id']).
						", is_active=1, is_counted=1, is_complete=0"
					);

			$file_type_id = SQL_INSERT_ID();

			header("location: /contacts_edit.php?id=".$_POST['contact_id']."#panel-referrals");
		}
		else {
			echo json_encode("No source sent");
		}
	}
	elseif($_POST['action'] == "mark_referral_inactive") {
		if(isset($_POST['user_id'])){
			$sth = SQL_QUERY("select * from contact_referral where contact_referral_id=".SQL_CLEAN($_POST['referral_id']));
			$referral_data = SQL_ASSOC_ARRAY($sth);
			$comment = "Referral has been marked as inactive.";
			$sth = SQL_QUERY("insert into contact_comments set comment='".$comment."', contact_id='".SQL_CLEAN($referral_data['contact_id'])."', user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."', date_added=NOW()");
			SQL_QUERY("update contact_referral set is_active=0, modified_user_id='".$_SESSION['user']['user_id']."' where contact_referral_id=".SQL_CLEAN($_POST["referral_id"]));
			echo json_encode($sth);
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "mark_referral_active") {
		if(isset($_POST['user_id'])){
			$sth = SQL_QUERY("select * from contact_referral where contact_referral_id=".SQL_CLEAN($_POST['referral_id']));
			$referral_data = SQL_ASSOC_ARRAY($sth);
			$comment = "Referral has been marked as active.";
			$sth = SQL_QUERY("insert into contact_comments set comment='".$comment."', contact_id='".SQL_CLEAN($referral_data['contact_id'])."', user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."', date_added=NOW()");
			SQL_QUERY("update contact_referral set is_active=1, modified_user_id='".$_SESSION['user']['user_id']."' where contact_referral_id=".SQL_CLEAN($_POST["referral_id"]));
			echo json_encode($sth);
		}
		else {
			echo json_encode("No id sent");
		}
	}	
	elseif($_POST['action'] == "mark_referral_complete"){
		if(isset($_POST['user_id'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("
				select * from contact_referral where contact_referral_id=".SQL_CLEAN($_POST['referral_id']));

			$old = SQL_ASSOC_ARRAY($sth);

			$comment = "Marked as complete on ". $date . " (" . $_SESSION['user']['user_id'].").";

			$sth2 = SQL_QUERY("
				insert into 
				contact_comments set
				comment='".$comment.
				"', contact_id='".SQL_CLEAN($_POST['contact_id']).
				"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
				"', date_added='".$date."'
				");

			$sth = SQL_QUERY("update contact_referral set ".
				"is_active=0, is_complete=1".
				", date_complete='".$date."'".
				", modified_user_id='".$_SESSION['user']['user_id']."'".
				"where contact_referral_id=".SQL_CLEAN($_POST["referral_id"]));

			echo json_encode($sth);

		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "mark_referral_counted"){ 
		if(isset($_POST['user_id'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("
				select * from contact_referral where contact_referral_id=".SQL_CLEAN($_POST['referral_id']));

			$old = SQL_ASSOC_ARRAY($sth);

			$comment = "Marked as counted = ".$_POST['is_counted']." on ". $date . " (" . $_SESSION['user']['user_id'].").";

			$sth2 = SQL_QUERY("
				insert into 
				contact_comments set
				comment='".$comment.
				"', contact_id='".SQL_CLEAN($_POST['contact_id']).
				"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
				"', date_added='".$date."'
				");

			$sth = SQL_QUERY("update contact_referral set ".
				"is_counted=".SQL_CLEAN($_POST['is_counted']).
				", modified_user_id='".$_SESSION['user']['user_id']."'".
				"where contact_referral_id=".SQL_CLEAN($_POST["referral_id"]));

			echo json_encode($sth);

		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "mark_referral_dead"){ 
		if(isset($_POST['user_id'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("
				select * from contact_referral where contact_referral_id=".SQL_CLEAN($_POST['referral_id']));

			$old = SQL_ASSOC_ARRAY($sth);

			$comment = "Marked as dead on ". $date . " (" . $_SESSION['user']['user_id'].").";

			$sth2 = SQL_QUERY("
				insert into 
				contact_comments set
				comment='".$comment.
				"', contact_id='".SQL_CLEAN($_POST['contact_id']).
				"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
				"', date_added='".$date."'
				");

			$sth = SQL_QUERY("update contact_referral set ".
				"is_active=0".
				", modified_user_id='".$_SESSION['user']['user_id']."'".
				"where contact_referral_id=".SQL_CLEAN($_POST["referral_id"]));

			echo json_encode($sth);

		}
		else {
			echo json_encode("No id sent");
		}
	}

	else if($_POST['action'] == "edit_referral"){
		if(isset($_POST['referral_source'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("
				select * from contact_referral where contact_referral_id=".SQL_CLEAN($_POST['referral_id']));

			$old = SQL_ASSOC_ARRAY($sth);

			$comment = "Referral was updated on ". $date . " (" . $_SESSION['user']['user_id']."). The ff. changes were made: <br>";

			if($old['user_id'] !== $_POST['user_id'])
				$comment .= "From " . $old['user_id'] . " to " .  $_POST['user_id'] . "<br>";
			if($old['referral_source'] !== $_POST['referral_source'])
				$comment .= "From " . $old['referral_source'] . " to " .  $_POST['referral_source'] . "<br>";
			if($old['referral_bob'] !== $_POST['referral_bob'])
				$comment .= "From " . $old['referral_bob'] . " to " .  $_POST['referral_bob'] . "<br>";

			$sth2 = SQL_QUERY("
				insert into 
				contact_comments set
				comment='".$comment.
				"', contact_id='".SQL_CLEAN($_POST['contact_id']).
				"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
				"', date_added='".$date."'
				");

			$sth = SQL_QUERY("
				update 
				contact_referral set 
				referral_source='".SQL_CLEAN($_POST['referral_source']).
				"', referral_bob='".SQL_CLEAN($_POST['referral_bob']).
				"', user_id='".SQL_CLEAN($_POST['user_id']).
				"', modified_user_id=".SQL_CLEAN($_SESSION['user']['user_id']).
				" where contact_referral_id=".SQL_CLEAN($_POST['referral_id'])
				);

			header("location: /contacts_edit.php?id=".$_POST['contact_id']."#panel-referrals");

		}
		else {
			echo json_encode("No source sent");
		}
	}

}
else
	echo json_encode("No Action Sent");


exit;

	
?>
