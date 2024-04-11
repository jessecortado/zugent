<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");


auth();

if(isset($_POST['first_name'])){

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
			timezone='".SQL_CLEAN($_POST['timezone'])."',
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

            // echo json_encode($sth);
            
		header("location: /user_view.php?id=".$_POST['user_id']);
		exit;
}
else {
    echo "not set";
}