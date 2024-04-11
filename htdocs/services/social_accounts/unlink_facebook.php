<?php
    
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");
require_once($_SERVER['SITE_DIR']."/includes/common.php");
$social_app_config = parse_ini_file($_SERVER['SITE_DIR']."/etc/site_config.ini",true);


    // Get User Facebook ID & Token from Database
    $sth = SQL_QUERY("select facebook_id,facebook_token from users 
        where company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' and 
        user_id = '".SQL_CLEAN($_SESSION['user_id'])."' limit 1
        ");

    while ($data = SQL_ASSOC_ARRAY($sth)) {
        $facebook_id = $data['facebook_id'];
        $facebook_token = $data['facebook_token'];
    }

    try {
        // Initiate Facebook API
        $fb_initiate = new Facebook\Facebook([
            'app_id'                => $social_app_config['Facebook']['app_id'],
            'app_secret'            => $social_app_config['Facebook']['secret_key'],
            'default_graph_version' => 'v2.2',
        ]);


        if(isset($facebook_token)) {
            $fb_initiate->setDefaultAccessToken($facebook_token);
        }

        try {

            // Delete User Permissions
            $response = $fb_initiate->delete(
                '/'.$facebook_id.'/permissions'
            );

            // Remove User Facebook ID & Facebook Token
            SQL_QUERY("update users set facebook_id='',facebook_token='',facebook_profilepic_url='' where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and user_id=".SQL_CLEAN($_SESSION['user_id']));

            header('Location: /my_profile.php');

        }
        catch(Facebook\Exceptions\FacebookResponseException $e) {
            
            email_error_alert(
                "Facebook Link Error!", 
                "while trying to unlink facebook", 
                'Graph returned an error: ' . $e->getMessage()
            );

            header('Location: /my_profile.php?code=8xfb');
            exit;
        }
        catch(Facebook\Exceptions\FacebookSDKException $e) {

            email_error_alert(
                "Facebook Link Error!", 
                "while trying to unlink facebook", 
                'Facebook SDK returned an error: ' . $e->getMessage()
            );

            header('Location: /my_profile.php?code=8xfb');
            exit;
        }

    } catch( Facebook\Exceptions\FacebookSDKException $e ) {

        email_error_alert(
            "Facebook Link Error!", 
            "while trying to unlink facebook", 
            $e->getMessage()
        );

        header('Location: /my_profile.php?code=8xfb');
        exit;
    }

?>