<?php
    
require_once($_SERVER['SITE_DIR']."/includes/common.php");

    // Update User Facebook ID
    SQL_QUERY("update users set linkedin_id='', linkedin_token='', linkedin_profilepic_url=''
        where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and 
        user_id=".SQL_CLEAN($_SESSION['user_id'])
    );

    header('Location: /my_profile.php');

?>