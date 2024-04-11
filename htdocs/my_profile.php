<?php

require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");
require_once($_SERVER['SITE_DIR']."/includes/common.php");
$social_app_config = parse_ini_file($_SERVER['SITE_DIR']."/etc/site_config.ini",true);


// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}
	
auth();

$user_id = $_SESSION['user_id'];

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


// FACEBOOK LINK - START
// Get User Facebook ID & Token from Database
/*
$sth = SQL_QUERY("select facebook_id,facebook_token,linkedin_id,linkedin_token,twitter_token,twitter_token_secret from users 
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

	$smarty->assign("error_facebook", false);
	$smarty->assign("social_error", false);

	// Check if has access token
	if (isset($facebook_token) && $facebook_token !== '') {

		try {

			$res = $fb_initiate->get('/me/accounts', $facebook_token);
			$res = $res->getDecodedBody();

			// Check response account details
			// foreach($res['data'] as $page){
			// 	echo $page['id'] . " - " . $page['name'] . "<br>";
			// }
          
		} catch( Facebook\Exceptions\FacebookSDKException $e ) {
			echo $e->getMessage();
			exit;
		}

		$smarty->assign('facebookUrl', '');

	}
	else {

		$helper = $fb_initiate->getRedirectLoginHelper();
		// $permissions = ['email', 'user_posts', 'manage_pages', 'publish_actions', 'publish_pages'];
		$permissions = ['user_posts', 'publish_actions', 'publish_pages'];
		$callback    = 'https://'.$_SERVER['HTTP_HOST'].'/services/social_accounts/link_facebook.php';
		$loginUrl    = $helper->getLoginUrl($callback, $permissions);
		$smarty->assign('facebookUrl', $loginUrl);
	}

} catch( Facebook\Exceptions\FacebookSDKException $e ) {
	// echo $e->getMessage();
	// exit;

	email_error_alert(
		"Facebook Link Error!", 
		"while trying to link on facebook", 
		$e->getMessage()
	);

	$smarty->assign("error_facebook", true);
	$smarty->assign("social_error", true);
}
// FACEBOOK LINK - END


// LINKEDIN LINK - START
$smarty->assign('linkedinUrl', '/services/social_accounts/link_linkedin.php');
$smarty->assign("error_linkedin", false);
// LINKEDIN LINK - END


// TWITTER LINK - START
try {

    $twitter = new Abraham\TwitterOAuth\TwitterOAuth(
        $social_app_config['Twitter']['consumer_key'],
        $social_app_config['Twitter']['consumer_secret']
    );

    $request_token = $twitter->oauth('oauth/request_token', array('oauth_callback' => 'https://'.$_SERVER['HTTP_HOST'].'/services/social_accounts/link_twitter.php'));

	if ($twitter->getLastHttpCode() == 200) {

	    $_SESSION['oauth_token'] = $request_token['oauth_token'];
		$_SESSION['oauth_token_secret'] = $request_token['oauth_token_secret'];

	    $url = $twitter->url('oauth/authorize', array('oauth_token' => $request_token['oauth_token']));

		$smarty->assign('twitterUrl', $url);
		$smarty->assign("error_twitter", false);
		$smarty->assign("social_error", false);

	} else {

        email_error_alert(
            "Twitter Link Error!", 
            "while trying to link on twitter", 
            "Twitter Error Code: ".$twitter->getLastHttpCode()
        );

		$smarty->assign("error_twitter", true);
		$smarty->assign("social_error", true);
	}

} catch (Exception $e) {

    email_error_alert(
        "Twitter Link Error!", 
        "while trying to link on twitter", 
        "Twitter Config Error!"
    );

	$smarty->assign("error_twitter", true);
	$smarty->assign("social_error", true);
}
// TWITTER LINK - END


// Check user social accounts if linked
$sth = SQL_QUERY("select facebook_id,linkedin_id,twitter_token,facebook_token,linkedin_token,twitter_token_secret from users 
    where company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' and 
    user_id = '".SQL_CLEAN($_SESSION['user_id'])."' limit 1
    ");

while ($data = SQL_ASSOC_ARRAY($sth)) {
    $user_facebook_account = $data['facebook_id'];
    $user_linkedin_account = $data['linkedin_id'];
    $user_twitter_account = $data['twitter_token'];
}


if(isset($_GET['code'])) {
	if($_GET['code'] == '8xfb') {
		$smarty->assign("error_facebook", true);
	}
	else if($_GET['code'] == '8xli') {
		$smarty->assign("error_linkedin", true);
	}
	else if($_GET['code'] == '8xtt') {
		$smarty->assign("error_twitter", true);
	}
	$smarty->assign("social_error", true);
}
*/

$smarty->assign('user', $_SESSION['user']);
$smarty->assign('user_facebook_account', $user_facebook_account);
$smarty->assign('user_linkedin_account', $user_linkedin_account);
$smarty->assign('user_twitter_account', $user_twitter_account);
$smarty->assign('timezones', get_timezones());
$smarty->assign('footer_js', 'includes/footers/profile.tpl');
$smarty->display('my_profile.tpl');

?>
