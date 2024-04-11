<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");

auth();

$fb = new Facebook\Facebook([
	'app_id' => '215683345613958',
	'app_secret' => 'fc3a9c0967861472278470eaeeca1093',
	'default_graph_version' => 'v2.2',
]);
$helper = $fb->getRedirectLoginHelper();
// $user = $response->getGraphUser();

try {
	$accessToken = $helper->getAccessToken();
} catch(Facebook\Exceptions\FacebookResponseException $e) {
	// When Graph returns an error
	echo 'Graph returned an error: ' . $e->getMessage();
	exit;
} catch(Facebook\Exceptions\FacebookSDKException $e) {
	// When validation fails or other local issues
	echo 'Facebook SDK returned an error: ' . $e->getMessage();
	exit;
}
 
if (! isset($accessToken)) {
	if ($helper->getError()) {
		header('HTTP/1.0 401 Unauthorized');
		echo "Error: " . $helper->getError() . "\n";
		echo "Error Code: " . $helper->getErrorCode() . "\n";
		echo "Error Reason: " . $helper->getErrorReason() . "\n";
		echo "Error Description: " . $helper->getErrorDescription() . "\n";
	} else {
		header('HTTP/1.0 400 Bad Request');
		echo 'Bad request';
	}
	exit;
}
// Logged in
// The OAuth 2.0 client handler helps us manage access tokens
$oAuth2Client = $fb->getOAuth2Client();
 
// Get the access token metadata from /debug_token
$tokenMetadata = $oAuth2Client->debugToken($accessToken);
 
// Get user’s Facebook ID
$userId = $tokenMetadata->getField('user_id');

if ($userId > 0) {
	$sth = SQL_QUERY("select * from users where facebook_id='".SQL_CLEAN($userId)."' limit 1");
	if (SQL_NUM_ROWS($sth) != 0) {
		header("location: /my_profile.php?code=00x38");
		exit;
	}

	$_SESSION['user']['facebook_id'] = $userId;

	$sth = SQL_QUERY("update users set facebook_id='".SQL_CLEAN($userId)."' where user_id='".SQL_CLEAN($_SESSION['user_id'])."' limit 1");
	header("location: /my_profile.php");
	exit;
}

header("location: /login.php?code=2x099");
exit;



	
?>