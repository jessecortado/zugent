<?php

require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");
require_once($_SERVER['SITE_DIR']."/includes/common.php");
$social_app_config = parse_ini_file($_SERVER['SITE_DIR']."/etc/site_config.ini",true);


    $linkedIn = new Happyr\LinkedIn\LinkedIn(
        $social_app_config['LinkedIn']['client_id'],
        $social_app_config['LinkedIn']['client_secret']
    );

    if ($linkedIn->isAuthenticated()) {

        // Get User LinkedIn ID & Token from Database
        $sth = SQL_QUERY("select linkedin_id,linkedin_token from users 
            where company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' and 
            user_id = '".SQL_CLEAN($_SESSION['user_id'])."' limit 1
            ");

        while ($data = SQL_ASSOC_ARRAY($sth)) {
            $linkedin_id = $data['linkedin_id'];
            $linkedin_token = $data['linkedin_token'];
        }

        if ($linkedin_token == '') {
            //we know that the user is authenticated now. Start query the API
            $user = $linkedIn->get('v1/people/~:(id,firstName,lastName,public-profile-url,picture-urls::(original))');
            // $user = $linkedIn->get('v1/me');
            
            $profile_picture_url = ($user['pictureUrls']['values'][0] != '') ? $user['pictureUrls']['values'][0] : '';

            // echo "<pre>";
            // print_r($user);
            // echo "<br>";
            // print_r($profile_picture_url);
            // echo "</pre>";
            // die('---test---');


            // Update User LinkedIn ID
            SQL_QUERY("update users set 
                url_linkedin='".SQL_CLEAN($user['publicProfileUrl'])."', 
                linkedin_id='".SQL_CLEAN($user['id'])."', 
                linkedin_token='".SQL_CLEAN($linkedIn->getAccessToken())."', 
                linkedin_profilepic_url='".SQL_CLEAN($profile_picture_url)."' 
                where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and user_id=".SQL_CLEAN($_SESSION['user_id']));
        }

        header('Location: /my_profile.php');
        exit;
    }
    elseif ($linkedIn->hasError()) {
        if ($_GET['error'] != "user_cancelled_authorize") {
            email_error_alert(
                "LinkedIn Link Error!", 
                "while trying to link on linkedIn", 
                $_GET['error_description']
            );

            header('Location: /my_profile.php?code=8xli');
        }
        else {
            header('Location: /my_profile.php');
        }

        exit;
    }

    //if not authenticated
    $linkedinUrl = $linkedIn->getLoginUrl();
    header('Location: '.$linkedinUrl);

?>