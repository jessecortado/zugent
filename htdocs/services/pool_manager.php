<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Workaround for strange bug where a notice appears for each time
// the pool table or pool related tables are used
error_reporting(E_ERROR | E_WARNING | E_PARSE);

if(isset($_POST['action'])){

	if($_POST['action'] == "add_pool"){
		if(isset($_POST['pool_name'])){

			$date = gmdate("Y-m-d H:i:s");

			// $sth = SQL_QUERY("
			// 		insert into 
			// 			pools set 
			// 			name='".SQL_CLEAN($_POST['pool_name'])."'  
			// 			, description='".SQL_CLEAN($_POST['description'])."'
			// 			, share_level='".SQL_CLEAN($_POST['share_level'])."'
			// 			, date_created='".SQL_CLEAN($date)."'
			// 			, user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."'
			// 			, is_active=1
			// 	");

			// $id = SQL_INSERT_ID();

			$sth = SQL_QUERY("
					insert into 
						pools set 
						name='".SQL_CLEAN($_POST['pool_name'])."'  
						, date_created='".SQL_CLEAN($date)."'
						, user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."'
						, is_active=1
				");

			$id = SQL_INSERT_ID();

			$name = $_SESSION['user']['first_name'] . " " . $_SESSION['user']['last_name'];

			header("location: /pool_edit.php?id=".$id);

			echo json_encode(array('result'=>$sth, 'id'=>$id, 'date_created'=>$date, 'uploaded_by'=>$name));
		}
		else {
			echo json_encode("No name sent");
		}
	}
	elseif($_POST['action'] == "update_pool"){
		if(isset($_POST['pool_id'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("
					update  
						pools set 
						name='".SQL_CLEAN($_POST['pool_name'])."'  
						, description='".SQL_CLEAN($_POST['description'])."'
						, share_level='".SQL_CLEAN($_POST['share_level'])."'
						, date_updated=NOW()
						, is_active='".SQL_CLEAN($_POST["is_active"])."' 
						where pool_id=".SQL_CLEAN($_POST["pool_id"])."
				");

			$name = $_SESSION['user']['first_name'] . " " . $_SESSION['user']['last_name'];
			header("location: /contact_pool.php");


		}
		else {
			echo json_encode("No name sent");
		}
	}
	elseif($_POST['action'] == "delete_pool"){
		if(isset($_POST['pool_id'])){

			$sth = SQL_QUERY("delete from pools where pool_id=".SQL_CLEAN($_POST["pool_id"]));

			echo $sth;
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "call_lead"){
		if(isset($_POST['pool_lead_id'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("insert into pool_lead_contact_log set 
						pool_lead_id='".SQL_CLEAN($_POST['pool_lead_id'])."'  
						, user_id='".SQL_CLEAN($_SESSION['user_id'])."'
						, date_created='".SQL_CLEAN($date)."'
						, contact_note='Number called: ".SQL_CLEAN($_POST['number'])."<br>'
						, pool_contact_method_id=1");

			$id = SQL_INSERT_ID();

			echo $id;
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "add_log_note"){
		if(isset($_POST['pool_lead_id'])){

			$date = gmdate("Y-m-d H:i:s");

				
				$sth = SQL_QUERY("select *, (NOW() - date_created) as 'time_diff' from pool_lead_contact_log "."
					where date_created > (NOW() - INTERVAL 30 MINUTE) 
					and pool_lead_id=".SQL_CLEAN($_POST['pool_lead_id'])." 
					order by time_diff DESC limit 1 ");

				if (SQL_NUM_ROWS($sth) > 0) {

					$data = SQL_ASSOC_ARRAY($sth);

					$sth = SQL_QUERY("update pool_lead_contact_log set 
							contact_note='".SQL_CLEAN($_POST['note'])."' 
							where pool_lead_contact_log_id='".SQL_CLEAN($data['pool_lead_contact_log_id'])."'");
				}
				else {
					$sth = SQL_QUERY("insert into pool_lead_contact_log set 
								pool_lead_id='".SQL_CLEAN($_POST['pool_lead_id'])."'  
								, user_id='".SQL_CLEAN($_SESSION['user_id'])."'
								, date_created='".SQL_CLEAN($date)."'
								, contact_note='".SQL_CLEAN($_POST['note'])."'
								, pool_contact_method_id=1");
				}

				echo $sth;

		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "claim_lead"){
		if(isset($_POST['pool_lead_id'])){

			// die(var_dump($_POST['phones']));

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("select * from pool_leads where pool_lead_id=".SQL_CLEAN($_POST["pool_lead_id"]));

			$pool_lead_data = SQL_ASSOC_ARRAY($sth);

			// Start copy

			$sth = SQL_QUERY("
					insert into 
						contacts set 
						first_name='".SQL_CLEAN($pool_lead_data['first_name'])."'  
						, last_name='".SQL_CLEAN($pool_lead_data['last_name'])."'
						, city='".SQL_CLEAN($pool_lead_data['city'])."'
						, county='".SQL_CLEAN($pool_lead_data['county'])."'
						, state='".SQL_CLEAN($pool_lead_data['state'])."'
						, zip='".SQL_CLEAN($pool_lead_data['zip'])."'
						, street_address='".SQL_CLEAN($pool_lead_data['address_line_1']) . "<br>" . SQL_CLEAN($pool_lead_data['address_line_2'])."'
						, pool_lead_id='".SQL_CLEAN($pool_lead_data['pool_lead_id'])."'
						, company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'
						, date_created=NOW()
				");

			$contact_id = SQL_INSERT_ID();

			SQL_QUERY("
					insert into 
						contacts_rel_users set 
						contact_id='".SQL_CLEAN($contact_id)."'  
						, user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."'
						, date_assigned=NOW()
						, is_primary=1
				");

			SQL_QUERY("
					insert into 
						contact_emails set 
						contact_id=".$contact_id."
						, is_primary=1 
						, email='".SQL_CLEAN($pool_lead_data['email'])."'");

			SQL_QUERY("
					update  
						pool_leads set 
						contact_id='".SQL_CLEAN($contact_id)."'  
						, is_active = 0 
						where pool_lead_id=".SQL_CLEAN($_POST["pool_lead_id"])."
				");

			$ctr = 0;

			for($i = 0; $i < count($_POST['phones']); $i++) {
				$sth = "
					insert into 
						contact_phones set 
						contact_id=".$contact_id."
						, phone_number='".SQL_CLEAN($_POST['phones'][$i])."'";

				if($ctr == 0) {
					$sth .= ", is_primary=1 ";
					$ctr++;
				}

				SQL_QUERY($sth);

			}

			header("location: /contacts_edit.php?id=".$contact_id."&pool_lead=true");
			
		}
		else {
			echo json_encode("No id sent");
		}
	}
	else {
		echo json_encode("Something is wrong");
	}

}

exit;

	
?>