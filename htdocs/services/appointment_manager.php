<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

if(isset($_POST['action'])){

	if($_POST['action'] == "add_appointment_type"){
		if(isset($_POST['appointment_type'])){
			$sth = SQL_QUERY("
					insert into 
						appointment_types set
						appointment_type='".SQL_CLEAN($_POST['appointment_type'])."', company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'
				");

			$appointment_type_id = SQL_INSERT_ID();

			echo json_encode(array('result'=>$sth, 'appointment_type_id'=>$appointment_type_id, 'appointment_type'=>$_POST['appointment_type']));
		}
		else {
			echo json_encode("No appointment type name sent");
		}
	}

	elseif($_POST['action'] == "disable_appointment_type"){

		if(isset($_POST['appointment_type_id'])){
			$sth = SQL_QUERY("
					update appointment_types set
						is_active=0 where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and appointment_type_id=".$_POST['appointment_type_id']."
				");

			echo json_encode(array('result'=>$sth, 'appointment_type_id'=>$_POST['appointment_type_id']));
		}
		else {
			echo json_encode("No appointment type id sent");
		}
	}

	elseif($_POST['action'] == "activate_appointment_type"){
		

		if(isset($_POST['appointment_type_id'])){
			$sth = SQL_QUERY("
					update appointment_types set
						is_active=1 where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and appointment_type_id=".$_POST['appointment_type_id']."
				");

			echo json_encode(array('result'=>$sth, 'appointment_type_id'=>$_POST['appointment_type_id']));
		}
		else {
			echo json_encode("No appointment type id sent");
		}
	}

	elseif($_POST['action'] == "edit_appointment_type"){

		if(isset($_POST['appointment_type_id'])){
			$sth = SQL_QUERY("
					update appointment_types set
						appointment_type='".SQL_CLEAN($_POST['appointment_type'])."' where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and appointment_type_id=".SQL_CLEAN($_POST['appointment_type_id']));

			echo json_encode(array("text" => "Success", "sent" => $_POST));

		}
		else {
			echo json_encode(array("text" => "No appointment type id sent (edit_appointment_type)", "sent" => $_POST));
		}
	}
	
	elseif($_POST['action'] == "add_appointment"){
		if(isset($_POST['appointment_type_id'])){

			$date = gmdate("Y-m-d H:i:s", strtotime(SQL_CLEAN($_POST['date_appointment'])));
			$send_result = array();

			$sth = SQL_QUERY("
					insert into 
						contact_appointments set
						appointment_type_id='".SQL_CLEAN($_POST['appointment_type_id']).
						"', date_appointment='".$date.
						"', contact_id='".SQL_CLEAN($_POST['contact_id']).
						"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
						"', description='".SQL_CLEAN($_POST['description'])."'
				");

			$id = SQL_INSERT_ID();

			$sth = SQL_QUERY("
					select u.user_id, u.email as user_email, CONCAT(c.first_name,' ',c.last_name) as contact_name from contacts_rel_users as cu 
						left join users as u on cu.user_id=u.user_id 
						left join contacts as c on c.contact_id=cu.contact_id 
						where cu.contact_id=".SQL_CLEAN($_POST['contact_id'])." and cu.is_deleted=0
				");

			while($data = SQL_ASSOC_ARRAY($sth)) {

				$body = $_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." has scheduled a follow-up / contact for you and ".$data['contact_name'].".";
				$body .= "\nClick <a href='".$_SERVER['HTTP_HOST']."/appointment_action.php?id=".$id."'>here</a> to copy this this follow-up / contact schedule to your calendar or to decline this schedule.";
				
				$send_result[] = send_message("support@ruopen.com", 
											array($data['user_email'], "juncalpito@zugent.com"), 
												"A new follow-up / contact has been scheduled for your contact", 
											$body);

				$body = $_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." has scheduled a follow-up / contact for you and ".$data['contact_name'].".";

				// id, title, notification, url_action
				add_notification($data['user_id'], "New Appointment", $body, $_SERVER['HTTP_HOST']."/appointment_action.php?id=".$id);
			}

			header("location: /contacts_edit.php?id=".$_POST['contact_id']."#panel-appointments");

			echo json_encode(array('result'=>$sth, 'sent'=>$_POST, 'send_result'=>$send_result));
		}
		else {
			echo json_encode("No appointment type id sent");
		}
	}

	elseif($_POST['action'] == "edit_appointment"){

		if(isset($_POST['contact_appointment_id'])){

			$date = gmdate("Y-m-d H:i:s", strtotime(SQL_CLEAN($_POST['date_appointment'])));
			$now = gmdate("Y-m-d H:i:s");

			//get old data and compare
			$sth = SQL_QUERY("
					select * from contact_appointments where contact_appointment_id=".SQL_CLEAN($_POST['contact_appointment_id']));

			$old = SQL_ASSOC_ARRAY($sth);

			$comment = "Appointment was updated on ". $now . " (" . $_SESSION['user']['user_id']."). The ff. changes were made: <br>";

			if($old['date_appointment'] !== $date)
				$comment .= "From " . $old['date_appointment'] . " to " .  $date . "<br>";
			if($old['description'] !== $_POST['description'])
				$comment .= "Description was changed";
				// $comment .= "From " . $old['description'] . " to " . $_POST['description'] . "<br>";
			if($old['appontment_type_id'] !== $_POST['appointment_type_id'])
				$comment .= "From " . $old['appointment_type_id'] . " to " . $_POST['appointment_type_id'];
			
			$sth = SQL_QUERY("
					update contact_appointments  set
						appointment_type_id='".SQL_CLEAN($_POST['appointment_type_id']).
						"', date_appointment='".$date.
						"', contact_id='".SQL_CLEAN($_POST['contact_id']).
						"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
						"', description='".SQL_CLEAN($_POST['description']).
						"' where contact_appointment_id=".SQL_CLEAN($_POST['contact_appointment_id']));

			$sth2 = SQL_QUERY("
					insert into 
						contact_comments set
						comment='".$comment.
						"', contact_id='".SQL_CLEAN($_POST['contact_id']).
						"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
						"', date_added='".$now."'
				");

			$appointment_type_id = SQL_INSERT_ID();

			echo json_encode(array('result'=>$sth, 'sent'=>$_POST));

			header("location: /contacts_edit.php?id=".$_POST['contact_id']."#panel-appointments");

			echo json_encode(array("text" => "Success", "sent" => $_POST));

		}
		else {
			echo json_encode(array("text" => "No appointment type id sent (edit_appointment_type)", "sent" => $_POST));
		}
	}

	elseif($_POST['action'] == "complete_appointment"){

		if(isset($_POST['contact_appointment_id'])){

			$date = gmdate("Y-m-d H:i:s");
			$sth = SQL_QUERY("update contact_appointments set is_completed='1', date_completed='".$date."' where contact_appointment_id=".SQL_CLEAN($_POST['contact_appointment_id']));

			$comment = "<p><b>Appointment completed by ".$_SESSION['user']['first_name']." ".$_SESSION['user']['last_name'].".</b></p>\n<p>".SQL_CLEAN($_POST['completion_notes'])."</p>";

			$sth2 = SQL_QUERY("
					insert into 
						contact_comments set
						comment='".$comment.
						"', contact_id='".SQL_CLEAN($_POST['contact_id']).
						"', is_history='1".
						"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
						"', date_added='".$date."'
				");

			// header("location: /contacts_edit.php?id=".$_POST['contact_id']);

			echo json_encode(array("text"=>"Success", "sent" => $_POST));

		}
		else {
			echo json_encode(array("text" => "No contact appointment id sent (complete_appointment)", "sent" => $_POST, "comment" => $comment));
		}
	}

	elseif($_POST['action'] == "get_appointment_comments"){

		if(isset($_POST['contact_appointment_id'])){

			$sth = SQL_QUERY("
				select
					cac.*, u.first_name, u.last_name
				from contact_appointment_comments as cac
				left join users as u using(user_id) 
				where cac.contact_appointment_id='".SQL_CLEAN($_POST['contact_appointment_id'])."'
				
			");

			$contact_appointment_comments = array();
			while ($data = SQL_ASSOC_ARRAY($sth)) {
				$data['date_comment'] = date_format(new DateTime(convert_to_local($data['date_comment'])), "M d, Y h:i a");
				$contact_appointment_comments[] = $data;
			}

			echo json_encode(array("data"=>$contact_appointment_comments));

		}
		else {
			echo json_encode(array("text" => "No contact appointment id sent (complete_appointment)", "sent" => $_POST));
		}
	}

	elseif($_POST['action'] == "add_appointment_comment"){

		if(isset($_POST['contact_appointment_id'])){

			$date = gmdate("Y-m-d H:i:s");

			$sth = SQL_QUERY("
					insert into 
						contact_appointment_comments set
						comment='".SQL_CLEAN($_POST['comment']).
						"', contact_appointment_id='".SQL_CLEAN($_POST['contact_appointment_id']).
						"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
						"', date_comment='".$date."'
				");

			// header("location: /contacts_edit.php?id=".$_POST['contact_id']);

			echo json_encode(array("text"=>"Success", "sent" => $_POST));

		}
		else {
			echo json_encode(array("text" => "No contact appointment id sent (complete_appointment)", "sent" => $_POST));
		}
	}

	elseif($_POST['action'] == "cancel_appointment"){

		if(isset($_POST['contact_appointment_id'])){

			$date = gmdate("Y-m-d H:i:s");
			$sth = SQL_QUERY("update contact_appointments set is_completed='0', is_cancelled='1', date_completed='".$date."' where contact_appointment_id=".SQL_CLEAN($_POST['contact_appointment_id']));

			$comment = "<p><b>Appointment cancelled by ".$_SESSION['user']['first_name']." ".$_SESSION['user']['last_name'].".</b></p>";

			$sth2 = SQL_QUERY("
					insert into 
						contact_comments set
						comment='".$comment.
						"', contact_id='".SQL_CLEAN($_POST['contact_id']).
						"', is_history='1".
						"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
						"', date_added='".$date."'
				");

			// header("location: /contacts_edit.php?id=".$_POST['contact_id']);

			echo json_encode(array("text"=>"Success", "sent" => $_POST, "comment" => $comment));

		}
		else {
			echo json_encode(array("text" => "No contact appointment id sent (cancel appointment)", "sent" => $_POST));
		}
	}

	elseif($_POST['action'] == "uncancel_appointment"){

		if(isset($_POST['contact_appointment_id'])){

			$date = gmdate("Y-m-d H:i:s");
			$sth = SQL_QUERY("update contact_appointments set is_cancelled='0' where contact_appointment_id=".SQL_CLEAN($_POST['contact_appointment_id']));

			$comment = "<p><b>Appointment uncancelled by ".$_SESSION['user']['first_name']." ".$_SESSION['user']['last_name'].".</b></p>";
			// $comment .= "<p>".SQL_CLEAN($_POST['completion_notes'])."</p>";

			$sth2 = SQL_QUERY("
					insert into 
						contact_comments set
						comment='".$comment.
						"', contact_id='".SQL_CLEAN($_POST['contact_id']).
						"', is_history='1".
						"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
						"', date_added='".$date."'
				");

			// header("location: /contacts_edit.php?id=".$_POST['contact_id']);

			echo json_encode(array("text"=>"Success", "sent" => $_POST, "comment" => $comment));

		}
		else {
			echo json_encode(array("text" => "No contact appointment id sent (uncancel appointment)", "sent" => $_POST));
		}
	}

	else {
		echo json_encode("Action Not Found");
	}


}
else {
	echo json_encode("No action");
}

exit;

	
?>