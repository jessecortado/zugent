<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");


auth();

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}


if(isset($_POST['user_id'])){
    
    // Get User Details
	$user_info = SQL_QUERY("select * from users where user_id='".SQL_CLEAN($_POST['user_id'])."' and is_active=1 limit 1");

	if (SQL_NUM_ROWS($user_info) == 0) {
		header("location: /login.php?code=1x092");
		exit;
	}

	$user_data = SQL_ASSOC_ARRAY($user_info);


	$_SESSION['user_id'] = $user_data['user_id'];
	$_SESSION['user'] = $user_data;

            
	echo json_encode(true);
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1x0u7");
	}
}