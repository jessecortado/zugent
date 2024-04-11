<?php
    
require_once($_SERVER['SITE_DIR']."/includes/common.php");

    // Update User Facebook ID
    SQL_QUERY("update users set twitter_token='', twitter_token_secret='' 
        where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and 
        user_id=".SQL_CLEAN($_SESSION['user_id'])
    );

    header('Location: /my_profile.php');

?>