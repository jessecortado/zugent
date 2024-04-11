<?php
    
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");
require_once($_SERVER['SITE_DIR']."/includes/common.php");
$social_app_config = parse_ini_file($_SERVER['SITE_DIR']."/etc/site_config.ini",true);


    // Get User Twitter Token & Token Secret from Database
    $sth = SQL_QUERY("select twitter_token,twitter_token_secret from users 
        where company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' and 
        user_id = '".SQL_CLEAN($_SESSION['user_id'])."' limit 1
        ");

    while ($data = SQL_ASSOC_ARRAY($sth)) {
        $twitter_token = $data['twitter_token'];
        $twitter_token_secret = $data['twitter_token_secret'];
    }

    $twitter = new Abraham\TwitterOAuth\TwitterOAuth(
        $social_app_config['Twitter']['consumer_key'],
        $social_app_config['Twitter']['consumer_secret'],
        $twitter_token,
        $twitter_token_secret
    );

    // $content = $twitter->get('account/verify_credentials', ['tweet_mode' => 'extended', 'include_entities' => 'true']);

    $post = $twitter->post("statuses/update", ["status" => $_POST['message']]);

    // echo "<pre>";
    // print_r($post);
    // echo "</pre>";

    echo "Successfully tweeted.";

?>