<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

if(isset($_POST['action'])){

	if($_POST['action'] == "add_office"){

		if(isset($_POST['name'])) {

		$sth = SQL_QUERY("insert into offices set is_active=1, 
							name='".SQL_CLEAN($_POST['name']).
							"', phone_office='".SQL_CLEAN($_POST['phone_office']).
							"', phone_fax='".SQL_CLEAN($_POST['phone_fax']).
							"', street_address='".SQL_CLEAN($_POST['street_address']).
							"', state='".SQL_CLEAN($_POST['state']).
							"', city='".SQL_CLEAN($_POST['city']).
							"', zip='".SQL_CLEAN($_POST['zip']).
							"', company_id=".$_SESSION['user']['company_id']
						);

		$_SESSION['user'][$column] = SQL_CLEAN($_POST['value']);

		header("location: /offices.php");

		// echo json_encode(array("result"=>$sth));

		}
		
	}

	elseif ($_POST['action'] == "edit_office") {
		
		$column = SQL_CLEAN($_POST['column']);

		$sth = SQL_QUERY("Update offices set $column='".SQL_CLEAN($_POST['value'])."' where office_id=".SQL_CLEAN($_POST['id']));

		echo json_encode(array("result"=>$sth));

	}

	elseif ($_POST['action'] == "set_is_active") {

		$sth = SQL_QUERY("Update offices set is_active='".SQL_CLEAN($_POST['is_active'])."' where office_id=".SQL_CLEAN($_POST['id']));

		// header("location: /offices.php");

		// echo json_encode(array("result"=>$sth));

	}

	elseif ($_POST['action'] == "add_user_office") {

		// Anti 
		$sth = SQL_QUERY("select office_id from offices where company_id=".$_SESSION['user']['company_id']." and office_id=".SQL_CLEAN($_POST['office_id']));

		if (SQL_NUM_ROWS($sth) == 0)
			exit;

		$sth = SQL_QUERY("insert into user_rel_offices set  
							user_id=".SQL_CLEAN($_POST['user_id']).
							", office_id=".SQL_CLEAN($_POST['office_id']).""
						);

		$id = SQL_INSERT_ID();

		echo json_encode(array("result"=>$sth, "id"=>$id));

	}

	elseif ($_POST['action'] == "remove_user_from_office") {

		$sth = SQL_QUERY("Delete from user_rel_offices where  
							user_rel_office_id=".SQL_CLEAN($_POST['user_rel_office_id'])
						);

		echo json_encode(array("result"=>$sth));

	}

	elseif ($_POST['action'] == "add_contact_office") {

		// Anti 
		$sth = SQL_QUERY("select office_id from offices where company_id=".$_SESSION['user']['company_id']." and office_id=".SQL_CLEAN($_POST['office_id']));

		if (SQL_NUM_ROWS($sth) == 0)
			exit;

		$sth = SQL_QUERY("insert into contact_rel_offices set  
							contact_id=".SQL_CLEAN($_POST['contact_id']).
							", office_id=".SQL_CLEAN($_POST['office_id']).""
						);

		$id = SQL_INSERT_ID();

		echo json_encode(array("result"=>$sth, "id"=>$id));

	}

	elseif ($_POST['action'] == "remove_contact_from_office") {

		$sth = SQL_QUERY("Delete from contact_rel_offices where  
							contact_rel_office_id=".SQL_CLEAN($_POST['contact_rel_office_id'])
						);

		echo json_encode(array("result"=>$sth));

	}

}
else
	echo json_encode("No Action Sent");


exit;

	
?>