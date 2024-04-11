<?php
    
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");
require_once($_SERVER['SITE_DIR']."/includes/common.php");
$social_app_config = parse_ini_file($_SERVER['SITE_DIR']."/etc/site_config.ini",true);

    if (isset($_REQUEST['error_code'])) {
        if ($_REQUEST['error_code'] != '4201') {

            email_error_alert(
                "Facebook Link Error!", 
                "while trying to link on facebook", 
                $_REQUEST['error_message']
            );

            header('Location: /my_profile.php?code=8xfb');
        }
        else {
            header('Location: /my_profile.php');
        }

        exit;
    }

    // Initiate Facebook API (LOCALHOST)
    $fb_initiate = new Facebook\Facebook([
        'app_id'                => $social_app_config['Facebook']['app_id'],
        'app_secret'            => $social_app_config['Facebook']['secret_key'],
        'default_graph_version' => 'v2.2',
    ]);


    $helper = $fb_initiate->getRedirectLoginHelper();

    try {

        $accessToken = $helper->getAccessToken();

    }
    catch(Facebook\Exceptions\FacebookSDKException $e) {

        // echo $e->getMessage();

        email_error_alert(
            "Facebook Link Error!", 
            "while trying to link on facebook", 
            $e->getMessage()
        );

        header('Location: /my_profile.php?code=8xfb');
        exit;

    }
    
    if (isset($accessToken)) {
    
        $cilent = $fb_initiate->getOAuth2Client();
        
        try {

            $accessToken = $cilent->getLongLivedAccessToken($accessToken);

            $fb_initiate->setDefaultAccessToken($accessToken);
            
            // Get User Facebook ID
            // $profile_request = $fb_initiate->get('/me?fields=name,first_name,last_name,email');
            $profile_request = $fb_initiate->get('/me?fields=id,name,email,picture.width(150).height(150)');
            $profile = $profile_request->getGraphNode()->asArray();

        } 
        catch(Facebook\Exceptions\FacebookSDKException $e) {

            // echo $e->getMessage();

            email_error_alert(
                "Facebook Link Error!", 
                "while trying to link on facebook", 
                $e->getMessage()
            );

            header('Location: /my_profile.php?code=8xfb');
            exit;

        }

        $profile_picture_url = ($profile['picture']['url'] != '') ? $profile['picture']['url'] : '';

        // echo "<pre>";
        // print_r($profile);
        // echo "</pre>";
        // die('---test---');

        // Update User Facebook ID
        SQL_QUERY("update users set 
            facebook_id='".SQL_CLEAN($profile['id'])."', 
            facebook_token='".SQL_CLEAN((string) $accessToken)."', 
            facebook_profilepic_url='".SQL_CLEAN($profile_picture_url)."' 
            where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and user_id=".SQL_CLEAN($_SESSION['user_id']));


        if (isset($_GET['state'])) {
            $helper->getPersistentDataHandler()->set('state', $_GET['state']);
        }

        header('Location: /my_profile.php');
        
    }
    elseif ($helper->getError()) {

        email_error_alert(
            "Facebook Link Error!", 
            "while trying to link on facebook", 
            "Sorry, You cannot use the app without these permissions."
        );

        header('Location: /my_profile.php?code=8xfb');
        exit;
    }

?>