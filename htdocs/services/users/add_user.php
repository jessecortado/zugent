<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1x0u7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['first_name']) && isset($_POST['email']) && isset($_POST['last_name'])){

	$date = gmdate("Y-m-d H:i:s");

	$sth = SQL_QUERY("select * from users where email='".SQL_CLEAN($_POST['email'])."'");

	if (SQL_NUM_ROWS($sth) > 0) {
		die("Email exists. Click <a href='/users_list.php'>here</a> to go back.");
		header("location: /users_list.php");
		exit;
	}

	$temp_pass = random_str(8);

	$sth = SQL_QUERY("
			insert into users set ".
				"first_name='".SQL_CLEAN($_POST['first_name']).
				"', last_name='".SQL_CLEAN($_POST['last_name']).
				"', email='".SQL_CLEAN($_POST['email']).
				"', company_id='".SQL_CLEAN($_SESSION['user']['company_id']).
				"', timezone='".SQL_CLEAN($_SESSION['company']['timezone']).
				"', is_admin=0".
				", is_active=1".
				", url_facebook='#'".
				", url_twitter='#'".
				", created_by_user_id=".SQL_CLEAN($_SESSION['user']['user_id']).
				", date_created='".SQL_CLEAN($date).
				"', source_id=".SQL_CLEAN($_SESSION['user_id']).
				", temporary_password='".password_hash($temp_pass, PASSWORD_DEFAULT).
				"'");

	$user_id = SQL_INSERT_ID();
         
    // Add new user log
    add_user_log("Added a new user (".$user_id.")", "login", array("importance" => "Critical", "action"=>"Add")  );
	
	// Send email to user
	$body = "Your RUOPEN account has been created.<br/>You can use the following temporary password on login.<br/><br/>".$temp_pass."<br/><br/>You can login <a href='https://crm.ruopen.com/login'>here</a> with your email address.";

	echo send_message("support@ruopen.com", 
		array($_POST['email']),
		"Your new RUOPEN account has been created.", 
		$body);

	header("location: /user_view.php?id=".$user_id);

}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1x0u7");
	}
}

?>
