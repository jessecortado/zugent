<?php

require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");
require_once($_SERVER['SITE_DIR']."/includes/common.php");
$social_app_config = parse_ini_file($_SERVER['SITE_DIR']."/etc/site_config.ini",true);


    $request_token = [];
    $request_token['oauth_token'] = $_SESSION['oauth_token'];
    $request_token['oauth_token_secret'] = $_SESSION['oauth_token_secret'];

    $twitter = new Abraham\TwitterOAuth\TwitterOAuth(
        $social_app_config['Twitter']['consumer_key'],
        $social_app_config['Twitter']['consumer_secret'],
        $request_token['oauth_token'],
        $request_token['oauth_token_secret']
    );

    if (isset($_REQUEST['oauth_token']) && $request_token['oauth_token'] !== $_REQUEST['oauth_token']) {

        email_error_alert(
            "Twitter Link Error!", 
            "while trying to link on twitter", 
            "No Access Token"
        );

        header('Location: /my_profile.php?code=8xtt');
    }
    else if (isset($_REQUEST['oauth_token']) && $request_token['oauth_token'] == $_REQUEST['oauth_token']) {

        $access_token = $twitter->oauth("oauth/access_token", ["oauth_verifier" => $_REQUEST['oauth_verifier']]);

        // Update User Twitter Token
        SQL_QUERY("update users set twitter_token='".SQL_CLEAN($access_token['oauth_token'])."', twitter_token_secret='".SQL_CLEAN($access_token['oauth_token_secret'])."' where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and user_id=".SQL_CLEAN($_SESSION['user_id']));

        header('Location: /my_profile.php');
    }
?>