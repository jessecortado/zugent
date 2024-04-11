<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

if(isset($_GET['source'])){
	if($_GET['source'] == "my_profile") {
		change_picture();
	} 
}
elseif(isset($_POST['first_name'])){
	// die("ge");

		$sth = SQL_QUERY("update users set 
			first_name='".SQL_CLEAN($_POST['first_name'])."',
			last_name='".SQL_CLEAN($_POST['last_name'])."',
			email='".SQL_CLEAN($_POST['email'])."',
			url_facebook='".SQL_CLEAN($_POST['url_facebook'])."',
			url_twitter='".SQL_CLEAN($_POST['url_twitter'])."',
			bio='".SQL_CLEAN($_POST['bio'])."',
			street_address='".SQL_CLEAN($_POST['street_address'])."',
			state='".SQL_CLEAN($_POST['state'])."',
			city='".SQL_CLEAN($_POST['city'])."',
			zip='".SQL_CLEAN($_POST['zip'])."',
			phone_mobile='".SQL_CLEAN($_POST['phone_mobile'])."',
			phone_office='".SQL_CLEAN($_POST['phone_office'])."',
			phone_fax='".SQL_CLEAN($_POST['phone_fax'])."', 
			car_make='".SQL_CLEAN($_POST['car_make'])."', 
			car_model='".SQL_CLEAN($_POST['car_model'])."', 
			car_year='".SQL_CLEAN($_POST['car_year'])."', 
			car_license_num='".SQL_CLEAN($_POST['car_license_num'])."', 
			realtor_license_num='".SQL_CLEAN($_POST['realtor_license_num'])."',
			url_website='".SQL_CLEAN($_POST['url_website'])."',
			is_accepting_outside_referral='".SQL_CLEAN($_POST['accepting_outside_referral'])."' 
			where user_id='".SQL_CLEAN($_POST['user_id'])."'");

		// die("$sth");

		$sth = SQL_QUERY("select * from users where user_id=".$_SESSION['user_id']);
		$user_data = SQL_ASSOC_ARRAY($sth);
		$_SESSION['user'] = $user_data;


		if($_SESSION['user']['is_profile_photo'] == 1) {
			$smarty->assign("profile_url", 'https://s3-us-west-2.amazonaws.com/zugent/profilephotos/'.$_SESSION['user_id'].'/original.jpg');
		}
		else {
			if ($_SESSION['user']['url_profile_photo'] != '') {
				$smarty->assign("profile_url", $_SESSION['user']['url_profile_photo']);
			}
			else {
				$smarty->assign("profile_url", 'assets/img/user-13.jpg');
			}
		}
	
		$smarty->assign('user', $_SESSION['user']);
		$smarty->assign('footer_js', 'includes/footers/profile.tpl');
		$smarty->display('my_profile_edit.tpl');

		// change_picture();
}
else {

	if($_SESSION['user']['is_profile_photo'] == 1) {
		$smarty->assign("profile_url", 'https://s3-us-west-2.amazonaws.com/zugent/profilephotos/'.$_SESSION['user_id'].'/original.jpg');
	}
	else {
		if ($_SESSION['user']['url_profile_photo'] != '') {
			$smarty->assign("profile_url", $_SESSION['user']['url_profile_photo']);
		}
		else {
			$smarty->assign("profile_url", 'assets/img/user-13.jpg');
		}
	}
	
	$smarty->assign('user', $_SESSION['user']);
	$smarty->assign('footer_js', 'includes/footers/profile.tpl');
	$smarty->display('my_profile_edit.tpl');
}


function change_picture() {
	$sth = SQL_QUERY("update users set
		url_profile_photo='".SQL_CLEAN($_POST['url_profile_photo'])."',
		is_profile_photo=0 
		where user_id='".$_SESSION['user_id']."'");

	$sth = SQL_QUERY("select * from users where user_id=".$_SESSION['user_id']);
	$user_data = SQL_ASSOC_ARRAY($sth);
	$_SESSION['user'] = $user_data;

	header("location: /my_profile.php");
}
	
?>